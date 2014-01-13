Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaAMQBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:01:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52961 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbaAMQBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 036/208] usb: cdc-wdm: manage_power should always set needs_remote_wakeup
Date: Mon, 13 Jan 2014 15:57:57 +0000
Message-Id: <1389628849-1614-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
index d3318a0..6463ca3 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -820,13 +820,11 @@ static int wdm_manage_power(struct usb_interface *intf, int on)
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

