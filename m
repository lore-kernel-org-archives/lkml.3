Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab3EGNk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:40:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42030 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255Ab3EGNkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 005/118] ath9k_hw: change AR9580 initvals to fix a stability issue
Date: Tue,  7 May 2013 14:37:31 +0100
Message-Id: <1367933964-1564-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit f09a878511997c25a76bf111a32f6b8345a701a5 upstream.

The hardware parsing of Control Wrapper Frames needs to be disabled, as
it has been causing spurious decryption error reports. The initvals for
other chips have been updated to disable it, but AR9580 was left out for
some reason.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
index 06b3f0d..c16bea4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
@@ -648,7 +648,7 @@ static const u32 ar9580_1p0_mac_core[][2] = {
 	{0x00008258, 0x00000000},
 	{0x0000825c, 0x40000000},
 	{0x00008260, 0x00080922},
-	{0x00008264, 0x9bc00010},
+	{0x00008264, 0x9d400010},
 	{0x00008268, 0xffffffff},
 	{0x0000826c, 0x0000ffff},
 	{0x00008270, 0x00000000},
-- 
1.8.1.2

