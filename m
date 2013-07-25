Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3GYNTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:19:35 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:55019 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab3GYNTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:19:33 -0400
MIME-Version: 1.0
In-Reply-To: <1408178.cxAUTUGJc5@avalon>
References: <1624911.6TtmtVmU1T@avalon>
	<CACRpkdazPX3EbVbLvXQZh0oRBpHoWPK+EkFO75v9zfAXSPCkHA@mail.gmail.com>
	<1408178.cxAUTUGJc5@avalon>
Date: Thu, 25 Jul 2013 15:19:32 +0200
Message-ID: <CACRpkdaNfFqzN0nYPrXd8ZVOFur6W2iEUSM_KErH6eKoiJ7vDQ@mail.gmail.com>
Subject: Re: How to create IRQ mappings in a GPIO driver that doesn't control
 its IRQ domain ?
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 11:45 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:

> The two devices are independent, so there's no real parent/child relationship.
> However, as Grant proposed, I could list all the interrupts associated with
> GPIOs in the GPIO controller DT node. I would then just call
> irq_of_parse_and_map() in the .to_irq() handler to magically translate the
> GPIO number to a mapped IRQ number.

That works even if the device tree will need a comment or two
to explain what is going on.

I suggested a similar solution for the OMAP crossbar mux
that is discussed in another thread, so I'm happy with this
approach.

Yours,
Linus Walleij
