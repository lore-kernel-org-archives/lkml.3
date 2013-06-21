Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946167Ab3FUVgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:36:25 -0400
Received: from relay2.sgi.com ([192.48.179.30]:52603 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946129Ab3FUVgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:36:24 -0400
Message-ID: <51C4C756.3040101@sgi.com>
Date: Fri, 21 Jun 2013 14:36:22 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Nathan Zimmer <nzimmer@sgi.com>, Greg KH <gregkh@linuxfoundation.org>,
        holt@sgi.com, rob@landley.net, tglx@linutronix.de, mingo@redhat.com,
        yinghai@kernel.org, akpm@linux-foundation.org, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <20130621165142.GA32125@kroah.com> <51C48745.9030304@zytor.com> <51C48ADD.207@sgi.com> <51C48D5A.4010602@zytor.com> <51C4B20B.20201@sgi.com> <4b9c45ed-15bd-49a9-b562-de01240d1649@email.android.com>
In-Reply-To: <4b9c45ed-15bd-49a9-b562-de01240d1649@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 6/21/2013 1:08 PM, H. Peter Anvin wrote:
> Is this init code?  32K of unconditional runtime addition isn't completely trivial.

The delay functions that move memory to the absent list are __init
but the read back of the list and memory insertion are not.  BTW, this
option is only available with the memory hotplug option which depends
on the sparse memory option.  So any usage of these distro configs will
normally be on enterprise class machines.

> 
> Nathan Zimmer <nzimmer@sgi.com> wrote:
> 
>> On 06/21/2013 12:28 PM, H. Peter Anvin wrote:
>>> On 06/21/2013 10:18 AM, Nathan Zimmer wrote:
>>>>> Since you made it a compile time option, it would be good to know
>> how
>>>>> much code it adds, but otherwise I agree with Greg here... this
>> really
>>>>> shouldn't need to be an option.  It *especially* shouldn't need to
>> be a
>>>>> hand-set runtime option (which looks quite complex, to boot.)
>>>> The patchset as a whole is just over 400 lines so it doesn't add
>> alot.
>>>> If I were to pull the .config option it would probably remove 30
>> lines.
>>> I'm more concerned about bytes of code.
>> Oh, The difference is just under 32k.
>> 371843425 Jun 21 14:08 vmlinux.o /* DELAY_MEM_INIT is not set  */
>> 371875600 Jun 21 14:36 vmlinux.o /* DELAY_MEM_INIT=y */
>>
>>>
>>>> The command line option is too complex but some of the data I
>> haven't
>>>> found a way to get at runtime yet.
>>> I think that is probably key.
>>>
>>>>> I suspect the cutoff for this should be a lot lower than 8 TB even,
>> more
>>>>> like 128 GB or so.  The only concern is to not set the cutoff so
>> low
>>>>> that we can end up running out of memory or with suboptimal NUMA
>>>>> placement just because of this.
>>>> Even at lower amounts of ram there is an positive impact.I it knocks
>>>> time off
>>>> boot even at as small as a 1TB of ram.
>>> I am not surprised.
>>>
>>> 	-hpa
>>>
> 
