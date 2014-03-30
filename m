Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaC3XlH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:41:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36438 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753073AbaC3XZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Laurent Dufour" <ldufour@linux.vnet.ibm.com>,
        "Anton Blanchard" <anton@samba.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.471519475@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 165/200] powerpc: Align p_dyn, p_rela and p_st symbols
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit a5b2cf5b1af424ee3dd9e3ce6d5cea18cb927e67 upstream.

The 64bit relocation code places a few symbols in the text segment.
These symbols are only 4 byte aligned where they need to be 8 byte
aligned. Add an explicit alignment.

Signed-off-by: Anton Blanchard <anton@samba.org>
Tested-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/reloc_64.S | 1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/reloc_64.S
+++ b/arch/powerpc/kernel/reloc_64.S
@@ -81,6 +81,7 @@ _GLOBAL(relocate)
 
 6:	blr
 
+.balign 8
 p_dyn:	.llong	__dynamic_start - 0b
 p_rela:	.llong	__rela_dyn_start - 0b
 p_st:	.llong	_stext - 0b

