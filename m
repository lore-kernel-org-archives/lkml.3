Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaJPJda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:33:30 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:38233 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaJPJd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:33:28 -0400
Message-ID: <543F90ED.5030005@linaro.org>
Date: Thu, 16 Oct 2014 10:33:33 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Drake <drake@endlessm.com>
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3.17-rc4 v7 0/6] arm: Implement arch_trigger_all_cpu_backtrace
References: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org> <CAD8Lp44gPOBh_q1zDy3y1GkrRVAvix5YaNr-+E92+g8Q7fLKJA@mail.gmail.com> <20141014233126.GF27405@n2100.arm.linux.org.uk>
In-Reply-To: <20141014233126.GF27405@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/14 00:31, Russell King - ARM Linux wrote:
> On Tue, Oct 14, 2014 at 04:37:51PM -0600, Daniel Drake wrote:
>> Hi,
>>
>> Thanks a lot for working on this!
>>
>> On Wed, Sep 17, 2014 at 10:10 AM, Daniel Thompson
>> <daniel.thompson@linaro.org> wrote:
>>> Changes *before* v1:
>>>
>>> * This patchset is a hugely cut-down successor to "[PATCH v11 00/19]
>>>   arm: KGDB NMI/FIQ support". Thanks to Thomas Gleixner for suggesting
>>>   the new structure. For historic details see:
>>>         https://lkml.org/lkml/2014/9/2/227
>>
>> What's the right way to extend your work in order to get a NMI-like
>> watchdog hard lockup detector similar to the one on x86?
>>
>> I'm testing your patches on Exynos4412 and I guess in their current
>> state they don't go quite this deep, as the only callers of
>> trigger_all_cpu_backtrace() are sysrq, hung_task and spinlock debug
>> code - none of which seem as fail-safe as a trigger like a
>> pre-programmed watchdog NMI interrupt would be.
>>
>> Do I need to find a way to get CONFIG_FIQ available on this platform
>> first? and/or CONFIG_HARDLOCKUP_DETECTOR?
> 
> The blocker on this work right now is the annoying Versatile Express
> platform, which pretty much means that we currently can't push the
> code into the GIC to support FIQs.  As long as adding FIQ support to
> the GIC results in the Versatile Express becoming non-bootable, the
> idea of using FIQs is a total non-starter.
> 
> Or we decide that we dump the platform completely (which will upset
> a number of developers.)
> 
> I have patches I'm using for trigger_all_cpu_backtrace() which I'm
> maintaining privately in my tree until we can get the FIQ situation
> sorted.

I do hope to gain (remote) access to a vexpress at some point just to
pick at this issue a little.

That said your previous description of the issue and of the GIC version
register leaves very little to explore!

In the end I'm expecting to have to use some kind of black list logic. I
assuming that vexpress by its nature as a bring up platform is more
likely to exhibit problems in this sort of area and therefore a black
list is more appropriate than a white list.


Daniel.

