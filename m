Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab3ILI4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:56:47 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51481 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3ILI4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:56:45 -0400
Message-ID: <5231817F.8000901@ahsoftware.de>
Date: Thu, 12 Sep 2013 10:55:27 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130712 Thunderbird/17.0.7
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com> <344239800.bDEkDg48ZQ@avalon> <CACRpkdavR=fv+y1RCNfdgQypPuRbO6isOSwGsABDrYiGeMdyZw@mail.gmail.com> <52308C91.2000105@ahsoftware.de> <523096FE.8080901@collabora.co.uk> <5230AB6E.1070807@ahsoftware.de>
In-Reply-To: <5230AB6E.1070807@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.09.2013 19:42, schrieb Alexander Holler:
> Am 11.09.2013 18:14, schrieb Javier Martinez Canillas:

>> So for example in an OMAP board DT you can define something like this:
>>
>> ethernet@5,0 {
>>          compatible = "smsc,lan9221", "smsc,lan9115";
>>          interrupt-parent = <&gpio6>;
>>          interrupts = <16 8>;
>> };
>>
>> Since each OMAP GPIO bank has 32 GPIO pins, then what you are defining
>> is that
>> the GPIO 176 (5 * 32 + 16) will be mapped as the IRQ line for the
>> ethernet
>> controller.

By the way, how do you define two GPIOs/IRQs from different
gpio-banks/irq-controllers wuth that scheme?

Would that be like below?

 ethernet@5,0 {
          compatible = "smsc,lan9221", "smsc,lan9115";
          interrupt-parent = <&gpio6>;
          interrupts = <16 8>;
          interrupt-parent = <&gpio7>;
          interrupts = <1 IRQF_TRIGGER_FALLING>; /* GPIO7_1 */
 };

So multiple definitions of interrupt-parent are allowed and the order
does matter? And such does work? Sorry for asking, but I'm relatively
new to DT. ;)

Regards,

Alexander Holler
