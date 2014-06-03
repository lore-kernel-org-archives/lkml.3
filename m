Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbaFCLqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:46:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43906 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971AbaFCLnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:43:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>,
        Christian Schmiedl <christian.schmiedl@gemalto.com>,
        Nicolaus Colberg <nicolaus.colberg@gemalto.com>,
        Aleksander Morgado <aleksander@lanedo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 127/138] net: qmi_wwan: fix Cinterion PLXX product ID
Date: Tue,  3 Jun 2014 12:39:33 +0100
Message-Id: <1401795584-22664-128-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Morgado <aleksander@lanedo.com>

commit 2d77f343343c4f38b8f94be1964bbbc6456a147f upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/usb/qmi_wwan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 189e450bbc37..24a0e9f365d7 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -716,7 +716,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1201, 2)},	/* Telit LE920 */
-	{QMI_FIXED_INTF(0x1e2d, 0x12d1, 4)},	/* Cinterion PLxx */
+	{QMI_FIXED_INTF(0x1e2d, 0x0060, 4)},	/* Cinterion PLxx */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
1.9.1

