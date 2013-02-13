Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab3BMCvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:51:41 -0500
Received: from mout.gmx.net ([212.227.17.21]:63253 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759777Ab3BMCu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:50:27 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/eaJRLxL7eDD5f72RV+ZoV/ECBrnn1yBKbKb0jV3
	XoKOcR483KEY6k
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Yunhong Jiang <yunhong.jiang@intel.com>,
        Sheng Yang <sheng@linux.intel.com>,
        "Mike A. Chan" <mikechan@google.com>,
        Xiaohui Xin <xiaohui.xin@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 6/9] staging/rtl8187se: Remove temporary variable for return value
Date: Wed, 13 Feb 2013 03:54:31 +0100
Message-Id: <1360724074-2445-6-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360724074-2445-1-git-send-email-peterhuewe@gmx.de>
References: <1360724074-2445-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The simple PlatformIORead1Byte function doesn't need to store its return
value in a temporary variable; rather simply return the value directly.

By moving the function to the top we can also get rid of the forward
declaration.

The wrapper functions could be easily replaced by direct calls to
read_nic_byte but is kept for readability.

Since this functions is local only we can mark it as static.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/rtl8187se/r8185b_init.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index a3b836c..1dfa78e 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -115,6 +115,11 @@ static u8 OFDM_CONFIG[]	= {
 	 *---------------------------------------------------------------
 	 */
 
+static u8 PlatformIORead1Byte(struct net_device *dev, u32 offset)
+{
+	return read_nic_byte(dev, offset);
+}
+
 void PlatformIOWrite1Byte(struct net_device *dev, u32 offset, u8 data)
 {
 	write_nic_byte(dev, offset, data);
@@ -127,8 +132,6 @@ void PlatformIOWrite2Byte(struct net_device *dev, u32 offset, u16 data)
 	read_nic_word(dev, offset); /* To make sure write operation is completed, 2005.11.09, by rcnjko. */
 }
 
-u8 PlatformIORead1Byte(struct net_device *dev, u32 offset);
-
 void PlatformIOWrite4Byte(struct net_device *dev, u32 offset, u32 data)
 {
 	if (offset == PhyAddr) {
@@ -172,16 +175,6 @@ void PlatformIOWrite4Byte(struct net_device *dev, u32 offset, u32 data)
 	}
 }
 
-u8 PlatformIORead1Byte(struct net_device *dev, u32 offset)
-{
-	u8	data = 0;
-
-	data = read_nic_byte(dev, offset);
-
-
-	return data;
-}
-
 u16 PlatformIORead2Byte(struct net_device *dev, u32 offset)
 {
 	u16	data = 0;
-- 
1.7.8.6

