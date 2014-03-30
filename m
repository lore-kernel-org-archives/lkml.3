Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaC3VcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 17:32:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbaC3Vb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 17:31:56 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Franky Lin <frankyl@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH 4/4] brcm80211: deinline brcmf_sdio_clrintr, save 8979 bytes
Date: Sun, 30 Mar 2014 23:31:19 +0200
Message-Id: <1396215079-7541-4-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1396215079-7541-1-git-send-email-dvlasenk@redhat.com>
References: <1396215079-7541-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Automated script discovered that without forced inlining,
gcc-4.7 generates smaller code for this function.

There is no need to declare static functions inline anyway:
nowadays gcc detects single-callsite static functions
which benefit from inlining.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 47a6f39..55a6d0d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2516,7 +2516,7 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 	bus->tx_seq = bus->rx_seq = 0;
 }
 
-static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
+static void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
 {
 	unsigned long flags;
 
-- 
1.8.1.4

