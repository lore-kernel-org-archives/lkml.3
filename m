Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab3KIGvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:51:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab3KIGu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.10 52/74] au1200fb: io_remap_pfn_range() sets VM_IO
Date: Fri,  8 Nov 2013 22:51:57 -0800
Message-Id: <20131109065117.151874377@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 1fca06fafb235a88c4fa91294aa1726c0e22855b upstream.

... and single return is quite sufficient to get out of function, TYVM

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/au1200fb.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/video/au1200fb.c
+++ b/drivers/video/au1200fb.c
@@ -1258,13 +1258,9 @@ static int au1200fb_fb_mmap(struct fb_in
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	pgprot_val(vma->vm_page_prot) |= _CACHE_MASK; /* CCA=7 */
 
-	vma->vm_flags |= VM_IO;
-
 	return io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
 				  vma->vm_end - vma->vm_start,
 				  vma->vm_page_prot);
-
-	return 0;
 }
 
 static void set_global(u_int cmd, struct au1200_lcd_global_regs_t *pdata)


