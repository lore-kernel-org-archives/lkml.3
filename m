Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3IKPbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:31:02 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:39495 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab3IKPa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:30:59 -0400
Message-ID: <52308C91.2000105@ahsoftware.de>
Date: Wed, 11 Sep 2013 17:30:25 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130712 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com> <344239800.bDEkDg48ZQ@avalon> <CACRpkdavR=fv+y1RCNfdgQypPuRbO6isOSwGsABDrYiGeMdyZw@mail.gmail.com>
In-Reply-To: <CACRpkdavR=fv+y1RCNfdgQypPuRbO6isOSwGsABDrYiGeMdyZw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.08.2013 00:02, schrieb Linus Walleij:
> On Tue, Aug 20, 2013 at 12:04 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> On Wednesday 31 July 2013 01:44:53 Linus Walleij wrote:
> 
>>> I don't see how sharing works here, or how another user, i.e. another one
>>> than the user wanting to recieve the IRQ, can validly request such a line?
>>> What would the usecase for that valid request be?
>>
>> When the GPIO is wired to a status signal (such as an MMC card detect signal)
>> the driver might want to read the state of the signal independently of the
>> interrupt handler.
> 
> That is true. But for such a complex usecase I think it's reasonable that
> we only specify the GPIO in the device tree, and the driver utilizing the
> IRQ need to take that and perform gpio_to_irq() on it, and then it still
> works to use it both ways.

Hmm, the problem is that DT is seen as fixed. So if someone marks a GPIO
as an IRQ, it can never be used otherwise. So if you really go this way,
you should make this pretty clear in the documentation.

Looking from the other side, why do you want to mark GPIOs as IRQs in
the DT at all? And how will this be done? I found the way it was done in
the reverted patch very confusing because it needed an IRQ number. That
IRQ number depends on the mapping and isn't hw specific (and currently
just human doable because of the simple mapping).

Regards,

Alexander Holler
