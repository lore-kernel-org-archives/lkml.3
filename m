Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab3JNQRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:17:38 -0400
Received: from relay1.sgi.com ([192.48.179.29]:56511 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab3JNQRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:17:36 -0400
Date: Mon, 14 Oct 2013 11:17:34 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: Russ Anderson <rja@sgi.com>
Subject: [PATCH] x86: Update UV3 hub revision ID
Message-ID: <20131014161733.GA6274@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UV3 hub revision ID is different than expected.  The first
revision was supposed to start at 1 but instead will start at 0.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2013-10-14 09:58:26.373016837 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2013-10-14 11:13:49.539994707 -0500
@@ -113,7 +113,7 @@ static int __init early_get_pnodeid(void
 		break;
 	case UV3_HUB_PART_NUMBER:
 	case UV3_HUB_PART_NUMBER_X:
-		uv_min_hub_revision_id += UV3_HUB_REVISION_BASE - 1;
+		uv_min_hub_revision_id += UV3_HUB_REVISION_BASE;
 		break;
 	}
 
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
