Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297AbaKSVDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:03:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197AbaKSVBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:01:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.17 126/141] netfilter: nft_compat: fix wrong target lookup in nft_target_select_ops()
Date: Wed, 19 Nov 2014 12:52:29 -0800
Message-Id: <20141119205154.949239913@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arturo Borrero <arturo.borrero.glez@gmail.com>

commit 7965ee93719921ea5978f331da653dfa2d7b99f5 upstream.

The code looks for an already loaded target, and the correct list to search
is nft_target_list, not nft_match_list.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -696,7 +696,7 @@ nft_target_select_ops(const struct nft_c
 	family = ctx->afi->family;
 
 	/* Re-use the existing target if it's already loaded. */
-	list_for_each_entry(nft_target, &nft_match_list, head) {
+	list_for_each_entry(nft_target, &nft_target_list, head) {
 		struct xt_target *target = nft_target->ops.data;
 
 		if (strcmp(target->name, tg_name) == 0 &&


