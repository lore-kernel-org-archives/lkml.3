Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaICR5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 13:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbaICR46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 13:56:58 -0400
Message-ID: <54075663.8090204@redhat.com>
Date: Wed, 03 Sep 2014 13:56:51 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Peter Tyser <ptyser@xes-inc.com>
CC: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] x86, lpc, Allow only one load of lpc_ich
References: <1409695097-5831-1-git-send-email-prarit@redhat.com> <54070842.2000700@redhat.com> <20140903155718.GA26776@roeck-us.net> <1598720.9R5g9ohVoY@petert>
In-Reply-To: <1598720.9R5g9ohVoY@petert>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/03/2014 01:29 PM, Peter Tyser wrote:
>>>>>> Then why do they [have two devices specified]?
>>>>>
>>>>> Because the vendor didn't/forgot to hide one from the kernel in BIOS --
>>>>> hence FW_BUG.
>>>>
>>>> If only one is useful, why have the second one in the first place?
>>>
>>> That's just it -- it shouldn't have been exposed (again, according to
>>> Intel).> 
>>>> If the devices are present and we can see them, why not have 2?  Some
>>>> users might find a use for them.
>>>
>>> No one will.
>>
>> Really ? I must be the "no one" then.
>>
>> If available, I like using two watchdogs: One to be controlled by, say,
>> systemd, one to be controlled by the watchdog daemon. If I have three, I
>> might find use for it as well: One more to be controlled by whatever
>> application is running on the system.

IMO you're conflating a general system watchdog with the iTCO watchdog.  They're
two very different things.

http://h50146.www5.hp.com/products/software/oe/linux/mainstream/support/whitepaper/pdfs/c03231796.pdf

>>
>> Sure, that may be considered overkill, but declaring that "no one will use
>> them" if more than one watchdog is available is just not correct. After
>> all, there was a _reason_ for introducing the capability to support more
>> than one watchdog into the watchdog subsystem.

I thought that was to get all the various watchdogs (NMI, softlockup, fs, etc)
using the same functionality?  But I do see your point.

>>
>> Similar, if there are multiple LPCs with separate GPIO pins on each in the
>> system, I don't entirely understand why the GPIO pins on the second chip
>> would or should be declared to be unusable. Why ?

Hmm ... good question.  I'll have to see whether or not ACPI, etc., can even
distinguish between two.

> 
> I agree with Guenter - I'd like to support and use as many watchdogs and GPIOs 
> as available.  High reliability applications often have 2 watchdogs as a data 
> point, and more GPIO is always nice!
> 
> Can you give more background on your hardware and firmware setup?  

Unfortunately I cannot :(  The system isn't "mine" per se.  It is (as the dumps
show) IBM's.

Are there
> physically two ICH bridges, or just one that is showing up two times due to a 
> firmware bug?  

I can answer that.  There are two physical ICH bridges, and according to Intel
one should be masked off.  We shouldn't run with two.


If there are two ICH bridges, how are they wired up to your CPU?

Again, not sure if I can answer that :/.

P.
