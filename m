Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaHFS7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:59:54 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:54046 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbaHFS7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:59:53 -0400
Date: Wed, 6 Aug 2014 19:59:42 +0100
From: "Tobenna P. Igwe" <ptigwe@gmail.com>
To: Ken Cox <jkc@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>, ptigwe@gmail.com
Subject: [PATCH] staging: unisys: uislib: Fixed missing blank line coding
 style issue
Message-ID: <20140806185934.GA7446@Tobenna-Peter-Igwes-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue "Missing a blank line after declarations"
detected by the 'checkpatch.pl' script.

Signed-off-by: Tobenna P. Igwe <ptigwe@gmail.com>
---
 drivers/staging/unisys/uislib/uisutils.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/unisys/uislib/uisutils.c b/drivers/staging/unisys/uislib/uisutils.c
index ee26e00..ab593e4 100644
--- a/drivers/staging/unisys/uislib/uisutils.c
+++ b/drivers/staging/unisys/uislib/uisutils.c
@@ -117,6 +117,7 @@ uisctrl_register_req_handler_ex(uuid_le switchTypeGuid,
 {
 	ReqHandlerInfo_t *pReqHandlerInfo;
 	int rc = 0;		/* assume failure */
+
 	LOGINF("type=%pUL, controlfunc=0x%p.\n",
 	       &switchTypeGuid, controlfunc);
 	if (!controlfunc) {
@@ -161,6 +162,7 @@ int
 uisctrl_unregister_req_handler_ex(uuid_le switchTypeGuid)
 {
 	int rc = 0;		/* assume failure */
+
 	LOGINF("type=%pUL.\n", &switchTypeGuid);
 	if (ReqHandlerDel(switchTypeGuid) < 0) {
 		LOGERR("failed to remove %pUL from server list\n",
@@ -249,6 +251,7 @@ uisutil_copy_fragsinfo_from_skb(unsigned char *calling_ctx, void *skb_in,
 	if (skb_shinfo(skb)->frag_list) {
 		struct sk_buff *skbinlist;
 		int c;
+
 		for (skbinlist = skb_shinfo(skb)->frag_list; skbinlist;
 		     skbinlist = skbinlist->next) {
 
@@ -306,6 +309,7 @@ ReqHandlerFind(uuid_le switchTypeGuid)
 {
 	struct list_head *lelt, *tmp;
 	ReqHandlerInfo_t *entry = NULL;
+
 	spin_lock(&ReqHandlerInfo_list_lock);
 	list_for_each_safe(lelt, tmp, &ReqHandlerInfo_list) {
 		entry = list_entry(lelt, ReqHandlerInfo_t, list_link);
@@ -324,6 +328,7 @@ ReqHandlerDel(uuid_le switchTypeGuid)
 	struct list_head *lelt, *tmp;
 	ReqHandlerInfo_t *entry = NULL;
 	int rc = -1;
+
 	spin_lock(&ReqHandlerInfo_list_lock);
 	list_for_each_safe(lelt, tmp, &ReqHandlerInfo_list) {
 		entry = list_entry(lelt, ReqHandlerInfo_t, list_link);
-- 
1.7.10.4

