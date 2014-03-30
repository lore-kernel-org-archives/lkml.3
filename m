Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaC3Vb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 17:31:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbaC3Vby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 17:31:54 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Franky Lin <frankyl@broadcom.com>, Arend van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH 3/4] brcm80211: deinline wlc_intstatus, save 429 bytes
Date: Sun, 30 Mar 2014 23:31:18 +0200
Message-Id: <1396215079-7541-3-git-send-email-dvlasenk@redhat.com>
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
 drivers/net/wireless/brcm80211/brcmsmac/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 9417cb5..fa7bc18 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2539,7 +2539,7 @@ brcms_c_mute(struct brcms_c_info *wlc, bool mute_tx)
  *   0 if the interrupt is not for us, or we are in some special cases;
  *   device interrupt status bits otherwise.
  */
-static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
+static u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
 	struct bcma_device *core = wlc_hw->d11core;
-- 
1.8.1.4

