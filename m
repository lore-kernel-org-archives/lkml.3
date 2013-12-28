Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab3L1WEm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 17:04:42 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51517 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3L1WEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 17:04:40 -0500
From: Gary Rookard <garyrookard@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, nandu.hgowda@gmail.com, josh@joshtriplett.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Gary Rookard <garyrookard@gmail.com>
Subject: [PATCH] Staging: bcm: DDRInit: fix up some bracing issues.
Date: Sat, 28 Dec 2013 17:04:10 -0500
Message-Id: <1388268250-6090-1-git-send-email-garyrookard@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed some brace coding style issues.

Signed-off-by: Gary Alan Rookard <garyrookard@gmail.com>

---
On branch staging-next
 drivers/staging/bcm/DDRInit.c | 107 ++++++++++++------------------------------
 1 file changed, 30 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index 0f03d7e..ed285b2 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -780,11 +780,9 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 	UINT uiClockSetting = 0;
 	int retval = STATUS_SUCCESS;
 
-	switch (Adapter->chip_id)
-	{
+	switch (Adapter->chip_id) {
 	case 0xbece3200:
-		switch (Adapter->DDRSetting)
-			{
+		switch (Adapter->DDRSetting) {
 		case DDR_80_MHZ:
 			psDDRSetting = asT3LP_DDRSetting80MHz;
 			RegCount = (sizeof(asT3LP_DDRSetting80MHz)/
@@ -800,17 +798,13 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			RegCount = (sizeof(asT3LP_DDRSetting133MHz)/
 			sizeof(struct bcm_ddr_setting));
 			if (Adapter->bMipsConfig == MIPS_200_MHZ)
-					{
 				uiClockSetting = 0x03F13652;
-					}
 			else
-					{
 				uiClockSetting = 0x03F1365B;
-					}
 			break;
 		default:
 			return -EINVAL;
-			}
+		}
 
 		break;
 	case T3LPB:
@@ -823,22 +817,20 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		 */
 	if ((Adapter->chip_id !=  BCS220_2) &&
 		(Adapter->chip_id !=  BCS220_2BC) &&
-		(Adapter->chip_id != BCS220_3))
-		{
+		(Adapter->chip_id != BCS220_3)) {
 		retval = rdmalt(Adapter,(UINT)0x0f000830, &uiResetValue, sizeof(uiResetValue));
 		if (retval < 0) {
 			BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 			return retval;
-				}
+		}
 		uiResetValue |= 0x44;
 		retval = wrmalt(Adapter,(UINT)0x0f000830, &uiResetValue, sizeof(uiResetValue));
 		if (retval < 0) {
 			BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 			return retval;
-				}
 		}
-		switch (Adapter->DDRSetting)
-		{
+	}
+		switch (Adapter->DDRSetting) {
 
 
 
@@ -858,13 +850,9 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			sizeof(struct bcm_ddr_setting));
 
 			if (Adapter->bMipsConfig == MIPS_200_MHZ)
-				{
 				uiClockSetting = 0x03F13652;
-				}
 			else
-				{
 				uiClockSetting = 0x03F1365B;
-				}
 			break;
 
 		case DDR_160_MHZ:
@@ -872,14 +860,10 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			RegCount = sizeof(asT3LPB_DDRSetting160MHz)/sizeof(struct bcm_ddr_setting);
 
 			if (Adapter->bMipsConfig == MIPS_200_MHZ)
-				{
 				uiClockSetting = 0x03F137D2;
-				}
 			else
-				{
 				uiClockSetting = 0x03F137DB;
-				}
-			}
+		}
 			break;
 
 	case 0xbece0110:
@@ -888,8 +872,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 	case 0xbece0130:
 	case 0xbece0300:
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "DDR Setting: %x\n", Adapter->DDRSetting);
-		switch (Adapter->DDRSetting)
-	    {
+		switch (Adapter->DDRSetting) {
 		case DDR_80_MHZ:
 			psDDRSetting = asT3_DDRSetting80MHz;
 			RegCount = (sizeof(asT3_DDRSetting80MHz)/
@@ -910,8 +893,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		}
 	case 0xbece0310:
 	{
-		switch (Adapter->DDRSetting)
-	    {
+		switch (Adapter->DDRSetting) {
 		case DDR_80_MHZ:
 			psDDRSetting = asT3B_DDRSetting80MHz;
 			RegCount = (sizeof(asT3B_DDRSetting80MHz)/
@@ -924,28 +906,21 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			break;
 		case DDR_133_MHZ:
 
-			if (Adapter->bDPLLConfig == PLL_266_MHZ)  /* 266Mhz PLL selected. */
-				{
+			if (Adapter->bDPLLConfig == PLL_266_MHZ) {  /* 266Mhz PLL selected. */
 				memcpy(asT3B_DDRSetting133MHz, asDPLL_266MHZ,
 				sizeof(asDPLL_266MHZ));
 				psDDRSetting = asT3B_DDRSetting133MHz;
 				RegCount = (sizeof(asT3B_DDRSetting133MHz)/
 				sizeof(struct bcm_ddr_setting));
-				}
-			else
-				{
+			} else {
 				psDDRSetting = asT3B_DDRSetting133MHz;
 				RegCount = (sizeof(asT3B_DDRSetting133MHz)/
 				sizeof(struct bcm_ddr_setting));
 				if (Adapter->bMipsConfig == MIPS_200_MHZ)
-					{
 					uiClockSetting = 0x07F13652;
-					}
 				else
-					{
 					uiClockSetting = 0x07F1365B;
-					}
-				}
+			}
 			break;
 		default:
 			return -EINVAL;
@@ -959,16 +934,11 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 
 	value = 0;
 	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "Register Count is =%lu\n", RegCount);
-	while (RegCount && !retval)
-	{
+	while (RegCount && !retval) {
 		if (uiClockSetting && psDDRSetting->ulRegAddress == MIPS_CLOCK_REG)
-		{
 			value = uiClockSetting;
-		}
 		else
-		{
 			value = psDDRSetting->ulRegValue;
-		}
 		retval = wrmalt(Adapter, psDDRSetting->ulRegAddress, &value, sizeof(value));
 		if (STATUS_SUCCESS != retval) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
@@ -979,14 +949,12 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		psDDRSetting++;
 	}
 
-	if (Adapter->chip_id >= 0xbece3300)
-	{
+	if (Adapter->chip_id >= 0xbece3300) {
 
 		mdelay(3);
 		if ((Adapter->chip_id != BCS220_2) &&
 			(Adapter->chip_id != BCS220_2BC) &&
-			(Adapter->chip_id != BCS220_3))
-		{
+			(Adapter->chip_id != BCS220_3)) {
 			/* drive MDDR to half in case of UMA-B:	*/
 			uiResetValue = 0x01010001;
 			retval = wrmalt(Adapter, (UINT)0x0F007018, &uiResetValue, sizeof(uiResetValue));
@@ -1021,8 +989,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		 * and since we dont have internal PMU lets do it under UMA-B chip id.
 		 * we will change this when we will have internal PMU.
 		 */
-		if (Adapter->PmuMode == HYBRID_MODE_7C)
-		{
+		if (Adapter->PmuMode == HYBRID_MODE_7C) {
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
@@ -1055,9 +1022,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
-		}
-		else if (Adapter->PmuMode == HYBRID_MODE_6)
-		{
+		} else if (Adapter->PmuMode == HYBRID_MODE_6) {
 
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if (retval < 0) {
@@ -1107,11 +1072,9 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	int retval = STATUS_SUCCESS;
 	bool bOverrideSelfRefresh = false;
 
-	switch (Adapter->chip_id)
-	{
+	switch (Adapter->chip_id) {
 	case 0xbece3200:
-		switch (Adapter->DDRSetting)
-	  {
+		switch (Adapter->DDRSetting) {
 		case DDR_80_MHZ:
 			psDDRSetting = asT3LP_DDRSetting80MHz;
 			RegCount = ARRAY_SIZE(asT3LP_DDRSetting80MHz);
@@ -1141,8 +1104,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	case BCS220_2BC:
 	case BCS250_BC:
 	case BCS220_3:
-		switch (Adapter->DDRSetting)
-	    {
+		switch (Adapter->DDRSetting) {
 		case DDR_80_MHZ:
 			psDDRSetting = asT3LPB_DDRSetting80MHz;
 			RegCount = ARRAY_SIZE(asT3LPB_DDRSetting80MHz);
@@ -1176,8 +1138,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 		}
 		break;
 	case 0xbece0300:
-		switch (Adapter->DDRSetting)
-	    {
+		switch (Adapter->DDRSetting) {
 		case DDR_80_MHZ:
 			psDDRSetting = asT3_DDRSetting80MHz;
 			RegCount = ARRAY_SIZE(asT3_DDRSetting80MHz);
@@ -1202,8 +1163,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	break;
 	case 0xbece0310:
 	    {
-		switch (Adapter->DDRSetting)
-		    {
+		switch (Adapter->DDRSetting) {
 		case DDR_80_MHZ:
 			psDDRSetting = asT3B_DDRSetting80MHz;
 			RegCount = ARRAY_SIZE(asT3B_DDRSetting80MHz);
@@ -1223,7 +1183,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 			RegCount -= T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
 			psDDRSetting += T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
 		break;
-		      }
+		}
 		break;
 	     }
 	default:
@@ -1232,8 +1192,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	/* total number of Register that has to be dumped */
 	value = RegCount;
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
-	if (retval)
-	{
+	if (retval) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 
 		return retval;
@@ -1242,8 +1201,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	/* signature */
 	value = (0x1d1e0dd0);
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
-	if (retval)
-	{
+	if (retval) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 		return retval;
 	}
@@ -1251,24 +1209,19 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	ul_ddr_setting_load_addr += sizeof(ULONG);
 	RegCount *= (sizeof(struct bcm_ddr_setting)/sizeof(ULONG));
 
-	while (RegCount && !retval)
-	{
+	while (RegCount && !retval) {
 		value = psDDRSetting->ulRegAddress;
 		retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
 		ul_ddr_setting_load_addr += sizeof(ULONG);
-		if (!retval)
-		{
-			if (bOverrideSelfRefresh && (psDDRSetting->ulRegAddress == 0x0F007018))
-			{
+		if (!retval) {
+			if (bOverrideSelfRefresh && (psDDRSetting->ulRegAddress == 0x0F007018)) {
 				value = (psDDRSetting->ulRegValue |(1<<8));
 			if (STATUS_SUCCESS != wrmalt(Adapter, ul_ddr_setting_load_addr,
 				&value, sizeof(value))) {
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 				break;
-				}
 			}
-			else
-			{
+			} else {
 				value =  psDDRSetting->ulRegValue;
 
 				if (STATUS_SUCCESS != wrmalt(Adapter, ul_ddr_setting_load_addr ,
-- 
1.8.5.2

