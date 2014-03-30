Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaC3Vbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 17:31:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbaC3Vbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 17:31:40 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Franky Lin <frankyl@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH 1/4] brcm80211: deinline brcmf_chip_cr4_enterdl, save 440 bytes
Date: Sun, 30 Mar 2014 23:31:16 +0200
Message-Id: <1396215079-7541-1-git-send-email-dvlasenk@redhat.com>
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
 drivers/net/wireless/brcm80211/brcmfmac/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index df130ef..d020b0b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -933,7 +933,7 @@ static bool brcmf_chip_cm3_exitdl(struct brcmf_chip_priv *chip)
 	return true;
 }
 
-static inline void
+static void
 brcmf_chip_cr4_enterdl(struct brcmf_chip_priv *chip)
 {
 	struct brcmf_core *core;
-- 
1.8.1.4

