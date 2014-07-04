Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031767AbaGDXAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:00:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760601AbaGDWQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:16:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.15 48/66] powerpc: fix typo CONFIG_PPC_CPU
Date: Fri,  4 Jul 2014 15:14:47 -0700
Message-Id: <20140704221424.997183626@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit b69a1da94f3d1589d1942b5d1b384d8cfaac4500 upstream.

Commit cd64d1697cf0 ("powerpc: mtmsrd not defined") added a check for
CONFIG_PPC_CPU were a check for CONFIG_PPC_FPU was clearly intended.

Fixes: cd64d1697cf0 ("powerpc: mtmsrd not defined")
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/lib/sstep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -1470,7 +1470,7 @@ int __kprobes emulate_step(struct pt_reg
 				regs->gpr[rd] = byterev_4(val);
 			goto ldst_done;
 
-#ifdef CONFIG_PPC_CPU
+#ifdef CONFIG_PPC_FPU
 		case 535:	/* lfsx */
 		case 567:	/* lfsux */
 			if (!(regs->msr & MSR_FP))


