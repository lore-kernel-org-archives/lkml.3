Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3IYGEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 02:04:08 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:45003 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3IYGEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 02:04:06 -0400
Message-ID: <52427CAE.8030600@linux.vnet.ibm.com>
Date: Wed, 25 Sep 2013 11:33:26 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org
Subject: Re: [PATCH 1/2] SDT markers listing by perf
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903073655.4793.20013.stgit@hemant-fedora> <87ioyht7e4.fsf@sejong.aot.lge.com> <5226E8F4.5060505@hitachi.com> <523599C2.6020204@linux.vnet.ibm.com> <5242687A.9030209@hitachi.com>
In-Reply-To: <5242687A.9030209@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092506-9574-0000-0000-000009C9B98A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 10:07 AM, Masami Hiramatsu wrote:
> (2013/09/15 20:28), Hemant wrote:
>> Hi Masami,
> Hi, and sorry for replying so late. I missed this in my mailbox.
>
>> On 09/04/2013 01:31 PM, Masami Hiramatsu wrote:
>>> (2013/09/04 15:42), Namhyung Kim wrote:
>>>> [SNIP]
>>>> You need to add it to Documentation/perf-probe.txt too.  In addition if
>>>> the --sdt option is only able to work with libelf, it should be wrapped
>>>> into the #ifdef LIBELF_SUPPORT pair.
>>>>
>>>> And I'm not sure that it's a good idea to have two behavior on a single
>>>> option (S) - show and probe (add).  Maybe it can be separated into two
>>>> or the S option can be used as a flag with existing --list and --add
>>>> option?
>>>>
>>> Good catch! :)
>>> No, that is really bad idea. All probes must be added by "--add" action.
>>> So we need a new probe syntax for specifying sdt marker.
>>>
>>> How about the below syntax?
>>>
>>> [EVENT=]%PROVIDER:MARKER [ARG ...]
>>>
>>> Of course, this will require to list up all markers with "%" prefix for
>>> continuity.
>>>
>>> And since --list option is to list up all existing(defined) probe events,
>>> I think --markers (as like as --funcs) is better for listing it up.
>>>
>>> Thank you!
>>>
>> I have one doubt here. Why do we need [ARG ...] in the syntax you
>> specified? I believe these args are to fetched from the sdt notes'
>> section of the elf of the executable/library. Or am I taking this in a
>> wrong way and this suggested syntax is actually for the uprobe_events
>> file in the tracing directory?
> Hm, indeed. Since all the arguments of the marker is defined in sdt notes,
> we actually don't need to specify each of them. However, other probe syntax
> has those arguments. I'd like to keep the same syntax style in the
> same command (action) for avoiding confusion.

Hmm, got it.

> I recommend this way; at the first step, we just find the marker address from
> sdt. And next, we will make the argument available. And eventually,
> it is better to introduce "$args" meta argument to fetch all the arguments
> of the marker.
>
> At this point, we can do
>
> perf probe %foo:bar $args

So, at first step (ignoring the arguments), we can go with :
perf probe %foo:bar

And, once, the argument support is enabled (all the arguments will be
fetched at the marker location), we can go with:
perf probe %foo:bar $args

>
> to trace full information from the marker foo:bar.
>
> Thank you,
>


-- 
Thanks
Hemant Kumar Shaw

