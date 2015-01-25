Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbbAYSWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:22:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbbAYSKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mario Schuknecht <mario.schuknecht@dresearch-fe.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.18 147/183] usb: gadget: gadgetfs: Free memory allocated by memdup_user()
Date: Sun, 25 Jan 2015 10:07:49 -0800
Message-Id: <20150125180816.552690984@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Schuknecht <mario.schuknecht@dresearch-fe.de>

commit b44be2462dbe3e23f0aedff64de52a1e8e47a1cd upstream.

Commit 3b74c73f8d6f053f422e85fce955b61fb181cfe7 switched over to memdup_user()
in ep_write() function and removed kfree (kbuf).
memdup_user() function allocates memory which is never freed.

Fixes: 3b74c73 (usb: gadget: inode: switch over to memdup_user())
Signed-off-by: Mario Schuknecht <mario.schuknecht@dresearch-fe.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/legacy/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -449,6 +449,7 @@ ep_write (struct file *fd, const char __
 		data->name, len, (int) value);
 free1:
 	mutex_unlock(&data->lock);
+	kfree (kbuf);
 	return value;
 }
 


