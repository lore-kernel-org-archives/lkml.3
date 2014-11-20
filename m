Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbaKTPvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:51:00 -0500
Received: from mout.web.de ([212.227.15.4]:59144 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904AbaKTPu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:50:58 -0500
Message-ID: <546E0DC8.3050906@users.sourceforge.net>
Date: Thu, 20 Nov 2014 16:50:32 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>, Brett Rudley <brudley@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        netdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] net: brcm80211: Deletion of unnecessary checks before
 two function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:kHFd/DaYUgPdTA+tIG+kg7YFtjTkOvJslt/kJPmWnEIpacSVo9P
 xn8m4Re3BtiJGzCweeW4hetKyxzwkxcYA1eEWNCnT9NanLJRLqvUz0RqK/yK08pAMO12O3a
 7O/BAYAYU18fkP4TocGp19S3d85kmEsnT+WdY0bjG00+MNLzWTCVyDkMypiFcr1t88yptnS
 zuss9GIWRA6cpvfnpR04w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 16:42:51 +0100

The functions brcmu_pkt_buf_free_skb() and release_firmware() test whether
their argument is NULL and then return immediately. Thus the test around
the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 3 +--
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 3 +--
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   | 3 +--
 drivers/net/wireless/brcm80211/brcmsmac/main.c     | 3 +--
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index f55f625..8ff7037 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2539,8 +2539,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 	brcmu_pktq_flush(&bus->txq, true, NULL, NULL);
 
 	/* Clear any held glomming stuff */
-	if (bus->glomd)
-		brcmu_pkt_buf_free_skb(bus->glomd);
+	brcmu_pkt_buf_free_skb(bus->glomd);
 	brcmf_sdio_free_glom(bus);
 
 	/* Clear rx control and wake any waiters */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index 8ea9f28..3a2d014 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -262,8 +262,7 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 
 fail:
 	brcmf_dbg(TRACE, "failed: dev=%s\n", dev_name(fwctx->dev));
-	if (fwctx->code)
-		release_firmware(fwctx->code);
+	release_firmware(fwctx->code);
 	device_release_driver(fwctx->dev);
 	kfree(fwctx);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 8f8b937..0cb00dc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -506,8 +506,7 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 		memcpy(buf, skb->data, (len < msgbuf->ioctl_resp_ret_len) ?
 				       len : msgbuf->ioctl_resp_ret_len);
 	}
-	if (skb)
-		brcmu_pkt_buf_free_skb(skb);
+	brcmu_pkt_buf_free_skb(skb);
 
 	return msgbuf->ioctl_resp_status;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 1b47482..ce538a1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1009,8 +1009,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 		if (txh)
 			trace_brcms_txdesc(&wlc->hw->d11core->dev, txh,
 					   sizeof(*txh));
-		if (p)
-			brcmu_pkt_buf_free_skb(p);
+		brcmu_pkt_buf_free_skb(p);
 	}
 
 	if (dma && queue < NFIFO) {
-- 
2.1.3

