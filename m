Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab3KIGvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:51:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab3KIGvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 43/74] staging: ozwpan: prevent overflow in oz_cdev_write()
Date: Fri,  8 Nov 2013 22:51:48 -0800
Message-Id: <20131109065116.547540346@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit c2c65cd2e14ada6de44cb527e7f1990bede24e15 upstream.

We need to check "count" so we don't overflow the ei->data buffer.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/ozwpan/ozcdev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -153,6 +153,9 @@ static ssize_t oz_cdev_write(struct file
 	struct oz_app_hdr *app_hdr;
 	struct oz_serial_ctx *ctx;
 
+	if (count > sizeof(ei->data) - sizeof(*elt) - sizeof(*app_hdr))
+		return -EINVAL;
+
 	spin_lock_bh(&g_cdev.lock);
 	pd = g_cdev.active_pd;
 	if (pd)


