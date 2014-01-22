Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaAVNlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:41:09 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61908 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbaAVNlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:41:04 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 1/6] staging/lustre/o2iblnd: fix is_vmalloc_addr build warning
Date: Wed, 22 Jan 2014 21:40:35 +0800
Message-Id: <1390398040-31088-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this building Lustre:
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c: In function ‘kiblnd_kvaddr_to_page’:
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c:532:2: warning: passing argument 1 of ‘is_vmalloc_addr’ makes pointer from integer without a cast [enabled by default]

Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 9364863..6f58ead 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -529,7 +529,7 @@ kiblnd_kvaddr_to_page (unsigned long vaddr)
 {
 	struct page *page;
 
-	if (is_vmalloc_addr(vaddr)) {
+	if (is_vmalloc_addr((void *)vaddr)) {
 		page = vmalloc_to_page ((void *)vaddr);
 		LASSERT (page != NULL);
 		return page;
-- 
1.7.9.5

