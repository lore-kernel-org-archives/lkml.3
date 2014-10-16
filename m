Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaJPNPC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:15:02 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:56413 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaJPNPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:15:00 -0400
Message-ID: <543FC4DC.105@linaro.org>
Date: Thu, 16 Oct 2014 14:15:08 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Daniel Drake <drake@endlessm.com>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3.17-rc4 v7 0/6] arm: Implement arch_trigger_all_cpu_backtrace
References: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org> <CAD8Lp44gPOBh_q1zDy3y1GkrRVAvix5YaNr-+E92+g8Q7fLKJA@mail.gmail.com> <543F8EA8.6080905@linaro.org> <20141016122322.GO27405@n2100.arm.linux.org.uk>
In-Reply-To: <20141016122322.GO27405@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/14 13:23, Russell King - ARM Linux wrote:
> On Thu, Oct 16, 2014 at 10:23:52AM +0100, Daniel Thompson wrote:
>> On 14/10/14 23:37, Daniel Drake wrote:
>>> I'm testing your patches on Exynos4412 and I guess in their current
>>> state they don't go quite this deep, as the only callers of
>>> trigger_all_cpu_backtrace() are sysrq, hung_task and spinlock debug
>>> code - none of which seem as fail-safe as a trigger like a
>>> pre-programmed watchdog NMI interrupt would be.
>>>
>>> Do I need to find a way to get CONFIG_FIQ available on this platform
>>> first? and/or CONFIG_HARDLOCKUP_DETECTOR?
>>
>> You need CONFIG_FIQ working first. Be aware that this may be impossible
>> on Exynos unless you control the TrustZone. For this reason most of my
>> development is on Freescale i.MX6 (because i.MX6 boots in secure mode).
> 
> CONFIG_FIQ enables the legacy FIQ code which is unsuitable for use on
> SMP, so that should not be a requirement.

Sorry. That was rather stupid phrasing on my part.

What I mean is that before doing any other work related to FIQ one
should establish that the platform really is using FIQ to trigger
backtraces! On platforms where FIQ cannot be supported the code falls
back to using IRQs (making the IRQ handling easily spotted in the
backtrace).


