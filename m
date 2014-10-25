Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaJYSw3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:52:29 -0400
Received: from mout.web.de ([212.227.15.3]:62550 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaJYSw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:52:28 -0400
From: Alexander Stein <alexanders83@web.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Alexander Stein <alexanders83@web.de>, linux-kernel@vger.kernel.org,
        David Fries <David@Fries.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/1] W1: ds2490: Increase timeout when waiting for status
Date: Sat, 25 Oct 2014 14:26:13 +0200
Message-Id: <1414239973-4819-1-git-send-email-alexanders83@web.de>
X-Mailer: git-send-email 2.1.2
X-Provags-ID: V03:K0:Gxo+kr4L79In3OsQ6Ckv/3O5yP2vWzrTr5ESLBfQmYph+J6VEKr
 6He34FCO8otUF/tF1+fqXy/JMBJZgkyz9egAbGqu/3YI983Af+Oq2pevteVxoUzEltLrdn7
 9a3Yz2YDhU6nqkFxNBkKERZV61aLQG5bZDo/HL9l53NSDYyn3XS+bAobIXrVSlFCLqRDsOY
 dQi0IMvYmGZRE+gbZk0JQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the bulk message timeout to the other ones (1000ms). Otherwise the
following dmesg errors can be seen on a Raspberry Pi:
[   31.492386] Failed to read 1-wire data from 0x81: err=-110.
[   31.504168] 0x81: count=-110, status:
[   31.613404] Failed to read 1-wire data from 0x81: err=-110.
[   31.621915] 0x81: count=-110, status:
[   43.260968] Failed to read 1-wire data from 0x81: err=-110.
[   43.270998] 0x81: count=-110, status:
[   43.379959] Failed to read 1-wire data from 0x81: err=-110.
[   43.388854] 0x81: count=-110, status:

Signed-off-by: Alexander Stein <alexanders83@web.de>
---
 drivers/w1/masters/ds2490.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 1de6df8..049a884 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -253,7 +253,7 @@ static int ds_recv_status_nodump(struct ds_device *dev, struct ds_status *st,
 
 	count = 0;
 	err = usb_interrupt_msg(dev->udev, usb_rcvintpipe(dev->udev,
-		dev->ep[EP_STATUS]), buf, size, &count, 100);
+		dev->ep[EP_STATUS]), buf, size, &count, 1000);
 	if (err < 0) {
 		pr_err("Failed to read 1-wire data from 0x%x: err=%d.\n",
 		       dev->ep[EP_STATUS], err);
-- 
2.1.2

