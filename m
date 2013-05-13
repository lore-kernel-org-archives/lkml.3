Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3EMK4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:56:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab3EMK4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:56:33 -0400
Date: Mon, 13 May 2013 12:57:49 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/1] powerpc: Fix irq_set_affinity() return values
Message-ID: <20130513105748.GA27077@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/powerpc/platforms/wsp/ics.c    |    2 +-
 arch/powerpc/sysdev/ehv_pic.c       |    2 +-
 arch/powerpc/sysdev/mpic.c          |    2 +-
 arch/powerpc/sysdev/xics/ics-opal.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/wsp/ics.c b/arch/powerpc/platforms/wsp/ics.c
index 97fe82e..2d3b1dd 100644
--- a/arch/powerpc/platforms/wsp/ics.c
+++ b/arch/powerpc/platforms/wsp/ics.c
@@ -361,7 +361,7 @@ static int wsp_chip_set_affinity(struct irq_data *d,
 	xive = xive_set_server(xive, get_irq_server(ics, hw_irq));
 	wsp_ics_set_xive(ics, hw_irq, xive);
 
-	return 0;
+	return IRQ_SET_MASK_OK;
 }
 
 static struct irq_chip wsp_irq_chip = {
diff --git a/arch/powerpc/sysdev/ehv_pic.c b/arch/powerpc/sysdev/ehv_pic.c
index 6e0e100..9cd0e60 100644
--- a/arch/powerpc/sysdev/ehv_pic.c
+++ b/arch/powerpc/sysdev/ehv_pic.c
@@ -81,7 +81,7 @@ int ehv_pic_set_affinity(struct irq_data *d, const struct cpumask *dest,
 	ev_int_set_config(src, config, prio, cpuid);
 	spin_unlock_irqrestore(&ehv_pic_lock, flags);
 
-	return 0;
+	return IRQ_SET_MASK_OK;
 }
 
 static unsigned int ehv_pic_type_to_vecpri(unsigned int type)
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index d30e6a6..20f6625 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -836,7 +836,7 @@ int mpic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 			       mpic_physmask(mask));
 	}
 
-	return 0;
+	return IRQ_SET_MASK_OK;
 }
 
 static unsigned int mpic_type_to_vecpri(struct mpic *mpic, unsigned int type)
diff --git a/arch/powerpc/sysdev/xics/ics-opal.c b/arch/powerpc/sysdev/xics/ics-opal.c
index f7e8609..39d7221 100644
--- a/arch/powerpc/sysdev/xics/ics-opal.c
+++ b/arch/powerpc/sysdev/xics/ics-opal.c
@@ -148,7 +148,7 @@ static int ics_opal_set_affinity(struct irq_data *d,
 		       __func__, d->irq, hw_irq, server, rc);
 		return -1;
 	}
-	return 0;
+	return IRQ_SET_MASK_OK;
 }
 
 static struct irq_chip ics_opal_irq_chip = {
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
