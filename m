Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab3ANRXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:23:40 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:50904 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab3ANRXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:23:38 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] mips: kernel/vpe.c: fix wrong KERN_WARNING message
Date: Mon, 14 Jan 2013 17:23:29 +0000
Message-Id: <1358184212-30381-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in the printk, the variable t euqals to NULL, so there is no t->index, we use
v->tc->index instead.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/mips/kernel/vpe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index eec690a..3e20c33 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -705,7 +705,7 @@ static int vpe_run(struct vpe * v)
 
 			printk(KERN_WARNING
 			       "VPE loader: TC %d is already in use.\n",
-                               t->index);
+                               v->tc->index);
 			return -ENOEXEC;
 		}
 	} else {
-- 
1.7.9.5

