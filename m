Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaCYX0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 19:26:01 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:64407 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbaCYXZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 19:25:59 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86: Don't rebuild 32-bit vdsos on every make
Date: Tue, 25 Mar 2014 16:25:53 -0700
Message-Id: <d741449340642213744dd659471a35bb970a0c4c.1395789923.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vdso32/vclock_gettime.o was confusing kbuild.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index a2de5fc..6e6361a 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -136,7 +136,7 @@ override obj-dirs = $(dir $(obj)) $(obj)/vdso32/
 
 targets += vdso32/vdso32.lds
 targets += $(vdso32-images) $(vdso32-images:=.dbg)
-targets += vdso32/note.o $(vdso32.so-y:%=vdso32/%.o)
+targets += vdso32/note.o vdso32/vclock_gettime.o $(vdso32.so-y:%=vdso32/%.o)
 
 extra-y	+= $(vdso32-images)
 
-- 
1.8.5.3

