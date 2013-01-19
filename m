Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab3ASHoO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 02:44:14 -0500
Received: from solarsail.media.mit.edu ([18.85.2.155]:47852 "EHLO
	solarsail.media.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3ASHoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 02:44:13 -0500
Message-ID: <50FA4EC7.6060402@laptop.org>
Date: Fri, 18 Jan 2013 21:44:07 -1000
From: Mitch Bradley <wmb@laptop.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Andres Salomon <dilinger@queued.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@in.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, techteam@lists.laptop.org,
        Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Techteam] [RFC PATCH] x86-32: Start out eflags and cr4 clean
References: <87sjaaj3cx.fsf@xmission.com> <1348529239-17943-1-git-send-email-hpa@linux.intel.com> <20121010125927.0968dd8b@dev.queued.net> <20130118164043.29674d75@dev.queued.net> <50F9EBEA.9020805@linux.intel.com> <50F9F152.1000907@laptop.org> <50FA0661.2060400@linux.intel.com>
In-Reply-To: <50FA0661.2060400@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 1/18/2013 4:35 PM, H. Peter Anvin wrote:
> On 01/18/2013 05:05 PM, Mitch Bradley wrote:
>>
>>
>> On 1/18/2013 2:42 PM, H. Peter Anvin wrote:
>>> On 01/18/2013 04:40 PM, Andres Salomon wrote:
>>>> Bad news on this patch; I've been told that it breaks booting on an
>>>> XO-1.5.  Does anyone from OLPC know why yet?
>>>
>>> What are the settings of CR0 and CR4 on kernel entry on XO-1.5?
>>
>>
>> CR0 is 0x80000011
>> CR4 is 0x10
>>
> 
> OK, that makes sense... the kernel doesn't enable the PSE bit yet and I
> bet that's what you're using for the non-stolen page tables.

Indeed, we are using 4M pages to map the firmware into high virtual
addresses.

> 
> Can we simply disable paging before mucking with CR4?  The other option
> that I can see is to always enable PSE and PGE, since they are simply
> features opt-ins that don't do any harm if unused.  At the same time,
> though, entering the kernel through the default_entry path with paging
> enabled is definitely not anything the kernel expects.
> 
> Does this patch work for you?  Since we have ditched 386 support, we can
> mimic x86-64 (yay, one more difference gone!) and just use a predefined
> value for %cr0 (the FPU flags need to change if we are on an FPU-less
> chip, but that happens during FPU probing.)
> 
> Does this patch work for you?

We will test it and get back to you.

> 
> 	-hpa
> 
> 
> 
