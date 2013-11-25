Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab3KYNY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:24:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57075 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab3KYNHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 28/78] staging: ozwpan: prevent overflow in oz_cdev_write()
Date: Mon, 25 Nov 2013 13:06:15 +0000
Message-Id: <1385384825-21681-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit c2c65cd2e14ada6de44cb527e7f1990bede24e15 upstream.

We need to check "count" so we don't overflow the ei->data buffer.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/ozwpan/ozcdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 27325f7..03dcd1b 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -150,6 +150,9 @@ ssize_t oz_cdev_write(struct file *filp, const char __user *buf, size_t count,
 	struct oz_app_hdr *app_hdr;
 	struct oz_serial_ctx *ctx;
 
+	if (count > sizeof(ei->data) - sizeof(*elt) - sizeof(*app_hdr))
+		return -EINVAL;
+
 	spin_lock_bh(&g_cdev.lock);
 	pd = g_cdev.active_pd;
 	if (pd)
-- 
1.8.3.2

