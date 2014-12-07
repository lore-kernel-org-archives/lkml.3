Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaLGT06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 14:26:58 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:3211 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753465AbaLGT0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 14:26:49 -0500
X-IronPort-AV: E=Sophos;i="5.07,534,1413237600"; 
   d="scan'208";a="111932937"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Martyn Welch <martyn.welch@ge.com>
Cc: kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk, joe@perches.com,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/20] vme: fix misspelling of current function in string
Date: Sun,  7 Dec 2014 20:20:53 +0100
Message-Id: <1417980062-25151-12-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a misspelled function name by %s and then __func__.

This is the get function, not the set function, as was indicated by the
string.

This was done using Coccinelle, including the use of Levenshtein distance,
as proposed by Rasmus Villemoes.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch is difficult to summarize, but is available in the cover
letter of this patch series.

 drivers/vme/vme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vme/vme.c b/drivers/vme/vme.c
index 7516030..d95fb84 100644
--- a/drivers/vme/vme.c
+++ b/drivers/vme/vme.c
@@ -502,7 +502,7 @@ int vme_master_get(struct vme_resource *resource, int *enabled,
 	image = list_entry(resource->entry, struct vme_master_resource, list);
 
 	if (bridge->master_get == NULL) {
-		printk(KERN_WARNING "vme_master_set not supported\n");
+		printk(KERN_WARNING "%s not supported\n", __func__);
 		return -EINVAL;
 	}
 

