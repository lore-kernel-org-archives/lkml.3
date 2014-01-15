Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaAOV56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:57:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41039 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaAOV5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:50 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 062/166] usb: cdc-wdm: manage_power should always set needs_remote_wakeup
Date: Wed, 15 Jan 2014 13:51:16 -0800
Message-Id: <1389822780-4729-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit 4144bc861ed7934d56f16d2acd808d44af0fcc90 upstream.

Reported-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/class/cdc-wdm.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 46c9379..59f7d32 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -801,13 +801,11 @@ static int wdm_manage_power(struct usb_interface *intf, int on)
 {
 	/* need autopm_get/put here to ensure the usbcore sees the new value */
 	int rv = usb_autopm_get_interface(intf);
-	if (rv < 0)
-		goto err;
 
 	intf->needs_remote_wakeup = on;
-	usb_autopm_put_interface(intf);
-err:
-	return rv;
+	if (!rv)
+		usb_autopm_put_interface(intf);
+	return 0;
 }
 
 static int wdm_probe(struct usb_interface *intf, const struct usb_device_id *id)
-- 
1.8.3.2

