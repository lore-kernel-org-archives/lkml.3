Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab3FGXEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:04:00 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45610 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620Ab3FGXDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:50 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 12/31] MIPS: Add instruction format information for WAIT, MTC0, MFC0, et al.
Date: Fri,  7 Jun 2013 16:03:16 -0700
Message-Id: <1370646215-6543-13-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

---
 arch/mips/include/uapi/asm/inst.h | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/uapi/asm/inst.h b/arch/mips/include/uapi/asm/inst.h
index 0f4aec2..133abc1 100644
--- a/arch/mips/include/uapi/asm/inst.h
+++ b/arch/mips/include/uapi/asm/inst.h
@@ -117,7 +117,8 @@ enum bcop_op {
 enum cop0_coi_func {
 	tlbr_op	      = 0x01, tlbwi_op	    = 0x02,
 	tlbwr_op      = 0x06, tlbp_op	    = 0x08,
-	rfe_op	      = 0x10, eret_op	    = 0x18
+	rfe_op	      = 0x10, eret_op	    = 0x18,
+	wait_op	      = 0x20
 };
 
 /*
@@ -567,6 +568,24 @@ struct b_format {			/* BREAK and SYSCALL */
 	;)))
 };
 
+struct c0_format {			/* WAIT, TLB?? */
+	BITFIELD_FIELD(unsigned int opcode : 6,
+	BITFIELD_FIELD(unsigned int co : 1,
+	BITFIELD_FIELD(unsigned int code : 19,
+	BITFIELD_FIELD(unsigned int func : 6,
+	;))))
+};
+
+struct c0m_format {			/* MTC0, MFC0, ... */
+	BITFIELD_FIELD(unsigned int opcode : 6,
+	BITFIELD_FIELD(unsigned int func : 5,
+	BITFIELD_FIELD(unsigned int rt : 5,
+	BITFIELD_FIELD(unsigned int rd : 5,
+	BITFIELD_FIELD(unsigned int code : 8,
+	BITFIELD_FIELD(unsigned int sel : 3,
+	;))))))
+};
+
 struct ps_format {			/* MIPS-3D / paired single format */
 	BITFIELD_FIELD(unsigned int opcode : 6,
 	BITFIELD_FIELD(unsigned int rs : 5,
@@ -857,6 +876,8 @@ union mips_instruction {
 	struct f_format f_format;
 	struct ma_format ma_format;
 	struct b_format b_format;
+	struct c0_format c0_format;
+	struct c0m_format c0m_format;
 	struct ps_format ps_format;
 	struct v_format v_format;
 	struct fb_format fb_format;
-- 
1.7.11.7

