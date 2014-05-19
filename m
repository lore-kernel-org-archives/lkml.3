Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbaESOBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:01:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:37823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbaESOBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:01:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,867,1392192000"; 
   d="scan'208";a="534215261"
Message-ID: <537A117A.7050802@linux.intel.com>
Date: Mon, 19 May 2014 17:13:14 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Courbot <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bin.yang@intel.com, Darren Hart <dvhart@linux.intel.com>,
        "Holmberg, Hans" <hans.holmberg@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] gpio: Add support for Intel SoC PMIC (Crystal Cove)
References: <1400082247-24168-1-git-send-email-lejun.zhu@linux.intel.com> <CACRpkdZ67KoaMWUzpPm5g7yvQ-_q9zxuS+4wcXP0u18MW=XovA@mail.gmail.com> <53794FDC.6080908@linux.intel.com>
In-Reply-To: <53794FDC.6080908@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 03:27 AM, Zhu, Lejun wrote:
> 
> 
> On 5/17/2014 1:33 AM, Linus Walleij wrote:
>> On Wed, May 14, 2014 at 5:44 PM, Zhu, Lejun <lejun.zhu@linux.intel.com> wrote:
>>
>>> Devices based on Intel SoC products such as Baytrail have a Power
>>> Management IC. In the PMIC there are subsystems for voltage regulation,
>>> A/D conversion, GPIO and PWMs. The PMIC in Baytrail-T platform is called
>>> Crystal Cove.
>>>
>>> This patch adds support for the GPIO function in Crystal Cove.
>>>
>>> Signed-off-by: Yang, Bin <bin.yang@intel.com>
>>> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
>>
>> (...)
>>
>>> +config GPIO_INTEL_SOC_PMIC
>>> +       bool "GPIO on Intel SoC PMIC"
>>> +       depends on INTEL_SOC_PMIC
> 
> Thank you. That's a long list and all of them indeed need to be fixed.
> I'll work on them and submit v2 when ready.
> 

Shouldn't there be a .remove function undoing everything probe did?
Freeing interrupts, removing irq domains, calling gpiochip_remove etc.

Or is there something I'm missing?
I see there's no option to compile this as module, but It might be added later so
proper remove function would still be nice.

-Mathias





