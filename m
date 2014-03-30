Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaC3Vbr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 17:31:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbaC3Vbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 17:31:44 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Franky Lin <frankyl@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH 2/4] brcm80211: deinline dma64_dd_upd, save 157 bytes
Date: Sun, 30 Mar 2014 23:31:17 +0200
Message-Id: <1396215079-7541-2-git-send-email-dvlasenk@redhat.com>
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

In this case, function is large and has two callsites.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 4fb9635..5acf73e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -711,7 +711,7 @@ struct dma_pub *dma_attach(char *name, struct brcms_c_info *wlc,
 	return NULL;
 }
 
-static inline void
+static void
 dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
 	     dma_addr_t pa, uint outidx, u32 *flags, u32 bufcount)
 {
-- 
1.8.1.4

