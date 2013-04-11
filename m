Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3DKUZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:25:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab3DKUZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:25:53 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=sPoVYiO2IPAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xA6unY6I8JQA:10 a=jmWCE8W1go-RpaolMxwA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202546.580498368@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 002/171 ] ppp: Revert backport of "ppp: set qdisc_tx_busylock to avoid LOCKDEP
 splat"
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0002-ppp-Revert-backport-of-ppp-set-qdisc_tx_busylock-to-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 387e6a2cc250f2a6a182a5db1cbf7e40500bc5eb
"ppp: set qdisc_tx_busylock to avoid LOCKDEP splat" which was a backport
of upstream commit 0b652fb68c02c1acd0307d3acac4ae7123536031, should not
have been ported to 3.6.11.1 as it broke the build.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ppp/ppp_generic.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 2603b99..5c05572 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1021,15 +1021,7 @@ ppp_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return err;
 }
 
-static struct lock_class_key ppp_tx_busylock;
-static int ppp_dev_init(struct net_device *dev)
-{
-	dev->qdisc_tx_busylock = &ppp_tx_busylock;
-	return 0;
-}
-
 static const struct net_device_ops ppp_netdev_ops = {
-	.ndo_init	 = ppp_dev_init,
 	.ndo_start_xmit = ppp_start_xmit,
 	.ndo_do_ioctl   = ppp_net_ioctl,
 };
-- 
1.7.10.4


