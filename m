Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaABVxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:53:49 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33131 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaABVxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:53:41 -0500
From: Laura Abbott <lauraa@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: linux-kernel@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCHv3 05/11] staging: lustre: Use is_vmalloc_addr
Date: Thu,  2 Jan 2014 13:53:23 -0800
Message-Id: <1388699609-18214-6-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of manually checking the bounds of VMALLOC_START and
VMALLOC_END, just use is_vmalloc_addr. That's what the function
was designed for.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 26b49a2..9364863 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -529,8 +529,7 @@ kiblnd_kvaddr_to_page (unsigned long vaddr)
 {
 	struct page *page;
 
-	if (vaddr >= VMALLOC_START &&
-	    vaddr < VMALLOC_END) {
+	if (is_vmalloc_addr(vaddr)) {
 		page = vmalloc_to_page ((void *)vaddr);
 		LASSERT (page != NULL);
 		return page;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

