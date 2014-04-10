Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583AbaDJNvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:51:17 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59252 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaDJNvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:51:12 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5346A1C7.609@roeck-us.net>
Date: Thu, 10 Apr 2014 06:51:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>
CC: wim@iguana.be, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk,
        Eric Ernst <eric.ernst@intel.com>
Subject: Re: [PATCH 1/2] watchdog: add Intel MID watchdog driver support
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com> <1396990744-10695-2-git-send-email-david.a.cohen@linux.intel.com> <53448CB4.6050705@infradead.org> <20140409174854.GC23274@psi-dev26.jf.intel.com>
In-Reply-To: <20140409174854.GC23274@psi-dev26.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 10:48 AM, David Cohen wrote:
> On Tue, Apr 08, 2014 at 04:56:36PM -0700, Randy Dunlap wrote:
>> On 04/08/2014 01:59 PM, David Cohen wrote:
>>> Add initial Intel MID watchdog driver support.
>>>
>>> This driver is an initial implementation of generic Intel MID watchdog
>>> driver. Currently it supports Intel Merrifield platform.
>>>
>>> Signed-off-by: Eric Ernst <eric.ernst@intel.com>
>>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>>> ---
>>>   drivers/watchdog/Kconfig         |  12 +++
>>>   drivers/watchdog/Makefile        |   1 +
>>>   drivers/watchdog/intel-mid_wdt.c | 209 +++++++++++++++++++++++++++++++++++++++
>>>   3 files changed, 222 insertions(+)
>>>   create mode 100644 drivers/watchdog/intel-mid_wdt.c
>>>
>>> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
>>> index 79d25894343a..4da09b8b2f11 100644
>>> --- a/drivers/watchdog/Kconfig
>>> +++ b/drivers/watchdog/Kconfig
>>> @@ -643,6 +643,18 @@ config INTEL_SCU_WATCHDOG
>>>
>>>   	  To compile this driver as a module, choose M here.
>>>
>>> +config INTEL_MID_WATCHDOG
>>> +	bool "Intel MID SCU Watchdog Mobile Platforms"
>>> +	depends on X86_INTEL_MID && WATCHDOG_CORE
>>> +	---help---
>>> +	  Watchdog timer driver built into the Intel SCU for Intel MID
>>> +	  Platforms.
>>> +
>>> +	  This driver currently supports only the watchdog evolution
>>> +	  implementation in SCU, available for Merrifield generation.
>>> +
>>> +	  To compile this driver as a module, choose M here.
>>
>> Does choosing M work when INTEL_MID_WATCHDOG is a bool?
>> and why is INTEL_MID_WATCHDOG a bool?
>
> The error here is the left over line from the template I used. There
> should be no mention about choosing M.
> It's bool because the watchdog is started by default on fw. We need this
> driver probed during boot to pet/kick/ping asap. IMHO It makes not much
> sense to compile it as module.
>

Is that true for your firmware, but for all users of the supported set
of devices ?

The reason for having modules is to be able to load the driver only
when needed, while using the same distribution for multiple platforms.
So either you are forcing the driver to be loaded on every hardware
which has it enabled, or you are limiting the scope of a distribution
to one specific CPU. Neither seems desirable.

If _you_ want to build the driver into the kernel, you always can.
But you have to have a better reason than that to enforce it on
everyone else.

Guenter

