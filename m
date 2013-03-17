Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3CRPMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:12:36 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40923 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3CRPMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:12:35 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] net: bluetooth: Replaced kzalloc and memcpy with kmemdup
Date: Sun, 17 Mar 2013 07:16:50 +0200
Message-Id: <1363497410-24983-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced calls to kzalloc followed by memcpy with a single call to kmemdup.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 net/bluetooth/a2mp.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/a2mp.c b/net/bluetooth/a2mp.c
index eb0f4b1..17f33a6 100644
--- a/net/bluetooth/a2mp.c
+++ b/net/bluetooth/a2mp.c
@@ -397,13 +397,12 @@ static int a2mp_getampassoc_rsp(struct amp_mgr *mgr, struct sk_buff *skb,
 	if (ctrl) {
 		u8 *assoc;
 
-		assoc = kzalloc(assoc_len, GFP_KERNEL);
+		assoc = kmemdup(rsp->amp_assoc, assoc_len, GFP_KERNEL);
 		if (!assoc) {
 			amp_ctrl_put(ctrl);
 			return -ENOMEM;
 		}
 
-		memcpy(assoc, rsp->amp_assoc, assoc_len);
 		ctrl->assoc = assoc;
 		ctrl->assoc_len = assoc_len;
 		ctrl->assoc_rem_len = assoc_len;
@@ -472,13 +471,12 @@ static int a2mp_createphyslink_req(struct amp_mgr *mgr, struct sk_buff *skb,
 		size_t assoc_len = le16_to_cpu(hdr->len) - sizeof(*req);
 		u8 *assoc;
 
-		assoc = kzalloc(assoc_len, GFP_KERNEL);
+		assoc = kmemdup(req->amp_assoc, assoc_len, GFP_KERNEL);
 		if (!assoc) {
 			amp_ctrl_put(ctrl);
 			return -ENOMEM;
 		}
 
-		memcpy(assoc, req->amp_assoc, assoc_len);
 		ctrl->assoc = assoc;
 		ctrl->assoc_len = assoc_len;
 		ctrl->assoc_rem_len = assoc_len;
-- 
1.7.9.5

