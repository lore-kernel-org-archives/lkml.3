Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaETKff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:35:35 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:49853 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaETKeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:34:05 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] staging: et131x: Remove useless return variables
Date: Tue, 20 May 2014 12:33:45 +0200
Message-Id: <1400582028-24990-5-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove variables that are initialized with a constant,
are never updated, and are only used as parameter of return.
Return the constant instead of using a variable.

Verified by compilation only.

The coccinelle script that find and fixes this issue is:
// <smpl>
@@
type T;
constant C;
identifier ret;
@@
- T ret = C;
... when != ret
- return ret;
+ return C;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/staging/et131x/et131x.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 15e0f4d..845aecd 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -4237,7 +4237,6 @@ static int et131x_ioctl(struct net_device *netdev, struct ifreq *reqbuf,
 static int et131x_set_packet_filter(struct et131x_adapter *adapter)
 {
 	int filter = adapter->packet_filter;
-	int status = 0;
 	u32 ctrl;
 	u32 pf_ctrl;
 
@@ -4288,7 +4287,7 @@ static int et131x_set_packet_filter(struct et131x_adapter *adapter)
 		writel(pf_ctrl, &adapter->regs->rxmac.pf_ctrl);
 		writel(ctrl, &adapter->regs->rxmac.ctrl);
 	}
-	return status;
+	return 0;
 }
 
 /* et131x_multicast - The handler to configure multicasting on the interface */

