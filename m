Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbaCEP1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:27:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40788 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358AbaCEOYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olivier Sobrie <olivier@sobrie.be>, Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 020/131] can: kvaser_usb: check number of channels returned by HW
Date: Wed,  5 Mar 2014 14:22:24 +0000
Message-Id: <1394029455-23128-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Sobrie <olivier@sobrie.be>

commit 862474f8b46f6c1e600d4934e40ba40646c696ec upstream.

It is needed to check the number of channels returned by the HW because it
cannot be greater than MAX_NET_DEVICES otherwise it will crash.

Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/usb/kvaser_usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index 4b2d5ed..cc3df8a 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -474,6 +474,8 @@ static int kvaser_usb_get_card_info(struct kvaser_usb *dev)
 		return err;
 
 	dev->nchannels = msg.u.cardinfo.nchannels;
+	if (dev->nchannels > MAX_NET_DEVICES)
+		return -EINVAL;
 
 	return 0;
 }
-- 
1.9.0

