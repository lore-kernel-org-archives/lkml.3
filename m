Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaCMSEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801AbaCMSE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:04:29 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v3 0/4] irq: sun4i IRQ 0 / ENMI fixes
Date: Thu, 13 Mar 2014 19:03:50 +0100
Message-Id: <1394733834-26839-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Here is v3 of my sun4i IRQ 0 / ENMI fixes patch-set, changelog below:

v2:

PATCH 1/4 irq: Add handle_fasteoi_late_irq irq handler
New patch by Thomas Gleixner, adding a new irq handler with the "call eoi
after the irq-handler has run its course" behavior we need to avoid double
irqs on the ENMI.

PATCH 2/4 irqchip: sun4i: Fix irq 0 not working
Modified to avoid spurious calls to the irq 0 handler, as suggested by Maxime.

PATCH 3/4 irqchip: sun4i: Fix a comment about mask register
Added Maxime's Acked-by

PATCH 4/4 irqchip: sun4i: Use handle_fasteoi_late_irq for the
New patch switching the handler for irq 0 over to the new
handle_fasteoi_late_irq handler, thereby fixing the double interrupts issue


v3:

PATCH 1/4 irq: Add a new IRQCHIP_EOI_THREADED flag
New patch by Thomas Gleixner, replacing his "irq: Add handle_fasteoi_late_irq
irq handler" patch.

PATCH 2/4 irqchip: sun4i: Fix irq 0 not working
Added Maxime's Acked-by

PATCH 4/4 irqchip: sun4i: Don't ack IRQs != 0, fix acking of IRQ
New patch replacing my "irqchip: sun4i: Use handle_fasteoi_late_irq ..."
patch. This also drops acking for IRQ != 0. I've done both changes in
one patch to avoid regressing for IRQ 0.


Thanks for all the help to all involved.

Regards,

Hans
