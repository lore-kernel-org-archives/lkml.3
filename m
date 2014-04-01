Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaDALRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:17:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42357 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaDALRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 057/144] powerpc: Align p_dyn, p_rela and p_st symbols
Date: Tue,  1 Apr 2014 12:14:21 +0100
Message-Id: <1396350948-29910-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit a5b2cf5b1af424ee3dd9e3ce6d5cea18cb927e67 upstream.

The 64bit relocation code places a few symbols in the text segment.
These symbols are only 4 byte aligned where they need to be 8 byte
aligned. Add an explicit alignment.

Signed-off-by: Anton Blanchard <anton@samba.org>
Tested-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/reloc_64.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/reloc_64.S b/arch/powerpc/kernel/reloc_64.S
index b47a0e1..c712ece 100644
--- a/arch/powerpc/kernel/reloc_64.S
+++ b/arch/powerpc/kernel/reloc_64.S
@@ -81,6 +81,7 @@ _GLOBAL(relocate)
 
 6:	blr
 
+.balign 8
 p_dyn:	.llong	__dynamic_start - 0b
 p_rela:	.llong	__rela_dyn_start - 0b
 p_st:	.llong	_stext - 0b
-- 
1.9.1

