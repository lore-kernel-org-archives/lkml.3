Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab3JTFFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 01:05:36 -0400
Received: from smtprelay0036.hostedemail.com ([216.40.44.36]:55091 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750835Ab3JTFFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 01:05:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:2:41:69:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:1981:2194:2198:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:4050:4118:4605:5007:7652:7875:7903:10004:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12683:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: owner68_4d8b8435f7437
X-Filterd-Recvd-Size: 7830
Message-ID: <1382245531.2041.37.camel@joe-AO722>
Subject: nf_tables*.h: Remove extern from function prototypes
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Date: Sat, 19 Oct 2013 22:05:31 -0700
In-Reply-To: <cover.1382129045.git.joe@perches.com>
References: <cover.1382129045.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a mix of function prototypes with and without extern
in the kernel sources.  Standardize on not using extern for
function prototypes.

Function prototypes don't need to be written with extern.
extern is assumed by the compiler.  Its use is as unnecessary as
using auto to declare automatic/local variables in a block.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/net/netfilter/nf_tables.h      | 55 ++++++++++++++++------------------
 include/net/netfilter/nf_tables_core.h | 28 ++++++++---------
 2 files changed, 40 insertions(+), 43 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 54c4a5c..5a91abf 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -91,13 +91,11 @@ struct nft_data_desc {
 	unsigned int			len;
 };
 
-extern int nft_data_init(const struct nft_ctx *ctx, struct nft_data *data,
-			 struct nft_data_desc *desc, const struct nlattr *nla);
-extern void nft_data_uninit(const struct nft_data *data,
-			    enum nft_data_types type);
-extern int nft_data_dump(struct sk_buff *skb, int attr,
-			 const struct nft_data *data,
-			 enum nft_data_types type, unsigned int len);
+int nft_data_init(const struct nft_ctx *ctx, struct nft_data *data,
+		  struct nft_data_desc *desc, const struct nlattr *nla);
+void nft_data_uninit(const struct nft_data *data, enum nft_data_types type);
+int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
+		  enum nft_data_types type, unsigned int len);
 
 static inline enum nft_data_types nft_dreg_to_type(enum nft_registers reg)
 {
@@ -109,12 +107,11 @@ static inline enum nft_registers nft_type_to_reg(enum nft_data_types type)
 	return type == NFT_DATA_VERDICT ? NFT_REG_VERDICT : NFT_REG_1;
 }
 
-extern int nft_validate_input_register(enum nft_registers reg);
-extern int nft_validate_output_register(enum nft_registers reg);
-extern int nft_validate_data_load(const struct nft_ctx *ctx,
-				  enum nft_registers reg,
-				  const struct nft_data *data,
-				  enum nft_data_types type);
+int nft_validate_input_register(enum nft_registers reg);
+int nft_validate_output_register(enum nft_registers reg);
+int nft_validate_data_load(const struct nft_ctx *ctx, enum nft_registers reg,
+			   const struct nft_data *data,
+			   enum nft_data_types type);
 
 /**
  *	struct nft_set_elem - generic representation of set elements
@@ -183,8 +180,8 @@ struct nft_set_ops {
 	u32				features;
 };
 
-extern int nft_register_set(struct nft_set_ops *ops);
-extern void nft_unregister_set(struct nft_set_ops *ops);
+int nft_register_set(struct nft_set_ops *ops);
+void nft_unregister_set(struct nft_set_ops *ops);
 
 /**
  * 	struct nft_set - nf_tables set instance
@@ -220,8 +217,8 @@ static inline void *nft_set_priv(const struct nft_set *set)
 	return (void *)set->data;
 }
 
-extern struct nft_set *nf_tables_set_lookup(const struct nft_table *table,
-					    const struct nlattr *nla);
+struct nft_set *nf_tables_set_lookup(const struct nft_table *table,
+				     const struct nlattr *nla);
 
 /**
  *	struct nft_set_binding - nf_tables set binding
@@ -237,10 +234,10 @@ struct nft_set_binding {
 	const struct nft_chain		*chain;
 };
 
-extern int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
-			      struct nft_set_binding *binding);
-extern void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
-				 struct nft_set_binding *binding);
+int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
+		       struct nft_set_binding *binding);
+void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
+			  struct nft_set_binding *binding);
 
 
 /**
@@ -446,8 +443,8 @@ static inline struct nft_base_chain *nft_base_chain(const struct nft_chain *chai
 	return container_of(chain, struct nft_base_chain, chain);
 }
 
-extern unsigned int nft_do_chain_pktinfo(struct nft_pktinfo *pkt,
-					 const struct nf_hook_ops *ops);
+unsigned int nft_do_chain_pktinfo(struct nft_pktinfo *pkt,
+				  const struct nf_hook_ops *ops);
 
 /**
  *	struct nft_table - nf_tables table
@@ -489,8 +486,8 @@ struct nft_af_info {
 	nf_hookfn			*hooks[NF_MAX_HOOKS];
 };
 
-extern int nft_register_afinfo(struct net *, struct nft_af_info *);
-extern void nft_unregister_afinfo(struct nft_af_info *);
+int nft_register_afinfo(struct net *, struct nft_af_info *);
+void nft_unregister_afinfo(struct nft_af_info *);
 
 struct nf_chain_type {
 	unsigned int		hook_mask;
@@ -501,11 +498,11 @@ struct nf_chain_type {
 	int			family;
 };
 
-extern int nft_register_chain_type(struct nf_chain_type *);
-extern void nft_unregister_chain_type(struct nf_chain_type *);
+int nft_register_chain_type(struct nf_chain_type *);
+void nft_unregister_chain_type(struct nf_chain_type *);
 
-extern int nft_register_expr(struct nft_expr_type *);
-extern void nft_unregister_expr(struct nft_expr_type *);
+int nft_register_expr(struct nft_expr_type *);
+void nft_unregister_expr(struct nft_expr_type *);
 
 #define MODULE_ALIAS_NFT_FAMILY(family)	\
 	MODULE_ALIAS("nft-afinfo-" __stringify(family))
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index fe7b162..cf2b7ae 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -1,11 +1,11 @@
 #ifndef _NET_NF_TABLES_CORE_H
 #define _NET_NF_TABLES_CORE_H
 
-extern int nf_tables_core_module_init(void);
-extern void nf_tables_core_module_exit(void);
+int nf_tables_core_module_init(void);
+void nf_tables_core_module_exit(void);
 
-extern int nft_immediate_module_init(void);
-extern void nft_immediate_module_exit(void);
+int nft_immediate_module_init(void);
+void nft_immediate_module_exit(void);
 
 struct nft_cmp_fast_expr {
 	u32			data;
@@ -15,17 +15,17 @@ struct nft_cmp_fast_expr {
 
 extern const struct nft_expr_ops nft_cmp_fast_ops;
 
-extern int nft_cmp_module_init(void);
-extern void nft_cmp_module_exit(void);
+int nft_cmp_module_init(void);
+void nft_cmp_module_exit(void);
 
-extern int nft_lookup_module_init(void);
-extern void nft_lookup_module_exit(void);
+int nft_lookup_module_init(void);
+void nft_lookup_module_exit(void);
 
-extern int nft_bitwise_module_init(void);
-extern void nft_bitwise_module_exit(void);
+int nft_bitwise_module_init(void);
+void nft_bitwise_module_exit(void);
 
-extern int nft_byteorder_module_init(void);
-extern void nft_byteorder_module_exit(void);
+int nft_byteorder_module_init(void);
+void nft_byteorder_module_exit(void);
 
 struct nft_payload {
 	enum nft_payload_bases	base:8;
@@ -36,7 +36,7 @@ struct nft_payload {
 
 extern const struct nft_expr_ops nft_payload_fast_ops;
 
-extern int nft_payload_module_init(void);
-extern void nft_payload_module_exit(void);
+int nft_payload_module_init(void);
+void nft_payload_module_exit(void);
 
 #endif /* _NET_NF_TABLES_CORE_H */


