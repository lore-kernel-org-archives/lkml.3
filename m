Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaDAQb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:31:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44597 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaDAQPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:15:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 49/86] powerpc: Align p_dyn, p_rela and p_st symbols
Date: Tue,  1 Apr 2014 09:08:02 -0700
Message-Id: <1396368519-12728-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit a5b2cf5b1af424ee3dd9e3ce6d5cea18cb927e67 upstream.

The 64bit relocation code places a few symbols in the text segment.
These symbols are only 4 byte aligned where they need to be 8 byte
aligned. Add an explicit alignment.

Signed-off-by: Anton Blanchard <anton@samba.org>
Tested-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.3.2

