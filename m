Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaAMO1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:27:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51294 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaAMOZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 29/96] usb: cdc-wdm: manage_power should always set needs_remote_wakeup
Date: Mon, 13 Jan 2014 14:23:52 +0000
Message-Id: <1389623099-18783-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit 4144bc861ed7934d56f16d2acd808d44af0fcc90 upstream.

Reported-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-wdm.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 7c25710..e13be3d 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -826,13 +826,11 @@ static int wdm_manage_power(struct usb_interface *intf, int on)
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

