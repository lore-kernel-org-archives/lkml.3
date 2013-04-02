Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508Ab3DBWNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:13:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933412Ab3DBWNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:13:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 114/124] fec: Fix the build as module
Date: Tue,  2 Apr 2013 15:11:36 -0700
Message-Id: <20130402221117.397955394@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Fabio Estevam <fabio.estevam@freescale.com>

[ Upstream commit 9d73adf431e093b23fb4990f1ade11283cb67a98 ]

Since commit ff43da86c69 (NET: FEC: dynamtic check DMA desc buff type) the
following build error happens when CONFIG_FEC=m

ERROR: "fec_ptp_init" [drivers/net/ethernet/freescale/fec.ko] undefined!
ERROR: "fec_ptp_ioctl" [drivers/net/ethernet/freescale/fec.ko] undefined!
ERROR: "fec_ptp_start_cyclecounter" [drivers/net/ethernet/freescale/fec.ko] undefined!

Fix it by exporting the required fec_ptp symbols.

Reported-by: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -128,6 +128,7 @@ void fec_ptp_start_cyclecounter(struct n
 
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 }
+EXPORT_SYMBOL(fec_ptp_start_cyclecounter);
 
 /**
  * fec_ptp_adjfreq - adjust ptp cycle frequency
@@ -318,6 +319,7 @@ int fec_ptp_ioctl(struct net_device *nde
 	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
 	    -EFAULT : 0;
 }
+EXPORT_SYMBOL(fec_ptp_ioctl);
 
 /**
  * fec_time_keep - call timecounter_read every second to avoid timer overrun
@@ -381,3 +383,4 @@ void fec_ptp_init(struct net_device *nde
 		pr_info("registered PHC device on %s\n", ndev->name);
 	}
 }
+EXPORT_SYMBOL(fec_ptp_init);


