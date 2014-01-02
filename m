Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaABVxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:53:53 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33090 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaABVxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:53:39 -0500
From: Laura Abbott <lauraa@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>,
        linux-acpi@vger.kernel.org
Subject: [RFC PATCHv3 01/11] mce: acpi/apei: Use get_vm_area directly
Date: Thu,  2 Jan 2014 13:53:19 -0800
Message-Id: <1388699609-18214-2-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to use VMALLOC_START and VMALLOC_END with
__get_vm_area when get_vm_area does the exact same thing.
Convert over.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 drivers/acpi/apei/ghes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a30bc31..6e784b7 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -149,8 +149,8 @@ static atomic_t ghes_estatus_cache_alloced;
 
 static int ghes_ioremap_init(void)
 {
-	ghes_ioremap_area = __get_vm_area(PAGE_SIZE * GHES_IOREMAP_PAGES,
-		VM_IOREMAP, VMALLOC_START, VMALLOC_END);
+	ghes_ioremap_area = get_vm_area(PAGE_SIZE * GHES_IOREMAP_PAGES,
+		VM_IOREMAP);
 	if (!ghes_ioremap_area) {
 		pr_err(GHES_PFX "Failed to allocate virtual memory area for atomic ioremap.\n");
 		return -ENOMEM;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

