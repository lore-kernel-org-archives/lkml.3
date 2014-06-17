Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033AbaFQQXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:23:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50741 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965003AbaFQQXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:23:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 077/121] net: qmi_wwan: fixup Sierra Wireless MC8305 entry
Date: Tue, 17 Jun 2014 09:17:35 -0700
Message-Id: <1403021899-16708-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

[ Upstream commit 5a008ffa73b4401251d548c10cadac6f8a67cfb5 ]

The MC8305 module got an additional entry added based solely on
information from a Windows driver *.inf file. We now have the
actual descriptor layout from one of these modules, and it
consists of two alternate configurations where cfg #1 is a
normal Gobi 2k layout and cfg #2 is MBIM only, using interface
numbers 5 and 6 for MBIM control and data. The extra Windows
driver entry for interface number 5 was most likely a bug.

Deleting the bogus entry to avoid unnecessary qmi_wwan probe
failures when using the MBIM configuration.

Reported-by: Lana Black <sickmind@lavabit.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/qmi_wwan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index f0353ed..fb6f77b 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -615,7 +615,6 @@ static const struct usb_device_id products[] = {
 	{QMI_GOBI_DEVICE(0x1199, 0x9009)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
 	{QMI_GOBI_DEVICE(0x1199, 0x900a)},	/* Sierra Wireless Gobi 2000 Modem device (VT773) */
 	{QMI_GOBI_DEVICE(0x1199, 0x9011)},	/* Sierra Wireless Gobi 2000 Modem device (MC8305) */
-	{QMI_FIXED_INTF(0x1199, 0x9011, 5)},	/* alternate interface number!? */
 	{QMI_GOBI_DEVICE(0x16d8, 0x8002)},	/* CMDTech Gobi 2000 Modem device (VU922) */
 	{QMI_GOBI_DEVICE(0x05c6, 0x9205)},	/* Gobi 2000 Modem device */
 	{QMI_GOBI_DEVICE(0x1199, 0x9013)},	/* Sierra Wireless Gobi 3000 Modem device (MC8355) */
-- 
1.9.1

