Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaLQLFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 06:05:42 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47456 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaLQLFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 06:05:40 -0500
From: Andreas Ruprecht <rupran@einserver.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Andreas Ruprecht <rupran@einserver.de>
Subject: [PATCH] powerpc: lib: Do not include string.o in obj-y twice
Date: Wed, 17 Dec 2014 12:05:13 +0100
Message-Id: <1418814313-21461-1-git-send-email-rupran@einserver.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the Makefile, string.o (which is generated from string.S) is
included into the list of objects being built unconditionally
(obj-y) in line 12.

Additionally, if CONFIG_PPC64 is set, it is included again in
line 17.

This patch removes the latter unnecessary inclusion.

Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
---
 arch/powerpc/lib/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 597562f69b2d..1b01159b81f3 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -14,8 +14,7 @@ obj-y			:= string.o alloc.o \
 obj-$(CONFIG_PPC32)	+= div64.o copy_32.o
 
 obj-$(CONFIG_PPC64)	+= copypage_64.o copyuser_64.o \
-			   usercopy_64.o mem_64.o string.o \
-			   hweight_64.o \
+			   usercopy_64.o mem_64.o hweight_64.o \
 			   copyuser_power7.o string_64.o copypage_power7.o
 ifeq ($(CONFIG_GENERIC_CSUM),)
 obj-y			+= checksum_$(CONFIG_WORD_SIZE).o
-- 
1.9.1

