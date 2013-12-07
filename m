Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3LGEzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 23:55:15 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:53652 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab3LGEzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 23:55:13 -0500
From: Gary Rookard <garyrookard@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Gary Rookard <garyrookard@gmail.com>
Subject: [PATCH 6/9] Staging: bcm: DDRInit: tidy up bracing issues.
Date: Fri,  6 Dec 2013 23:55:09 -0500
Message-Id: <1386392109-11773-1-git-send-email-garyrookard@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the sixth patch of a series.

Signed-off-by: Gary Alan Rookard <garyrookard@gmail.com>
---
On branch staging-next
 drivers/staging/bcm/DDRInit.c | 174 +++++++++++++++---------------------------
 1 file changed, 63 insertions(+), 111 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index 1a08b17..8bb3283 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -62,7 +62,7 @@ static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {     /* # DPLL Clock Se
 	{0x0F00A000, 0x00000016},
                                         /* # Enable start bit within memory controller */
 	{0x0F007018, 0x01010000}
-                                        };
+};
 /* 80Mhz */
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 10  /* index for 0x0F007000 */
 static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = { /*  # DPLL Clock Setting */
@@ -114,7 +114,7 @@ static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = { /*  # DPLL Clock Settin
 	{0x0F007094, 0x00000104},
                                         /*# Enable start bit within memory controller */
 	{0x0F007018, 0x01010000}
-                                };
+};
 /* 100Mhz */
 #define T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 13  /* index for 0x0F007000 */
 static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {/*  # DPLL Clock Setting */
@@ -173,7 +173,7 @@ static struct bcm_ddr_setting asT3_DDRSetting100MHz[] = {/*  # DPLL Clock Settin
 	{0x0F007094, 0x00000104},
                                 /* # Enable start bit within memory controller */
 	{0x0F007018, 0x01010000}
-                                };
+};
 
 /* Net T3B DDR Settings */
 /* DDR INIT-133Mhz */
@@ -186,7 +186,7 @@ static struct bcm_ddr_setting asDPLL_266MHZ[] = {
                                         /* Changed source for X-bar and MIPS clock to APLL */
 	{0x0f000840, 0x0FFF1B00},
 	{0x0f000870, 0x00000002}
-									  };
+};
 
 #define T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 11  /* index for 0x0F007000 */
 static struct bcm_ddr_setting asT3B_DDRSetting133MHz[] = {/* # DPLL Clock Setting */
@@ -244,7 +244,7 @@ static struct bcm_ddr_setting asT3B_DDRSetting133MHz[] = {/* # DPLL Clock Settin
 	{0x0F007094, 0x00000104},
                                         /* # Enable start bit within memory controller */
 	{0x0F007018, 0x01010000},
-                                        };
+};
 
 #define T3B_SKIP_CLOCK_PROGRAM_DUMP_80MHZ 9  /*index for 0x0F007000 */
 static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {/* # DPLL Clock Setting */
@@ -297,7 +297,7 @@ static struct bcm_ddr_setting asT3B_DDRSetting80MHz[] = {/* # DPLL Clock Setting
 	{0x0F007094, 0x00000104},
 										/* # Enable start bit within memory controller */
 	{0x0F007018, 0x01010000}
-								};
+};
 
 /* 100Mhz */
 #define T3B_SKIP_CLOCK_PROGRAM_DUMP_100MHZ 9  /* index for 0x0F007000 */
@@ -352,7 +352,7 @@ static struct bcm_ddr_setting asT3B_DDRSetting100MHz[] = {/* # DPLL Clock Settin
 	{0x0F007094, 0x00000104},
 								/* # Enable start bit within memory controller */
 	{0x0F007018, 0x01010000}
-							};
+};
 
 
 #define T3LP_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 9  /*index for 0x0F007000 */
@@ -781,11 +781,9 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 	UINT uiClockSetting = 0;
 	int retval = STATUS_SUCCESS;
 
-    switch (Adapter->chip_id)
-	{
+    switch (Adapter->chip_id) {
 	case 0xbece3200:
-	    switch (Adapter->DDRSetting)
-	    {
+	    switch (Adapter->DDRSetting) {
 	        case DDR_80_MHZ:
 				psDDRSetting = asT3LP_DDRSetting80MHz;
 			    RegCount = (sizeof(asT3LP_DDRSetting80MHz)/
@@ -800,14 +798,10 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 				psDDRSetting = asT3LP_DDRSetting133MHz;
 			    RegCount = (sizeof(asT3LP_DDRSetting133MHz)/
 		 	  		sizeof(struct bcm_ddr_setting));
-				if(Adapter->bMipsConfig == MIPS_200_MHZ)
-				{
+				if (Adapter->bMipsConfig == MIPS_200_MHZ)
 					uiClockSetting = 0x03F13652;
-				}
 				else
-				{
 					uiClockSetting = 0x03F1365B;
-				}
 				break;
 		    default:
 			    return -EINVAL;
@@ -822,24 +816,22 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		/* Set bit 2 and bit 6 to 1 for BBIC 2mA drive
 		 * (please check current value and additionally set these bits)
 		 */
-		if( (Adapter->chip_id !=  BCS220_2) &&
+		if ((Adapter->chip_id !=  BCS220_2) &&
 			(Adapter->chip_id !=  BCS220_2BC) &&
-			(Adapter->chip_id != BCS220_3) )
-		{
+			(Adapter->chip_id != BCS220_3)) {
 				retval = rdmalt(Adapter, (UINT)0x0f000830, &uiResetValue, sizeof(uiResetValue));
-				if(retval < 0) {
+				if (retval < 0) {
 					BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 					return retval;
 				}
 				uiResetValue |= 0x44;
 				retval = wrmalt(Adapter, (UINT)0x0f000830, &uiResetValue, sizeof(uiResetValue));
-				if(retval < 0) {
+				if (retval < 0) {
 					BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 					return retval;
 				}
 		}
-		switch(Adapter->DDRSetting)
-		{
+		switch (Adapter->DDRSetting) {
 
 
 
@@ -858,28 +850,20 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 				RegCount = (sizeof(asT3B_DDRSetting133MHz)/
 						 sizeof(struct bcm_ddr_setting));
 
-				if(Adapter->bMipsConfig == MIPS_200_MHZ)
-				{
+				if (Adapter->bMipsConfig == MIPS_200_MHZ) 
 					uiClockSetting = 0x03F13652;
-				}
 				else
-				{
 					uiClockSetting = 0x03F1365B;
-				}
 			break;
 
 			case DDR_160_MHZ:
 				psDDRSetting = asT3LPB_DDRSetting160MHz;
 				RegCount = sizeof(asT3LPB_DDRSetting160MHz)/sizeof(struct bcm_ddr_setting);
 
-				if(Adapter->bMipsConfig == MIPS_200_MHZ)
-				{
+				if (Adapter->bMipsConfig == MIPS_200_MHZ)
 					uiClockSetting = 0x03F137D2;
-				}
 				else
-				{
 					uiClockSetting = 0x03F137DB;
-				}
 			}
 			break;
 
@@ -889,8 +873,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 	case 0xbece0130:
 	case 0xbece0300:
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "DDR Setting: %x\n", Adapter->DDRSetting);
-	    switch (Adapter->DDRSetting)
-	    {
+	    switch (Adapter->DDRSetting) {
 	        case DDR_80_MHZ:
 				psDDRSetting = asT3_DDRSetting80MHz;
 			    RegCount = (sizeof(asT3_DDRSetting80MHz)/
@@ -911,8 +894,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
         }
 	case 0xbece0310:
 	{
-	    switch (Adapter->DDRSetting)
-	    {
+	    switch (Adapter->DDRSetting) {
 	        case DDR_80_MHZ:
 				psDDRSetting = asT3B_DDRSetting80MHz;
 		        RegCount = (sizeof(asT3B_DDRSetting80MHz)/
@@ -925,27 +907,20 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			break;
             case DDR_133_MHZ:
 
-				if(Adapter->bDPLLConfig == PLL_266_MHZ)/*266Mhz PLL selected. */
-				{
+				if (Adapter->bDPLLConfig == PLL_266_MHZ) { /*266Mhz PLL selected. */
 					memcpy(asT3B_DDRSetting133MHz, asDPLL_266MHZ,
 									 sizeof(asDPLL_266MHZ));
 					psDDRSetting = asT3B_DDRSetting133MHz;
 					RegCount = (sizeof(asT3B_DDRSetting133MHz)/
 									sizeof(struct bcm_ddr_setting));
-				}
-				else
-				{
+				} else {
 					psDDRSetting = asT3B_DDRSetting133MHz;
 					RegCount = (sizeof(asT3B_DDRSetting133MHz)/
 									sizeof(struct bcm_ddr_setting));
-					if(Adapter->bMipsConfig == MIPS_200_MHZ)
-					{
+					if (Adapter->bMipsConfig == MIPS_200_MHZ)
 						uiClockSetting = 0x07F13652;
-					}
-					else
-					{
+					 else
 						uiClockSetting = 0x07F1365B;
-					}
 				}
 				break;
 		    default:
@@ -960,18 +935,13 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 
 	value = 0;
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "Register Count is =%lu\n", RegCount);
-	while(RegCount && !retval)
-	{
-		if(uiClockSetting && psDDRSetting->ulRegAddress == MIPS_CLOCK_REG)
-		{
+	while (RegCount && !retval) {
+		if (uiClockSetting && psDDRSetting->ulRegAddress == MIPS_CLOCK_REG)
 			value = uiClockSetting;
-		}
 		else
-		{
 			value = psDDRSetting->ulRegValue;
-		}
 		retval = wrmalt(Adapter, psDDRSetting->ulRegAddress, &value, sizeof(value));
-		if(STATUS_SUCCESS != retval) {
+		if (STATUS_SUCCESS != retval) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 			break;
 		}
@@ -980,36 +950,33 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		psDDRSetting++;
 	}
 
-	if(Adapter->chip_id >= 0xbece3300  )
-	{
-
+	if (Adapter->chip_id >= 0xbece3300) {
 		mdelay(3);
-		if( (Adapter->chip_id != BCS220_2) &&
+		if ((Adapter->chip_id != BCS220_2) &&
 			(Adapter->chip_id != BCS220_2BC) &&
-			(Adapter->chip_id != BCS220_3))
-		{
+			(Adapter->chip_id != BCS220_3)) {
 			/* drive MDDR to half in case of UMA-B:	*/
 			uiResetValue = 0x01010001;
 			retval = wrmalt(Adapter, (UINT)0x0F007018, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x00040020;
 			retval = wrmalt(Adapter, (UINT)0x0F007094, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x01020101;
 			retval = wrmalt(Adapter, (UINT)0x0F00701c, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x01010000;
 			retval = wrmalt(Adapter, (UINT)0x0F007018, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
@@ -1022,73 +989,70 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		 * and since we dont have internal PMU lets do it under UMA-B chip id.
 	     * we will change this when we will have internal PMU.
 	     */
-		if(Adapter->PmuMode == HYBRID_MODE_7C)
-		{
+		if (Adapter->PmuMode == HYBRID_MODE_7C) {
 			retval = rdmalt(Adapter, (UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter, (UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x1322a8;
 			retval = wrmalt(Adapter, (UINT)0x0f000d1c, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter, (UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter, (UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x132296;
 			retval = wrmalt(Adapter, (UINT)0x0f000d14, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
-		}
-		else if(Adapter->PmuMode == HYBRID_MODE_6 )
-		{
+		} else if (Adapter->PmuMode == HYBRID_MODE_6) {
 
 			retval = rdmalt(Adapter, (UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter, (UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x6003229a;
 			retval = wrmalt(Adapter, (UINT)0x0f000d14, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter, (UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter, (UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x1322a8;
 			retval = wrmalt(Adapter, (UINT)0x0f000d1c, &uiResetValue, sizeof(uiResetValue));
-			if(retval < 0) {
+			if (retval < 0) {
 				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
@@ -1108,11 +1072,9 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	int retval = STATUS_SUCCESS;
 	bool bOverrideSelfRefresh = false;
 
-	switch (Adapter->chip_id)
-	{
+	switch (Adapter->chip_id) {
 	case 0xbece3200:
-	    switch (Adapter->DDRSetting)
-	    {
+	    switch (Adapter->DDRSetting) {
 	        case DDR_80_MHZ:
 				psDDRSetting = asT3LP_DDRSetting80MHz;
                 RegCount = ARRAY_SIZE(asT3LP_DDRSetting80MHz);
@@ -1142,8 +1104,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	case BCS220_2BC:
 	case BCS250_BC:
 	case BCS220_3:
-	    switch (Adapter->DDRSetting)
-	    {
+	    switch (Adapter->DDRSetting) {
 	        case DDR_80_MHZ:
 				psDDRSetting = asT3LPB_DDRSetting80MHz;
                 RegCount = ARRAY_SIZE(asT3LPB_DDRSetting80MHz);
@@ -1177,8 +1138,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
         }
 		break;
 	case 0xbece0300:
-	    switch (Adapter->DDRSetting)
-	    {
+	    switch (Adapter->DDRSetting) {
 	        case DDR_80_MHZ:
 				psDDRSetting = asT3_DDRSetting80MHz;
                 RegCount = ARRAY_SIZE(asT3_DDRSetting80MHz);
@@ -1203,8 +1163,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	break;
 	case 0xbece0310:
 	    {
-		    switch (Adapter->DDRSetting)
-		    {
+		    switch (Adapter->DDRSetting) {
 		        case DDR_80_MHZ:
 					psDDRSetting = asT3B_DDRSetting80MHz;
                     RegCount = ARRAY_SIZE(asT3B_DDRSetting80MHz);
@@ -1233,8 +1192,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	/* total number of Register that has to be dumped */
 	value = RegCount  ;
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
-	if(retval)
-	{
+	if (retval) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 
 		return retval;
@@ -1243,8 +1201,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	/*signature */
 	value = (0x1d1e0dd0);
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
-	if(retval)
-	{
+	if (retval) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 		return retval;
 	}
@@ -1252,28 +1209,23 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	ul_ddr_setting_load_addr += sizeof(ULONG);
 	RegCount *= (sizeof(struct bcm_ddr_setting)/sizeof(ULONG));
 
-	while(RegCount && !retval)
-	{
+	while (RegCount && !retval) {
 		value = psDDRSetting->ulRegAddress ;
-		retval = wrmalt( Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
+		retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
 		ul_ddr_setting_load_addr += sizeof(ULONG);
-		if(!retval)
-		{
-			if(bOverrideSelfRefresh && (psDDRSetting->ulRegAddress == 0x0F007018))
-			{
+		if (!retval) {
+			if (bOverrideSelfRefresh && (psDDRSetting->ulRegAddress == 0x0F007018)) {
 				value = (psDDRSetting->ulRegValue | (1<<8));
-				if(STATUS_SUCCESS != wrmalt(Adapter, ul_ddr_setting_load_addr,
-						&value, sizeof(value))){
+				if (STATUS_SUCCESS != wrmalt(Adapter, ul_ddr_setting_load_addr,
+						&value, sizeof(value))) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 					break;
 				}
-			}
-			else
-			{
+			} else {
 				value =  psDDRSetting->ulRegValue;
 
-				if(STATUS_SUCCESS != wrmalt(Adapter, ul_ddr_setting_load_addr ,
-							&value, sizeof(value))){
+				if (STATUS_SUCCESS != wrmalt(Adapter, ul_ddr_setting_load_addr ,
+							&value, sizeof(value))) {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 					break;
 				}
-- 
1.8.4

