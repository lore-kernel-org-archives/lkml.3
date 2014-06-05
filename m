Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaFEE1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:27:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaFEEW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Conklin <steve.conklin@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 199/214] rapidio/tsi721: Fix interrupt mask when handling MSI
Date: Wed,  4 Jun 2014 21:19:22 -0700
Message-Id: <20140605041706.193066155@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 94e0104bca7d6927e85119030b8e6e31fde88a7a upstream.

Commit 1619f441963e 'rapidio/tsi721: fix bug in MSI interrupt
handling' (commit 1ccc819da6fd upstream) makes the MSI handler disable
and re-enable interrupts.  When re-enabling interrupts, we should set
the same flags as were originally set, but this changed in Linux 3.5 so
the flags are now inconsistent in 3.2.  In fact, the extra flag isn't
even defined in 3.2.  Remove the extra flag from the MSI handler.

Reported-by: Steve Conklin <steve.conklin@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rapidio/devices/tsi721.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
 


