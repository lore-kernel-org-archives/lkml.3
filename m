Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbaIILDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:03:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40717 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932149AbaIILDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:03:43 -0400
Date: Tue, 9 Sep 2014 12:03:00 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2 V4] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
Message-ID: <20140909110300.GD27786@leverpostej>
References: <1407942041-3291-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1407942041-3291-2-git-send-email-suravee.suthikulpanit@amd.com>
 <20140814175525.GI24018@leverpostej>
 <540E3639.5080807@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540E3639.5080807@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> >> @@ -1009,6 +1012,16 @@ gic_of_init(struct device_node *node, struct device_node *parent)
> >>          if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
> >>                  percpu_offset = 0;
> >>
> >> +       gic_data[gic_cnt].irq_chip = &gic_chip;
> >> +
> >> +       /* Currently, we only support one v2m subnode. */
> >> +       child = of_get_child_by_name(node, "v2m");
> >> +       if (child) {
> >> +               ret = gicv2m_of_init(child, &gic_data[gic_cnt]);
> >> +               if (ret)
> >> +                       return ret;
> >> +       }
> >
> > I can't see how you'd sanely expand this to multiple children, which was
> > the main point of having a separate node for the M block.
> >
> > Give the M block a compatible string and look for children with that
> > string.
> 
> Mark,
> 
> I am making change in the struct gic_chip_data to contain "v2m_list" (instead of just
> a single struct v2m_data). This way, it is clear on how we should handle multiple v2m nodes
> within a GIC.

Ok.

> As for the device tree binding, in order to handle multiple v2m nodes within a GIC,
> it should not require adding another compatibility ID as it seems too complicate
> to have GIC node with multiple compat IDs).

I don't follow.

How does each sub-node having a compatible string complicate the GIC
node?

Mark.
