Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3HWJv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:51:28 -0400
Received: from smtp2-1.goneo.de ([212.90.139.83]:47987 "EHLO smtp2-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab3HWJv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:51:26 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.744
From: Lars Poeschel <poeschel@lemonage.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2] gpio: interrupt consistency check for OF GPIO IRQs
Date: Fri, 23 Aug 2013 11:51:18 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, galak@codeaurora.org,
        Pawel Moll <pawel.moll@arm.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
References: <1377092334-770-1-git-send-email-larsi@wh2.tu-dresden.de> <CACRpkdbVYfBS5L+0ejfbTBwPbD9HFB1kV8qnS7DdSydRccxDmg@mail.gmail.com> <52167A35.2010109@wwwdotorg.org>
In-Reply-To: <52167A35.2010109@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308231151.18075.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 August 2013 at 22:53:09, Stephen Warren wrote:
> On 08/21/2013 05:27 PM, Linus Walleij wrote:
> > On Thu, Aug 22, 2013 at 1:10 AM, Stephen Warren <swarren@wwwdotorg.org> 
wrote:
> >>> On Wednesday 21 of August 2013 15:38:54 Lars Poeschel wrote:
> >>>> To solve this dilemma, perform an interrupt consistency check
> >>>> when adding a GPIO chip: if the chip is both gpio-controller and
> >>>> interrupt-controller, walk all children of the device tree,
> >> 
> >> It seems a little odd to solve this only for DT. What about the
> >> non-DT case?
> > 
> > DT is the hardware configuration system that lets you request
> > the same resource in two ways, i.e. it allows one and the same
> > node to be both gpio-controller and interrupt-controller, and
> > start handing out the same line as both GPIO and IRQ
> > independently.
> 
> Huh? What stops systems using board files and platform data from having
> this issue?

I am not 100% sure, Linus knows better.
I think nothing stops them from having this issue, but board files are 
gentle and request the GPIO before doing gpio_to_irq, because they know 
that they are using a gpio based interrupt.

You can read the whole story here:
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg91405.html
Things get interesting after the first mail from Alexander Holler, who is 
the first having a problem with the patch in the link.
