Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaGYX1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 19:27:17 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:62578 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaGYX1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 19:27:16 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86,vdso: Set VM_MAYREAD for the vvar vma
Date: Fri, 25 Jul 2014 16:27:01 -0700
Message-Id: <e4c8bf4bc2725bda22c4a4b7d0c82adcd8f8d9b8.1406330779.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AFAIK this has no effect whatsoever unless x86 suddenly turns into a
nommu architecture.  Nonetheless, not setting it is suspicious.

Reported-by: Nathan Lynch <Nathan_Lynch@mentor.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index dbef622..970463b 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -138,7 +138,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 	vma = _install_special_mapping(mm,
 				       addr,
 				       -image->sym_vvar_start,
-				       VM_READ,
+				       VM_READ|VM_MAYREAD,
 				       &vvar_mapping);
 
 	if (IS_ERR(vma)) {
-- 
1.9.3

