Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935198AbaGRNQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:16:51 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17887 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935179AbaGRNQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:16:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ChiaHao <andy.jhshiu@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 104/170] arm64: Bug fix in stack alignment exception
Date: Fri, 18 Jul 2014 14:11:49 +0200
Message-Id: <443a109cb54f00f4541415c55a246a2ff8d42409.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ChiaHao <andy.jhshiu@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3906c2b53cd23c2ae03e6ce41432c8e7f0a3cbbb upstream.

The value of ESR has been stored into x1, and should be directly pass to
do_sp_pc_abort function, "MOV x1, x25" is an extra operation and do_sp_pc_abort
will get the wrong value of ESR.

Signed-off-by: ChiaHao <andy.jhshiu@gmail.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm64/kernel/entry.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 3881fd115ebb..028a1b91e2b3 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -275,7 +275,6 @@ el1_sp_pc:
 	 * Stack or PC alignment exception handling
 	 */
 	mrs	x0, far_el1
-	mov	x1, x25
 	mov	x2, sp
 	b	do_sp_pc_abort
 el1_undef:
-- 
2.0.0

