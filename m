Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaKYKlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:41:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58305 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaKYKlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 067/254] netfilter: nft_compat: fix wrong target lookup in nft_target_select_ops()
Date: Tue, 25 Nov 2014 10:36:57 +0000
Message-Id: <1416912004-5928-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arturo Borrero <arturo.borrero.glez@gmail.com>

commit 7965ee93719921ea5978f331da653dfa2d7b99f5 upstream.

The code looks for an already loaded target, and the correct list to search
is nft_target_list, not nft_match_list.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/nft_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 1840989092ed..5b5ab9ec1a90 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -696,7 +696,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	family = ctx->afi->family;
 
 	/* Re-use the existing target if it's already loaded. */
-	list_for_each_entry(nft_target, &nft_match_list, head) {
+	list_for_each_entry(nft_target, &nft_target_list, head) {
 		struct xt_target *target = nft_target->ops.data;
 
 		if (strcmp(target->name, tg_name) == 0 &&
-- 
2.1.0

