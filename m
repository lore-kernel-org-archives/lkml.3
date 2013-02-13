Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776Ab3BMCyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:54:47 -0500
Received: from mout.gmx.net ([212.227.17.21]:51305 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab3BMCyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:54:05 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/xS4555nDxdwB/U0twyf4CWWt9LOqTuAS1bbRS13
	kDvy4/DpOALwTC
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Andrew Miller <amiller@amilx.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] staging/rtl8187se: Remove code without effect
Date: Wed, 13 Feb 2013 03:58:15 +0100
Message-Id: <1360724302-2794-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360724302-2794-1-git-send-email-peterhuewe@gmx.de>
References: <1360724302-2794-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The local variable u4bAcParam is never read/used after assignment,
thus we can remove the declaration, assignment and any related code.

-> the local variables u1bAIFS, eACI and pAcParam can also be removed.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/rtl8187se/r8185b_init.c |   39 +------------------------------
 1 files changed, 1 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 41419f0..5495d1e 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -928,44 +928,7 @@ void ActUpdateChannelAccessSetting(struct net_device *dev,
 
 		for (eACI = 0; eACI < AC_MAX; eACI++) {
 			AcParam.f.AciAifsn.f.ACI = (u8)eACI;
-			{
-				PAC_PARAM	pAcParam = (PAC_PARAM)(&AcParam);
-				AC_CODING	eACI;
-				u8		u1bAIFS;
-				u32		u4bAcParam;
-
-				/*  Retrieve parameters to update. */
-				eACI = pAcParam->f.AciAifsn.f.ACI;
-				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * ChnlAccessSetting->SlotTimeTimer + aSifsTime;
-				u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit)) << AC_PARAM_TXOP_LIMIT_OFFSET)	|
-						(((u32)(pAcParam->f.Ecw.f.ECWmax)) << AC_PARAM_ECW_MAX_OFFSET)	|
-						(((u32)(pAcParam->f.Ecw.f.ECWmin)) << AC_PARAM_ECW_MIN_OFFSET)	|
-						(((u32)u1bAIFS) << AC_PARAM_AIFS_OFFSET));
-
-				switch (eACI) {
-				case AC1_BK:
-					/* write_nic_dword(dev, AC_BK_PARAM, u4bAcParam); */
-					break;
-
-				case AC0_BE:
-					/* write_nic_dword(dev, AC_BK_PARAM, u4bAcParam); */
-					break;
-
-				case AC2_VI:
-					/* write_nic_dword(dev, AC_BK_PARAM, u4bAcParam); */
-					break;
-
-				case AC3_VO:
-					/* write_nic_dword(dev, AC_BK_PARAM, u4bAcParam); */
-					break;
-
-				default:
-					DMESGW("SetHwReg8185(): invalid ACI: %d !\n", eACI);
-					break;
-				}
-
-				write_nic_byte(dev, ACM_CONTROL, 0);
-			}
+			write_nic_byte(dev, ACM_CONTROL, 0);
 		}
 	}
 }
-- 
1.7.8.6

