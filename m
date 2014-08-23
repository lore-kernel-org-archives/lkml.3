Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaHWWUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 18:20:19 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45236 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaHWWUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 18:20:18 -0400
From: Peter Feiner <pfeiner@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Peter Feiner <pfeiner@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 2/3] mm: mprotect: preserve special page protection bits
Date: Sat, 23 Aug 2014 18:12:00 -0400
Message-Id: <1408831921-10168-3-git-send-email-pfeiner@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1408831921-10168-1-git-send-email-pfeiner@google.com>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <1408831921-10168-1-git-send-email-pfeiner@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't want to zap special page protection bits on mprotect.
Analogous to the bug fixed in c9d0bf241451a3ab7d02e1652c22b80cd7d93e8f
where vm_page_prot bits set by drivers were zapped when write
notifications were enabled on new VMAs.

Signed-off-by: Peter Feiner <pfeiner@google.com>
---
 mm/mprotect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index c43d557..1c1afd4 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -324,7 +324,7 @@ success:
 					  vm_get_page_prot(newflags));
 
 	if (vma_wants_writenotify(vma)) {
-		vma->vm_page_prot = vm_get_page_prot(newflags & ~VM_SHARED);
+		vma_enable_writenotify(vma);
 		dirty_accountable = 1;
 	}
 
-- 
2.1.0.rc2.206.gedb03e5

