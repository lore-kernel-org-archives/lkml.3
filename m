Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbaGNPKC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:10:02 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48433 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbaGNPJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:23 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 09/38] uapi: check for optional files which are generated
Date: Mon, 14 Jul 2014 17:08:37 +0200
Message-Id: <1405350546-28467-9-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In include/uapi/asm-generic/Kbuild.asm we have a few optional files
listed. The files may be provided by the architecture
or the wrapped from asm-generic may be used.
The current logic failed to check for generated wrappers.

Replace the obsolete check for the file outside uapi with a check
for a generated file.

This changes makes a few "header-y += kvm_para.h" asssignments redundant.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 include/uapi/asm-generic/Kbuild.asm | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/asm-generic/Kbuild.asm b/include/uapi/asm-generic/Kbuild.asm
index fcd50b7..81b3f40 100644
--- a/include/uapi/asm-generic/Kbuild.asm
+++ b/include/uapi/asm-generic/Kbuild.asm
@@ -43,7 +43,7 @@ header-y += $(foreach hdr,$(opt-header), \
 	      $(if \
 		$(wildcard \
 			$(srctree)/arch/$(SRCARCH)/include/uapi/asm/$(hdr) \
-			$(srctree)/arch/$(SRCARCH)/include/asm/$(hdr) \
+			$(objtree)/arch/$(SRCARCH)/include/generated/uapi/asm/$(hdr) \
 		), \
 		$(hdr) \
 		))
-- 
1.9.3

