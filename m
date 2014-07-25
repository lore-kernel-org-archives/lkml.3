Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaGYXgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 19:36:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47156 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaGYXgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 19:36:46 -0400
Date: Fri, 25 Jul 2014 16:36:30 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-ac379835e820de27429b5c4eadf4c1b40320cff4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, Nathan_Lynch@mentor.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Nathan_Lynch@mentor.com, hpa@linux.intel.com
In-Reply-To: <e4c8bf4bc2725bda22c4a4b7d0c82adcd8f8d9b8.1406330779.git.luto@amacapital.net>
References: <e4c8bf4bc2725bda22c4a4b7d0c82adcd8f8d9b8.1406330779.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86/vdso: Set VM_MAYREAD for the vvar vma
Git-Commit-ID: ac379835e820de27429b5c4eadf4c1b40320cff4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac379835e820de27429b5c4eadf4c1b40320cff4
Gitweb:     http://git.kernel.org/tip/ac379835e820de27429b5c4eadf4c1b40320cff4
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Fri, 25 Jul 2014 16:27:01 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 25 Jul 2014 16:32:53 -0700

x86/vdso: Set VM_MAYREAD for the vvar vma

The VVAR area can, obviously, be read; that is kind of the point.

AFAIK this has no effect whatsoever unless x86 suddenly turns into a
nommu architecture.  Nonetheless, not setting it is suspicious.

Reported-by: Nathan Lynch <Nathan_Lynch@mentor.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/e4c8bf4bc2725bda22c4a4b7d0c82adcd8f8d9b8.1406330779.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
