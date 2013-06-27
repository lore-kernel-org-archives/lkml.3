Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3F0JTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:19:15 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48865 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3F0JTM (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 27 Jun 2013 05:19:12 -0400
From: David Chang <dchang@suse.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jlee@suse.com,
        David Chang <dchang@suse.com>
Subject: [PATCH 2/2 net-next] usbnet: ax88179_178a: add .reset_resume hook
Date: Thu, 27 Jun 2013 17:16:43 +0800
Message-Id: <1372324603-4556-2-git-send-email-dchang@suse.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1372324603-4556-1-git-send-email-dchang@suse.com>
References: <1372324603-4556-1-git-send-email-dchang@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I tested with the AX88179 usb dongle, if without .reset_resume hook,
after S3/S4 resume you have to enable network interface or reload the
dirver module manually otherwise the network interface can not work.

Signed-off-by: David Chang <dchang@suse.com>
---
 drivers/net/usb/ax88179_178a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 7ce243b..1e3c302 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1433,6 +1433,7 @@ static struct usb_driver ax88179_178a_driver = {
 	.probe =	usbnet_probe,
 	.suspend =	ax88179_suspend,
 	.resume =	ax88179_resume,
+	.reset_resume =	ax88179_resume,
 	.disconnect =	usbnet_disconnect,
 	.supports_autosuspend = 1,
 	.disable_hub_initiated_lpm = 1,
-- 
1.8.1.4

