Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3FPW1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:27:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46293 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755543Ab3FPWIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:51 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Steve Conklin" <steve.conklin@canonical.com>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.197598142@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [01/83] rapidio/tsi721: Fix interrupt mask when handling MSI
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Commit 1619f441963e 'rapidio/tsi721: fix bug in MSI interrupt
handling' (commit 1ccc819da6fd upstream) makes the MSI handler disable
and re-enable interrupts.  When re-enabling interrupts, we should set
the same flags as were originally set, but this changed in Linux 3.5 so
the flags are now inconsistent in 3.2.  In fact, the extra flag isn't
even defined in 3.2.  Remove the extra flag from the MSI handler.

Reported-by: Steve Conklin <steve.conklin@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -555,7 +555,7 @@ static irqreturn_t tsi721_irqhandler(int
 	/* For MSI mode re-enable device-level interrupts */
 	if (priv->flags & TSI721_USING_MSI) {
 		dev_int = TSI721_DEV_INT_SR2PC_CH | TSI721_DEV_INT_SRIO |
-			TSI721_DEV_INT_SMSG_CH | TSI721_DEV_INT_BDMA_CH;
+			TSI721_DEV_INT_SMSG_CH;
 		iowrite32(dev_int, priv->regs + TSI721_DEV_INTE);
 	}
 

