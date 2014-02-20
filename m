Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaBTEwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 23:52:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34380 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbaBTEwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 23:52:02 -0500
Date: Wed, 19 Feb 2014 20:51:41 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-3af7111e2066a641510c16a4e9e82dd81550115b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, fengguang.wu@intel.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, fengguang.wu@intel.com
In-Reply-To: <1392587568-7325-3-git-send-email-stefani@seibold.net>
References: <1392587568-7325-3-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] mm: Clean up style in install_special_mapping()
Git-Commit-ID: 3af7111e2066a641510c16a4e9e82dd81550115b
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

Commit-ID:  3af7111e2066a641510c16a4e9e82dd81550115b
Gitweb:     http://git.kernel.org/tip/3af7111e2066a641510c16a4e9e82dd81550115b
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 19 Feb 2014 20:46:57 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 19 Feb 2014 20:46:57 -0800

mm: Clean up style in install_special_mapping()

We can clean up the style in install_special_mapping(), and make it
use PTR_ERR_OR_ZERO().

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Link: http://lkml.kernel.org/r/1392587568-7325-3-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 mm/mmap.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 81ba54f..6b78a77 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2959,12 +2959,10 @@ int install_special_mapping(struct mm_struct *mm,
 			    unsigned long addr, unsigned long len,
 			    unsigned long vm_flags, struct page **pages)
 {
-	struct vm_area_struct *vma = _install_special_mapping(mm,
-			    addr, len, vm_flags, pages);
+	struct vm_area_struct *vma;
 
-	if (IS_ERR(vma))
-		return PTR_ERR(vma);
-	return 0;
+	vma = _install_special_mapping(mm, addr, len, vm_flags, pages);
+	return PTR_ERR_OR_ZERO(vma);
 }
 
 static DEFINE_MUTEX(mm_all_locks_mutex);
