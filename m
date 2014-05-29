Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbaE2FlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:41:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbaE2Ees (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Giuseppe Longo <giuseppelng@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.14 012/140] netfilter: nf_tables: set names cannot be larger than 15 bytes
Date: Wed, 28 May 2014 21:32:31 -0700
Message-Id: <20140529043051.040236974@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit a9bdd8365684810e3de804f8c51e52c26a5eccbb upstream.

Currently, nf_tables trims off the set name if it exceeeds 15
bytes, so explicitly reject set names that are too large.

Reported-by: Giuseppe Longo <giuseppelng@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_tables_api.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1934,7 +1934,8 @@ static const struct nft_set_ops *nft_sel
 
 static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_TABLE]		= { .type = NLA_STRING },
-	[NFTA_SET_NAME]			= { .type = NLA_STRING },
+	[NFTA_SET_NAME]			= { .type = NLA_STRING,
+					    .len = IFNAMSIZ - 1 },
 	[NFTA_SET_FLAGS]		= { .type = NLA_U32 },
 	[NFTA_SET_KEY_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_KEY_LEN]		= { .type = NLA_U32 },


