Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbaIOVAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:00:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbaIOT1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Burton <paul.burton@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 3.16 076/158] MIPS: CPS: Initialize EVA before bringing up VPEs from secondary cores
Date: Mon, 15 Sep 2014 12:25:15 -0700
Message-Id: <20140915192545.177179387@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit 6521d9a436a62e83ce57d6be6e5484e1098c1380 upstream.

The CPS code is doing several memory loads when configuring the VPEs
from secondary cores, so the segmentation control registers must be
initialized in time otherwise the kernel will crash with strange
TLB exceptions.

Reviewed-by: Paul Burton <paul.burton@imgtec.com>
Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Patchwork: http://patchwork.linux-mips.org/patch/7424/
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/cps-vec.S |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/mips/kernel/cps-vec.S
+++ b/arch/mips/kernel/cps-vec.S
@@ -13,6 +13,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/asmmacro.h>
 #include <asm/cacheops.h>
+#include <asm/eva.h>
 #include <asm/mipsregs.h>
 #include <asm/mipsmtregs.h>
 #include <asm/pm.h>
@@ -166,6 +167,9 @@ dcache_done:
 1:	jal	mips_cps_core_init
 	 nop
 
+	/* Do any EVA initialization if necessary */
+	eva_init
+
 	/*
 	 * Boot any other VPEs within this core that should be online, and
 	 * deactivate this VPE if it should be offline.


