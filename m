Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbaKRBpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:45:55 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58494 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaKRBpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:45:53 -0500
Date: Tue, 18 Nov 2014 01:45:41 +0000
From: "Tobenna P. Igwe" <ptigwe@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        Jes.Sorensen@redhat.com
Subject: [PATCH] staging:rtl8723au: Fix sparse warning cast to restricted
 __le16
Message-ID: <20141118014529.GA937@Tobenna-Peter-Igwes-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warning:

drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c:343:36: warning:
cast to restricted __le16

by using the le16_to_cpus function.

Signed-off-by: Tobenna P. Igwe <ptigwe@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
index d80ea4e..78665ee 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
@@ -340,7 +340,7 @@ static u8 bthci_GetAssocInfo(struct rtw_adapter *padapter, u8 EntryNum)
 			tempBuf, TotalLen-BaseMemoryShift);
 
 		pAmpAsoc = (struct amp_assoc_structure *)tempBuf;
-		pAmpAsoc->Length = le16_to_cpu(pAmpAsoc->Length);
+		le16_to_cpus(&pAmpAsoc->Length);
 		BaseMemoryShift += 3 + pAmpAsoc->Length;
 
 		RTPRINT(FIOCTL, IOCTL_BT_HCICMD, ("TypeID = 0x%x, ", pAmpAsoc->TypeID));
-- 
1.7.10.4

