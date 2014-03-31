Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaCaNqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:46:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35614 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbaCaNXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 21/71] powerpc: Align p_dyn, p_rela and p_st symbols
Date: Mon, 31 Mar 2014 14:22:27 +0100
Message-Id: <1396272197-13394-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

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

