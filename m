Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbaGVWXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:23:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44490 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609AbaGVWX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:23:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: ChiaHao <andy.jhshiu@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 087/116] arm64: Bug fix in stack alignment exception
Date: Tue, 22 Jul 2014 15:21:38 -0700
Message-Id: <1406067727-19683-88-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChiaHao <andy.jhshiu@gmail.com>

commit 3906c2b53cd23c2ae03e6ce41432c8e7f0a3cbbb upstream.

The value of ESR has been stored into x1, and should be directly pass to
do_sp_pc_abort function, "MOV x1, x25" is an extra operation and do_sp_pc_abort
will get the wrong value of ESR.

Signed-off-by: ChiaHao <andy.jhshiu@gmail.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/kernel/entry.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 9c94f40..9e3d509 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -274,7 +274,6 @@ el1_sp_pc:
 	 * Stack or PC alignment exception handling
 	 */
 	mrs	x0, far_el1
-	mov	x1, x25
 	mov	x2, sp
 	b	do_sp_pc_abort
 el1_undef:
-- 
1.9.1

