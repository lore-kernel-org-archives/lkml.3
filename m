Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab3FRPCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:02:53 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:43675 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab3FRPCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:02:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130618113606.GA26763@n2100.arm.linux.org.uk>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1347550912-18021-3-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130618113606.GA26763@n2100.arm.linux.org.uk>
Date: Tue, 18 Jun 2013 17:02:49 +0200
Message-ID: <CACRpkdZTVN2O-Rv4u-Ccb9EzV0At3zc7GYQyTq=HkseOi=GTeg@mail.gmail.com>
Subject: Re: [PATCH v4 02/10] pinctrl: mvebu: dove pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 1:36 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

> Maybe what we need is something like this:
>
> static DEFINE_SPINLOCK(io_lock);
> static void modifyl(u32 new, u32 mask, void __iomem *reg)
> {
>         unsigned long flags;
>         u32 val;
>
>         spin_lock_irqsave(&io_lock, flags);
>         val = readl(reg) & ~mask;
>         val |= new | mask;
>         writel(val, reg);
>         spin_unlock_irqrestore(&io_lock, flags);
> }
>
> in order to provide arbitrated access to these kinds of multifunction
> registers in a safe, platform agnostic way.

Nowadays I would do the above with regmap_update_bits().

Mutual exclusion for read-modify-write of individual bits in a
register is one of those cases where doing a regmap over
a memory-mapped register range makes a lot of sense.
(drivers/mfd/syscon.c being a nice example)

Yours,
Linus Walleij
