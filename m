Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab3IFPcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:32:43 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:54826 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab3IFPcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:32:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexander Holler <holler@ahsoftware.de>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
Date: Fri, 06 Sep 2013 17:32:43 +0200
Message-ID: <2966898.neCKEkcf1e@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CACRpkdavR=fv+y1RCNfdgQypPuRbO6isOSwGsABDrYiGeMdyZw@mail.gmail.com>
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <344239800.bDEkDg48ZQ@avalon> <CACRpkdavR=fv+y1RCNfdgQypPuRbO6isOSwGsABDrYiGeMdyZw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for the late reply.

On Thursday 22 August 2013 00:02:39 Linus Walleij wrote:
> On Tue, Aug 20, 2013 at 12:04 AM, Laurent Pinchart wrote:
> > On Wednesday 31 July 2013 01:44:53 Linus Walleij wrote:
> >> I don't see how sharing works here, or how another user, i.e. another one
> >> than the user wanting to recieve the IRQ, can validly request such a
> >> line? What would the usecase for that valid request be?
> > 
> > When the GPIO is wired to a status signal (such as an MMC card detect
> > signal) the driver might want to read the state of the signal
> > independently of the interrupt handler.
> 
> That is true. But for such a complex usecase I think it's reasonable that
> we only specify the GPIO in the device tree, and the driver utilizing the
> IRQ need to take that and perform gpio_to_irq() on it, and then it still
> works to use it both ways.

I'm pretty sure I would have had an objection a couple of weeks ago when I was 
looking into this, but I can't think of another use case for now, so I agree 
with you.

> >> Basically I believe these two things need to be exclusive in the DT
> >> world:
> >> 
> >> A: request_irq(a resource passed from "interrupts");
> >>      -> core implicitly performs gpio_request()
> >>          gpio_direction_input()
> >> 
> >> B: gpio_request(a resource passed from "gpios");
> >>      gpio_direction_input()
> >>      request_irq(gpio_to_irq())
> >> 
> >> Never both. And IIUC that was what happened in the OMAP case.
> > 
> > Isn't the core issue that we can translate a GPIO number to an IRQ number,
> > but not the other way around ? If that could be done, we could request
> > the GPIO and configure it as an input when the IRQ is requested.
> 
> That is true. It would be easier if all GPIO drivers has an irqchip and
> and irqdomain, then we could implement irq_to_gpio() properly in gpiolib
> and this would not be a problem. Alas, not all do.
> 
> But I also think that the DT contains (as demonstrated by the patch)
> all information about what interrupts and GPIOs may conflict, so I
> also see this as something of a consistency check, but it could go
> in either way.

-- 
Regards,

Laurent Pinchart
