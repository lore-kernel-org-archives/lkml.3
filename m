Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaK3SUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 13:20:16 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:8142 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbaK3STu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 13:19:50 -0500
X-IronPort-AV: E=Sophos;i="5.07,488,1413237600"; 
   d="scan'208";a="91119172"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Valentina Manea <valentina.manea.m@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] usbip: remove unneeded structure
Date: Sun, 30 Nov 2014 19:14:15 +0100
Message-Id: <1417371255-2282-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417371255-2282-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417371255-2282-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete a local structure that is only used to be initialized by memset.

A semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x,i;
@@

{
... when any
-struct i x;
<+... when != x
- memset(&x,...);
...+>
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 tools/usb/usbip/src/usbipd.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/usb/usbip/src/usbipd.c b/tools/usb/usbip/src/usbipd.c
index 2f87f2d..2a7cd2b 100644
--- a/tools/usb/usbip/src/usbipd.c
+++ b/tools/usb/usbip/src/usbipd.c
@@ -91,7 +91,6 @@ static void usbipd_help(void)
 static int recv_request_import(int sockfd)
 {
 	struct op_import_request req;
-	struct op_common reply;
 	struct usbip_exported_device *edev;
 	struct usbip_usb_device pdu_udev;
 	struct list_head *i;
@@ -100,7 +99,6 @@ static int recv_request_import(int sockfd)
 	int rc;
 
 	memset(&req, 0, sizeof(req));
-	memset(&reply, 0, sizeof(reply));
 
 	rc = usbip_net_recv(sockfd, &req, sizeof(req));
 	if (rc < 0) {

