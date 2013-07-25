Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3GYJU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:20:58 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40602 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3GYJUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:20:55 -0400
MIME-Version: 1.0
In-Reply-To: <1624911.6TtmtVmU1T@avalon>
References: <1624911.6TtmtVmU1T@avalon>
Date: Thu, 25 Jul 2013 11:20:54 +0200
Message-ID: <CACRpkdazPX3EbVbLvXQZh0oRBpHoWPK+EkFO75v9zfAXSPCkHA@mail.gmail.com>
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

On Wed, Jul 24, 2013 at 1:21 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:

> Has anyone run into a similar issue ? My gut feeling is that the architecture
> isn't right somewhere, but I can't really pinpoint where.

We had a similar situation with the MFDs, where Mark, Lee and Sam
came up with the solution to include an irqdomain in the MFD cell
spawn function:

extern int mfd_add_devices(struct device *parent, int id,
                           struct mfd_cell *cells, int n_devs,
                           struct resource *mem_base,
                           int irq_base, struct irq_domain *irq_domain);

When each cell (i.e. a platform device) is created, the irq for that
cell will be translated with irq_create_mapping() so the cell/platform
device just get a Linux IRQ it can use and do not need to worry
about translating it.

Prior to this we had all sorts of exported translator functions
for the IRQs exported from each hub driver ---what a mess.

Can you think about a parent/child relationship making it possible
to pass the irqs readily translated in this case?

Yours,
Linus Walleij
