Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054AbaFQQW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:22:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50676 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964915AbaFQQWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:22:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>,
        Christian Schmiedl <christian.schmiedl@gemalto.com>,
        Nicolaus Colberg <nicolaus.colberg@gemalto.com>,
        Aleksander Morgado <aleksander@lanedo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 082/121] net: qmi_wwan: fix Cinterion PLXX product ID
Date: Tue, 17 Jun 2014 09:17:40 -0700
Message-Id: <1403021899-16708-55-git-send-email-kamal@canonical.com>
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

From: Aleksander Morgado <aleksander@lanedo.com>

[ Upstream commit 2d77f343343c4f38b8f94be1964bbbc6456a147f ]

Cinterion PLXX LTE devices have a 0x0060 product ID, not 0x12d1.

The blacklisting in the serial/option driver does actually use the correct PID,
as per commit 8ff10bdb14a52e3f25d4ce09e0582a8684c1a6db ('USB: Blacklisted
Cinterion's PLxx WWAN Interface').

CC: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
CC: Christian Schmiedl <christian.schmiedl@gemalto.com>
CC: Nicolaus Colberg <nicolaus.colberg@gemalto.com>
Signed-off-by: Aleksander Morgado <aleksander@lanedo.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Acked-by: Christian Schmiedl <christian.schmiedl@gemalto.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 6aeb53b..c989f99 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -577,6 +577,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1201, 2)},	/* Telit LE920 */
+	{QMI_FIXED_INTF(0x1e2d, 0x0060, 4)},	/* Cinterion PLxx */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
1.9.1

