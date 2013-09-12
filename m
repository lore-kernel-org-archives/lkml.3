Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3ILP5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:57:49 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:59888 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3ILP5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:57:47 -0400
Message-ID: <5231E44C.9070800@ahsoftware.de>
Date: Thu, 12 Sep 2013 17:57:00 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
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
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com> <344239800.bDEkDg48ZQ@avalon> <CACRpkdavR=fv+y1RCNfdgQypPuRbO6isOSwGsABDrYiGeMdyZw@mail.gmail.com> <52308C91.2000105@ahsoftware.de> <523096FE.8080901@collabora.co.uk> <5230AB6E.1070807@ahsoftware.de> <5231817F.8000901@ahsoftware.de> <5231934D.4060706@collabora.co.uk> <52319741.5050407@ahsoftware.de> <5231A0F8.1070505@ahsoftware.de> <5231A4FE.1070704@ahsoftware.de> <5231A791.9080600@ahsoftware.de> <5231DB88.90605@wwwdotorg.org>
In-Reply-To: <5231DB88.90605@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.09.2013 17:19, schrieb Stephen Warren:
>
> IRQs, DMA channels, and GPIOs are all different things. Their bindings
> are defined independently. While it's good to define new types of
> bindings consistently with other bindings, this hasn't always happened,
> so you can make zero assumptions about the IRQ bindings by reading the
> documentation for any other kind of binding.
>
> Multiple interrupts are defined as follows:
>
> 	// Optional; otherwise inherited from parent/grand-parent/...
> 	interrupt-parent = <&gpio6>;
> 	// Must be in a fixed order, unless binding defines that the
> 	// optional interrupt-names property is to be used.
> 	interrupts = <1 IRQF_TRIGGER_HIGH> <2 IRQF_TRIGGER_LOW>;
> 	// Optional; binding for device defines whether it must
> 	// be present
> 	interrupt-names = "foo", "bar";
>
> If you need multiple interrupts, each with a different parent, you need
> to use an interrupt-map property (Google it for a more complete
> explanation I guess). Unlike "interrupts", "interrupt-map" has a phandle
> in each entry, and hence each entry can refer to a different IRQ
> controller. You end up defining a dummy interrupt controller node (which
> may be the leaf node with multiple IRQ outputs, which then points at
> itself as the interrupt parent), pointing the leaf node's
> interrupt-parent at that node, and then having interrupt-map "demux" the
> N interrupt outputs to the various interrupt controllers.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

What a mess. I assume that is the price that bindings don't have to change.

Thanks for clarifying that,

Alexander Holler
