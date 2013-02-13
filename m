Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759692Ab3BMCyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:54:05 -0500
Received: from mout.gmx.net ([212.227.15.18]:51281 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab3BMCyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:54:03 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/1NrlAfPf1dpQT3tFifyyvF76wzv1X5Ymx0i/D1t
	Qu2J7LKoBDMFj/
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Andrew Miller <amiller@amilx.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] staging/rtl8187se: Remove code without effect
Date: Wed, 13 Feb 2013 03:58:14 +0100
Message-Id: <1360724302-2794-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local variable AcmCtrl is never read/used after assignment so we can remove
all assignments to it and the related code around the assignments.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/rtl8187se/r8185b_init.c |   49 +------------------------------
 1 files changed, 1 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index f1db9e4..41419f0 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -964,54 +964,7 @@ void ActUpdateChannelAccessSetting(struct net_device *dev,
 					break;
 				}
 
-				/* Cehck ACM bit. */
-				/* If it is set, immediately set ACM control bit to downgrading AC for passing WMM testplan. Annie, 2005-12-13.	*/
-				{
-					PACI_AIFSN	pAciAifsn = (PACI_AIFSN)(&pAcParam->f.AciAifsn);
-					AC_CODING	eACI = pAciAifsn->f.ACI;
-
-					/*for 8187B AsynIORead issue */
-					u8	AcmCtrl = 0;
-					if (pAciAifsn->f.ACM) {
-						/* ACM bit is 1. */
-						switch (eACI) {
-						case AC0_BE:
-							AcmCtrl |= (BEQ_ACM_EN|BEQ_ACM_CTL|ACM_HW_EN); /* or 0x21 */
-							break;
-
-						case AC2_VI:
-							AcmCtrl |= (VIQ_ACM_EN|VIQ_ACM_CTL|ACM_HW_EN); /* or 0x42 */
-							break;
-
-						case AC3_VO:
-							AcmCtrl |= (VOQ_ACM_EN|VOQ_ACM_CTL|ACM_HW_EN); /* or 0x84 */
-							break;
-
-						default:
-							DMESGW("SetHwReg8185(): [HW_VAR_ACM_CTRL] ACM set failed: eACI is %d\n", eACI);
-							break;
-						}
-					} else {
-						/* ACM bit is 0. */
-						switch (eACI) {
-						case AC0_BE:
-							AcmCtrl &= ((~BEQ_ACM_EN) & (~BEQ_ACM_CTL) & (~ACM_HW_EN)); /* and 0xDE */
-							break;
-
-						case AC2_VI:
-							AcmCtrl &= ((~VIQ_ACM_EN) & (~VIQ_ACM_CTL) & (~ACM_HW_EN)); /* and 0xBD */
-							break;
-
-						case AC3_VO:
-							AcmCtrl &= ((~VOQ_ACM_EN) & (~VOQ_ACM_CTL) & (~ACM_HW_EN)); /* and 0x7B */
-							break;
-
-						default:
-							break;
-						}
-					}
-					write_nic_byte(dev, ACM_CONTROL, 0);
-				}
+				write_nic_byte(dev, ACM_CONTROL, 0);
 			}
 		}
 	}
-- 
1.7.8.6

