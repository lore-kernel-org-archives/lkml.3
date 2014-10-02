Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaJBNte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:49:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbaJBNtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:49:31 -0400
From: Michal Marek <mmarek@suse.cz>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, yamada.m@jp.panasonic.com
Subject: [PATCH] powerpc/boot: Makefile cleanup
Date: Thu,  2 Oct 2014 15:49:15 +0200
Message-Id: <1412257755-4564-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The $(image-n) variable will never exist, because unset Kconfig options
are '' and not 'n'.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 arch/powerpc/boot/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index ccc25ed..c456d07 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -317,7 +317,7 @@ endif
 # Allow extra targets to be added to the defconfig
 image-y	+= $(subst ",,$(CONFIG_EXTRA_TARGETS))
 
-initrd-  := $(patsubst zImage%, zImage.initrd%, $(image-n) $(image-))
+initrd-  := $(patsubst zImage%, zImage.initrd%, $(image-))
 initrd-y := $(patsubst zImage%, zImage.initrd%, \
 		$(patsubst dtbImage%, dtbImage.initrd%, \
 		$(patsubst simpleImage%, simpleImage.initrd%, \
-- 
1.8.4.5

