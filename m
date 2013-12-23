Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab3LWVzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:55:47 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45293 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab3LWVzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:55:14 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 23 Dec 2013 13:55:03 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Brett Rudley <brudley@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] net: wireless: brcm80211: Drop debug version with build
 date/time
Message-ID: <69320ca2cc6f70265844d70b890d661dc4186f8b.1387833347.git.josh@joshtriplett.org>
References: <cover.1387833347.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387833347.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already has this information, and individual drivers
shouldn't duplicate that.  This also eliminates the use of __DATE__ and
__TIME__, which make the build non-deterministic.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 9431af2..78e2999b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -32,15 +32,8 @@
 #define BRCMF_DEFAULT_SCAN_UNASSOC_TIME	40
 #define BRCMF_DEFAULT_PACKET_FILTER	"100 0 0 0 0x01 0x00"
 
-#ifdef DEBUG
-static const char brcmf_version[] =
-	"Dongle Host Driver, version " BRCMF_VERSION_STR "\nCompiled on "
-	__DATE__ " at " __TIME__;
-#else
 static const char brcmf_version[] =
 	"Dongle Host Driver, version " BRCMF_VERSION_STR;
-#endif
-
 
 bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 		      struct sk_buff *pkt, int prec)
-- 
1.8.5.2

