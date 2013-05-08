Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3EHP0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:26:30 -0400
Received: from 87-119-183-129.tll.elisa.ee ([87.119.183.129]:48197 "EHLO
	fatphil.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab3EHP03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:26:29 -0400
From: Phil Carmody <pc+lkml@asdf.org>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Phil Carmody <pc+lkml@asdf.org>
Subject: [PATCH] Makefile: make sparse (CHECK) user-selectable
Date: Wed,  8 May 2013 18:23:00 +0300
Message-Id: <1368026580-26897-1-git-send-email-pc+lkml@asdf.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a tweaked version as well as the system default,
so make the sparse binary that's run user-selectable.

Signed-off-by: Phil Carmody <pc+lkml@asdf.org>
---
 Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index a3a834b..e7a4851 100644
--- a/Makefile
+++ b/Makefile
@@ -338,7 +338,9 @@ GENKSYMS	= scripts/genksyms/genksyms
 INSTALLKERNEL  := installkernel
 DEPMOD		= /sbin/depmod
 PERL		= perl
-CHECK		= sparse
+ifndef CHECK
+  CHECK		= sparse
+endif
 
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
 		  -Wbitwise -Wno-return-void $(CF)
-- 
1.7.2.5

