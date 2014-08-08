Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbaHHRUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:20:32 -0400
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:61333 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaHHRUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:20:31 -0400
X-Greylist: delayed 3201 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Aug 2014 13:20:30 EDT
From: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
Subject: [PATCH] drivers: staging: lustre: fix sparse warnings / delete unused function
Date: Fri,  8 Aug 2014 18:26:22 +0200
Message-Id: <1407515182-24287-1-git-send-email-benedict.boerger@cs.tu-dortmund.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers: staging: lustre: fix sparse warning: symbol XYZ was
not declared. Should it be static?

This was done by declaring them static. This could be done because the functions
were used only in this file.

Deleted the function lnet_print_text_bufs because it were unused.

Compiled without an error.
Done to complete a eudyptula task.

Signed-off-by: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
---
 drivers/staging/lustre/lnet/lnet/config.c | 57 ++++++++++++-------------------
 1 file changed, 21 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/config.c b/drivers/staging/lustre/lnet/lnet/config.c
index 7c8b947..ede664b 100644
--- a/drivers/staging/lustre/lnet/lnet/config.c
+++ b/drivers/staging/lustre/lnet/lnet/config.c
@@ -47,7 +47,7 @@ static int lnet_tbnob;			/* track text buf allocation */
 #define LNET_MAX_TEXTBUF_NOB     (64<<10)	/* bound allocation */
 #define LNET_SINGLE_TEXTBUF_NOB  (4<<10)
 
-void
+static void
 lnet_syntax(char *name, char *str, int offset, int width)
 {
 	static char dots[LNET_SINGLE_TEXTBUF_NOB];
@@ -64,7 +64,7 @@ lnet_syntax(char *name, char *str, int offset, int width)
 			    (width < 1) ? 0 : width - 1, dashes);
 }
 
-int
+static int
 lnet_issep(char c)
 {
 	switch (c) {
@@ -77,7 +77,7 @@ lnet_issep(char c)
 	}
 }
 
-int
+static int
 lnet_net_unique(__u32 net, struct list_head *nilist)
 {
 	struct list_head       *tmp;
@@ -108,7 +108,7 @@ lnet_ni_free(struct lnet_ni *ni)
 	LIBCFS_FREE(ni, sizeof(*ni));
 }
 
-lnet_ni_t *
+static lnet_ni_t *
 lnet_ni_alloc(__u32 net, struct cfs_expr_list *el, struct list_head *nilist)
 {
 	struct lnet_tx_queue	*tq;
@@ -365,7 +365,7 @@ lnet_parse_networks(struct list_head *nilist, char *networks)
 	return -EINVAL;
 }
 
-lnet_text_buf_t *
+static lnet_text_buf_t *
 lnet_new_text_buf(int str_len)
 {
 	lnet_text_buf_t *ltb;
@@ -394,14 +394,14 @@ lnet_new_text_buf(int str_len)
 	return ltb;
 }
 
-void
+static void
 lnet_free_text_buf(lnet_text_buf_t *ltb)
 {
 	lnet_tbnob -= ltb->ltb_size;
 	LIBCFS_FREE(ltb, ltb->ltb_size);
 }
 
-void
+static void
 lnet_free_text_bufs(struct list_head *tbs)
 {
 	lnet_text_buf_t  *ltb;
@@ -414,22 +414,7 @@ lnet_free_text_bufs(struct list_head *tbs)
 	}
 }
 
-void
-lnet_print_text_bufs(struct list_head *tbs)
-{
-	struct list_head	*tmp;
-	lnet_text_buf_t   *ltb;
-
-	list_for_each(tmp, tbs) {
-		ltb = list_entry(tmp, lnet_text_buf_t, ltb_list);
-
-		CDEBUG(D_WARNING, "%s\n", ltb->ltb_text);
-	}
-
-	CDEBUG(D_WARNING, "%d allocated\n", lnet_tbnob);
-}
-
-int
+static int
 lnet_str2tbs_sep(struct list_head *tbs, char *str)
 {
 	struct list_head	pending;
@@ -487,7 +472,7 @@ lnet_str2tbs_sep(struct list_head *tbs, char *str)
 	return 0;
 }
 
-int
+static int
 lnet_expand1tb(struct list_head *list,
 	       char *str, char *sep1, char *sep2,
 	       char *item, int itemlen)
@@ -512,7 +497,7 @@ lnet_expand1tb(struct list_head *list,
 	return 0;
 }
 
-int
+static int
 lnet_str2tbs_expand(struct list_head *tbs, char *str)
 {
 	char	      num[16];
@@ -592,7 +577,7 @@ lnet_str2tbs_expand(struct list_head *tbs, char *str)
 	return -1;
 }
 
-int
+static int
 lnet_parse_hops(char *str, unsigned int *hops)
 {
 	int     len = strlen(str);
@@ -605,7 +590,7 @@ lnet_parse_hops(char *str, unsigned int *hops)
 
 #define LNET_PRIORITY_SEPARATOR (':')
 
-int
+static int
 lnet_parse_priority(char *str, unsigned int *priority, char **token)
 {
 	int   nob;
@@ -635,7 +620,7 @@ lnet_parse_priority(char *str, unsigned int *priority, char **token)
 	return 0;
 }
 
-int
+static int
 lnet_parse_route(char *str, int *im_a_router)
 {
 	/* static scratch buffer OK (single threaded) */
@@ -778,7 +763,7 @@ lnet_parse_route(char *str, int *im_a_router)
 	return myrc;
 }
 
-int
+static int
 lnet_parse_route_tbs(struct list_head *tbs, int *im_a_router)
 {
 	lnet_text_buf_t   *ltb;
@@ -819,7 +804,7 @@ lnet_parse_routes(char *routes, int *im_a_router)
 	return rc;
 }
 
-int
+static int
 lnet_match_network_token(char *token, int len, __u32 *ipaddrs, int nip)
 {
 	LIST_HEAD(list);
@@ -838,7 +823,7 @@ lnet_match_network_token(char *token, int len, __u32 *ipaddrs, int nip)
 	return rc;
 }
 
-int
+static int
 lnet_match_network_tokens(char *net_entry, __u32 *ipaddrs, int nip)
 {
 	static char tokens[LNET_SINGLE_TEXTBUF_NOB];
@@ -895,7 +880,7 @@ lnet_match_network_tokens(char *net_entry, __u32 *ipaddrs, int nip)
 	return 1;
 }
 
-__u32
+static __u32
 lnet_netspec2net(char *netspec)
 {
 	char   *bracket = strchr(netspec, '(');
@@ -912,7 +897,7 @@ lnet_netspec2net(char *netspec)
 	return net;
 }
 
-int
+static int
 lnet_splitnets(char *source, struct list_head *nets)
 {
 	int	       offset = 0;
@@ -992,7 +977,7 @@ lnet_splitnets(char *source, struct list_head *nets)
 	}
 }
 
-int
+static int
 lnet_match_networks(char **networksp, char *ip2nets, __u32 *ipaddrs, int nip)
 {
 	static char	networks[LNET_SINGLE_TEXTBUF_NOB];
@@ -1112,13 +1097,13 @@ lnet_match_networks(char **networksp, char *ip2nets, __u32 *ipaddrs, int nip)
 	return count;
 }
 
-void
+static void
 lnet_ipaddr_free_enumeration(__u32 *ipaddrs, int nip)
 {
 	LIBCFS_FREE(ipaddrs, nip * sizeof(*ipaddrs));
 }
 
-int
+static int
 lnet_ipaddr_enumerate(__u32 **ipaddrsp)
 {
 	int	up;
-- 
1.9.1

