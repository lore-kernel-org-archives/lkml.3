Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaGZTtQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:49:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaGZTNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Heiko Stuebner <heiko@sntech.de>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 70/87] irqchip: gic: Add binding probe for ARM GIC400
Date: Sat, 26 Jul 2014 12:02:44 -0700
Message-Id: <20140726190216.892541554@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

commit 144cb08864ed44be52d8634ac69cd98e5efcf527 upstream.

Commit 3ab72f9156bb "dt-bindings: add GIC-400 binding" added the
"arm,gic-400" compatible string, but the corresponding IRQCHIP_DECLARE
was never added to the gic driver.

Therefore add the missing irqchip declaration for it.

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Removed additional empty line and adapted commit message to mark it
as fixing an issue.
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Will Deacon <will.deacon@arm.com>
Fixes: 3ab72f9156bb ("dt-bindings: add GIC-400 binding")
Link: https://lkml.kernel.org/r/2621565.f5eISveXXJ@diego
Signed-off-by: Jason Cooper <jason@lakedaemon.net>

---
 drivers/irqchip/irq-gic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1008,6 +1008,7 @@ int __init gic_of_init(struct device_nod
 	gic_cnt++;
 	return 0;
 }
+IRQCHIP_DECLARE(gic_400, "arm,gic-400", gic_of_init);
 IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
 IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
 IRQCHIP_DECLARE(cortex_a7_gic, "arm,cortex-a7-gic", gic_of_init);


