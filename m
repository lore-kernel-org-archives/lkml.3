Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab3KUSCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:02:16 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:49778 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KUSCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:02:14 -0500
X-AuditID: cbfec37c-b7fd86d00000670b-73-528e4aa51e9d
Message-id: <528E4A9A.2060908@samsung.com>
Date: Thu, 21 Nov 2013 11:02:02 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@rjwysocki.net,
        gregkh@linuxfoundation.org, anton@enomsg.org, dwmw2@infradead.org,
        fweisbec@gmail.com, mingo@redhat.com, keun-o.park@windriver.com,
        paul.gortmaker@windriver.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 2/2] PM: Fix Oops from NULL pointer dereference in
 wakeup_source_activate
References: <cover.1384990612.git.shuah.kh@samsung.com>
 <43b305b56bbbfc82b2684919e2d1ba2bd50fecae.1384990612.git.shuah.kh@samsung.com>
 <528D6972.9010702@samsung.com> <20131120212656.1df4515e@gandalf.local.home>
In-reply-to: <20131120212656.1df4515e@gandalf.local.home>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9hP92lXn1BBlNWcVgc3KppMXHlZGaL
	ma+7mSyaF69ns7jRep/FYtaUvUwWl3fNYbP43HuE0eLSgQVMFtf2Hme2uHvqKJvFmdOXWC32
	dTxgsvj608FiwcZHjA78HhP6PzF67Jx1l92jZd8tdo/NK7Q8Fu95yeSxf+4ado/3+66yeWy5
	2s7isWL1d3aPz5vkPNZv2coUwB3FZZOSmpNZllqkb5fAlbGzu4Wp4Dt3xddTx1gbGFs4uxg5
	OCQETCS+zuTqYuQEMsUkLtxbz9bFyMUhJLCMUeLXwwYWCKeXSWLhthZWCGcjo8SXdweYQVp4
	BbQkzs44yApiswioSrR+nM8OYrMJqEt8fr0DzBYSkJNoWrIarF5UIELi6OpnrBC9ghI/Jt9j
	AbFFBDQkWhY8B9vGLPCGSWLOxttMIAlhgXiJ2cuvsUAMusYo0btOAMTmFLCUOLXlHNhQZgFr
	iZWTtjFC2PISm9e8ZYaoV5b4c/kUE8SbihLbV1tNYBSZhWT1LCTds5B0L2BkXsUoVlqcXFCc
	lJ5aYaxXnJhbXJqXrpecn7uJERLPNTsY7321OcQowMGoxMO7w7IvSIg1say4MvcQowQHs5II
	71d1oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGM0vrmPY8t5u1Fs+1jWJ4Tid2i9n//tuisXDm
	nO83w75cuDXl2/OtScnqczecmsN60/ZFz4vfPI/8NFclz/77atJCN4H5nkyKe7PCdTIm3o/+
	rr035arhDEPZ5M7VM3r9Fp9VWKT4XtlScGeL9gHOpf9LfRY+nrBHjn2b1Mp353vXv0mfl5p6
	SomlOCPRUIu5qDgRAO10HwXFAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 07:26 PM, Steven Rostedt wrote:
> On Wed, 20 Nov 2013 19:01:22 -0700
> Shuah Khan <shuah.kh@samsung.com> wrote:
>
>> On 11/20/2013 06:40 PM, Shuah Khan wrote:
>
>>> ---
>>>    include/trace/events/power.h | 6 ++++--
>>>    1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/trace/events/power.h b/include/trace/events/power.h
>>> index cda100d..5ba545a 100644
>>> --- a/include/trace/events/power.h
>>> +++ b/include/trace/events/power.h
>>> @@ -110,12 +110,14 @@ DECLARE_EVENT_CLASS(wakeup_source,
>>>    	TP_ARGS(name, state),
>>>
>>>    	TP_STRUCT__entry(
>>> -		__string(       name,           name            )
>>> +		__string(name,  name ? name : "(no name)")
>>>    		__field(        u64,            state           )
>>>    	),
>>>
>>>    	TP_fast_assign(
>>> -		__assign_str(name, name);
>>> +		const char *tname = name ? name : "(no name)";
>>> +
>>> +		__assign_str(name, tname);
>>>    		__entry->state = state;
>>>    	),
>>>
>>>
>>
>> Adding tracing maintainers.
>
> Thanks!
>
> This is one solution, but what about just making the tracing facility a
> bit more robust for everyone. Following what glibc printf() does when
> it is passed a NULL, does this patch fix it too?
>

Why not? I am working to get the code compiling now. Will let you know 
if this works.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
