Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbaJMCbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:31:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbaJMCbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:31:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.17 17/25] usb: gadget: f_fs: signedness bug in __ffs_func_bind_do_descs()
Date: Mon, 13 Oct 2014 04:25:10 +0200
Message-Id: <20141013022455.024319688@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022454.289398272@linuxfoundation.org>
References: <20141013022454.289398272@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 85b06f5e53d17c15844ef3cd45d0c7107f0ae45c upstream.

We need "idx" to be signed for the error handling to work.

Fixes: 6d5c1c77bbf9 ('usb: gadget: f_fs: fix the redundant ep files problem')
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/function/f_fs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2393,7 +2393,8 @@ static int __ffs_func_bind_do_descs(enum
 	struct usb_endpoint_descriptor *ds = (void *)desc;
 	struct ffs_function *func = priv;
 	struct ffs_ep *ffs_ep;
-	unsigned ep_desc_id, idx;
+	unsigned ep_desc_id;
+	int idx;
 	static const char *speed_names[] = { "full", "high", "super" };
 
 	if (type != FFS_DESCRIPTOR)


