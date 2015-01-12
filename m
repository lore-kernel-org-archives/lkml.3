Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbbALNQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:16:10 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:48320 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbbALNQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:16:07 -0500
Date: Mon, 12 Jan 2015 08:16:02 -0500
From: Tejun Heo <tj@kernel.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SATA link power management issues
Message-ID: <20150112131602.GX25319@htj.dyndns.org>
References: <3352987.ugV1Ipy7Z5@xps13>
 <20150109220018.GH2785@htj.dyndns.org>
 <20150109220253.GI2785@htj.dyndns.org>
 <1437237.yiFxI2gUSM@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1437237.yiFxI2gUSM@xps13>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

What you're experiencing looks like the ssd behaving badly after link
state transition.  I wonder whether the right solution is plugging
PHYRDY IRQ for a while after LPM state change.  Does the following
path make any difference?

Thanks.

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 97683e4..684f45d 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -735,8 +735,8 @@ static int ahci_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 		sata_link_scr_lpm(link, policy, false);
 
 		/* turn PHYRDY IRQ back on */
-		pp->intr_mask |= PORT_IRQ_PHYRDY;
-		writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+		//pp->intr_mask |= PORT_IRQ_PHYRDY;
+		//writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
 	}
 
 	return 0;

-- 
tejun
