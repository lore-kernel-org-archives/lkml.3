Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbaE2POd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:14:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37282 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143AbaE2POc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:14:32 -0400
Message-ID: <53875A4B.2060604@ti.com>
Date: Thu, 29 May 2014 19:03:23 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Courbot <gnurou@gmail.com>,
        "Zhu, Lejun" <lejun.zhu@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <jacob.jun.pan@linux.intel.com>, <bin.yang@intel.com>
Subject: Re: [PATCH v4] gpio: Add support for Intel SoC PMIC (Crystal Cove)
References: <1400810423-14067-1-git-send-email-lejun.zhu@linux.intel.com> <CAAVeFu+F=nHDCpL6Vfmq26QNr74mfRD5p9at_osB3R97v7xBSA@mail.gmail.com> <538459E8.6010701@ti.com> <20140527084615.GC1801@lahna.fi.intel.com> <53847F39.2010503@ti.com> <CACRpkdbe1=Yt3UDm9f4ZmZ+K2ZB9nVL+RNr7eU_TbnK-CmNY+A@mail.gmail.com> <20140529150058.GB6263@lahna.fi.intel.com>
In-Reply-To: <20140529150058.GB6263@lahna.fi.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On 05/29/2014 06:00 PM, Mika Westerberg wrote:
> On Thu, May 29, 2014 at 03:37:37PM +0200, Linus Walleij wrote:
>> My idea is that you should call gpiochip_add() *first* and then
>> add the IRQs to the chip. In succession.
>>
>> Rationale: with dynamic GPIO numbers, gpio_to_irq()
>> cannot reasonably be working before the gpiochip is added,
>> so it should be added first, then the irqchip. Since irq_to_gpio()
>> is *NOT* to be used (rather obliterated), this is the sequence
>> we mandate.
> 
> Thanks for the explanation. Makes sense.
> 

Thanks a lot Linus for your comments here :)

Also, I'd like to note that GPIO IRQs can be accessible not only
when GPIO chips is added, but also when IRQ domain is registered
(at least it's valid for DT cases). In these cases gpiod_to_irq()
might be not used at all.

Regards,
-grygorii

 

