Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491AbaE2Ep6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:45:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256AbaE2Eip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>,
        Christian Schmiedl <christian.schmiedl@gemalto.com>,
        Nicolaus Colberg <nicolaus.colberg@gemalto.com>,
        Aleksander Morgado <aleksander@lanedo.com>,
        =?UTF-8?q?Bj=F8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 76/86] net: qmi_wwan: fix Cinterion PLXX product ID
Date: Wed, 28 May 2014 21:37:51 -0700
Message-Id: <20140529043523.555416792@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -716,7 +716,7 @@ static const struct usb_device_id produc
 	{QMI_FIXED_INTF(0x2357, 0x9000, 4)},	/* TP-LINK MA260 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1201, 2)},	/* Telit LE920 */
-	{QMI_FIXED_INTF(0x1e2d, 0x12d1, 4)},	/* Cinterion PLxx */
+	{QMI_FIXED_INTF(0x1e2d, 0x0060, 4)},	/* Cinterion PLxx */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */


