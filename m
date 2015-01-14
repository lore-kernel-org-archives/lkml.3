Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbbANHeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:34:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbbANHd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:33:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.14 06/77] ath9k: fix BE/BK queue order
Date: Tue, 13 Jan 2015 23:22:46 -0800
Message-Id: <20150114072224.517373182@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 78063d81d353e10cbdd279c490593113b8fdae1c upstream.

Hardware queues are ordered by priority. Use queue index 0 for BK, which
has lower priority than BE.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/hw.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -216,8 +216,8 @@
 #define AH_WOW_BEACON_MISS		BIT(3)
 
 enum ath_hw_txq_subtype {
-	ATH_TXQ_AC_BE = 0,
-	ATH_TXQ_AC_BK = 1,
+	ATH_TXQ_AC_BK = 0,
+	ATH_TXQ_AC_BE = 1,
 	ATH_TXQ_AC_VI = 2,
 	ATH_TXQ_AC_VO = 3,
 };


