Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab3AOSww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:52:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:34169 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757104Ab3AOSwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:52:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        Paul Stewart <pstew@chromium.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 019/221] ath9k_hw: Enable hw PLL power save for AR9462
Date: Tue, 15 Jan 2013 10:49:06 -0800
Message-Id: <20130115184959.439286684@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 1680260226a8fd2aab590319da83ad8e610da9bd upstream.

This reduced the power consumption to half in full and network sleep.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: Paul Stewart <pstew@chromium.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -219,10 +219,10 @@ static void ar9003_hw_init_mode_regs(str
 
 		/* Awake -> Sleep Setting */
 		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-			       ar9462_pciephy_pll_on_clkreq_disable_L1_2p0);
+			       ar9462_pciephy_clkreq_disable_L1_2p0);
 		/* Sleep -> Awake Setting */
 		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-			       ar9462_pciephy_pll_on_clkreq_disable_L1_2p0);
+			       ar9462_pciephy_clkreq_disable_L1_2p0);
 
 		/* Fast clock modal settings */
 		INIT_INI_ARRAY(&ah->iniModesFastClock,


