Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab3FEVtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:49:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab3FEVfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 083/127] powerpc/tm: Make room for hypervisor in abort cause codes
Date: Wed,  5 Jun 2013 14:34:10 -0700
Message-Id: <20130605213227.376046500@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 35f7097fcedec63fcba1852dbee96f74a2d90878 upstream.

PAPR carves out 0xff-0xe0 for hypervisor use of transactional memory software
abort cause codes.  Unfortunately we don't respect this currently.

Below fixes this to move our cause codes to below this region.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/reg.h |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -113,14 +113,15 @@
 
 /* Reason codes describing kernel causes for transaction aborts.  By
    convention, bit0 is copied to TEXASR[56] (IBM bit 7) which is set if
-   the failure is persistent.
+   the failure is persistent.  PAPR saves 0xff-0xe0 for the hypervisor.
 */
-#define TM_CAUSE_RESCHED	0xfe
-#define TM_CAUSE_TLBI		0xfc
-#define TM_CAUSE_FAC_UNAV	0xfa
-#define TM_CAUSE_SYSCALL	0xf9 /* Persistent */
-#define TM_CAUSE_MISC		0xf6
-#define TM_CAUSE_SIGNAL		0xf4
+#define TM_CAUSE_PERSISTENT	0x01
+#define TM_CAUSE_RESCHED	0xde
+#define TM_CAUSE_TLBI		0xdc
+#define TM_CAUSE_FAC_UNAV	0xda
+#define TM_CAUSE_SYSCALL	0xd8  /* future use */
+#define TM_CAUSE_MISC		0xd6  /* future use */
+#define TM_CAUSE_SIGNAL		0xd4
 
 #if defined(CONFIG_PPC_BOOK3S_64)
 #define MSR_64BIT	MSR_SF


