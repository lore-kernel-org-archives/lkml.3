Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750850Ab3LGFB6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 00:01:58 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:46065 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab3LGFB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 00:01:57 -0500
From: Gary Rookard <garyrookard@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Gary Rookard <garyrookard@gmail.com>
Subject: [PATCH 8/9] Staging: bcm: DDRInit: tidy up indentation.
Date: Sat,  7 Dec 2013 00:01:52 -0500
Message-Id: <1386392512-11932-1-git-send-email-garyrookard@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the eighth patch of a series.

Signed-off-by: Gary Alan Rookard <garyrookard@gmail.com>
---
On branch stanging-next
 drivers/staging/bcm/DDRInit.c | 394 +++++++++++++++++++++---------------------
 1 file changed, 195 insertions(+), 199 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index 57e6023..c808bc5 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -54,7 +54,7 @@ static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {     /* # DPLL Clock Se
 	{0x0F00707C, 0x00000000},
 	{0x0F007080, 0x00000000},
 	{0x0F007084, 0x00000000},
-        {0x0F007094, 0x00000104},       /* # Enable BW improvement within memory controller */
+	{0x0F007094, 0x00000104},       /* # Enable BW improvement within memory controller */
 	{0x0F00A000, 0x00000016},       /* # Enable 2 ports within X-bar */
 	{0x0F007018, 0x01010000}        /* # Enable start bit within memory controller */
 };
@@ -722,31 +722,31 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 	UINT uiClockSetting = 0;
 	int retval = STATUS_SUCCESS;
 
-    switch (Adapter->chip_id) {
+	switch (Adapter->chip_id) {
 	case 0xbece3200:
-	    switch (Adapter->DDRSetting) {
-	        case DDR_80_MHZ:
-				psDDRSetting = asT3LP_DDRSetting80MHz;
-			    RegCount = (sizeof(asT3LP_DDRSetting80MHz)/
-			  	sizeof(struct bcm_ddr_setting));
-			    break;
-		    case DDR_100_MHZ:
-				psDDRSetting = asT3LP_DDRSetting100MHz;
-			    RegCount = (sizeof(asT3LP_DDRSetting100MHz)/
-			  	sizeof(struct bcm_ddr_setting));
-			    break;
-		    case DDR_133_MHZ:
-				psDDRSetting = asT3LP_DDRSetting133MHz;
-			    RegCount = (sizeof(asT3LP_DDRSetting133MHz)/
-		 	  		sizeof(struct bcm_ddr_setting));
+		switch (Adapter->DDRSetting) {
+		case DDR_80_MHZ:
+			psDDRSetting = asT3LP_DDRSetting80MHz;
+			RegCount = (sizeof(asT3LP_DDRSetting80MHz)/
+			sizeof(struct bcm_ddr_setting));
+			break;
+		case DDR_100_MHZ:
+			psDDRSetting = asT3LP_DDRSetting100MHz;
+			RegCount = (sizeof(asT3LP_DDRSetting100MHz)/
+			sizeof(struct bcm_ddr_setting));
+			break;
+		case DDR_133_MHZ:
+			psDDRSetting = asT3LP_DDRSetting133MHz;
+			RegCount = (sizeof(asT3LP_DDRSetting133MHz)/
+			sizeof(struct bcm_ddr_setting));
 				if (Adapter->bMipsConfig == MIPS_200_MHZ)
 					uiClockSetting = 0x03F13652;
 				else
-					uiClockSetting = 0x03F1365B;
+				uiClockSetting = 0x03F1365B;
 				break;
-		    default:
-			    return -EINVAL;
-        }
+		default:
+			return -EINVAL;
+		}
 		break;
 	case T3LPB:
 	case BCS220_2:
@@ -756,10 +756,10 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		/* Set bit 2 and bit 6 to 1 for BBIC 2mA drive
 		 * (please check current value and additionally set these bits)
 		 */
-		if ((Adapter->chip_id !=  BCS220_2) &&
-			(Adapter->chip_id !=  BCS220_2BC) &&
-			(Adapter->chip_id != BCS220_3)) {
-				retval = rdmalt(Adapter, (UINT)0x0f000830, &uiResetValue, sizeof(uiResetValue));
+	if ((Adapter->chip_id !=  BCS220_2) &&
+		(Adapter->chip_id !=  BCS220_2BC) &&
+		(Adapter->chip_id != BCS220_3)) {
+			retval = rdmalt(Adapter, (UINT)0x0f000830, &uiResetValue, sizeof(uiResetValue));
 				if (retval < 0) {
 					BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 					return retval;
@@ -770,96 +770,95 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 					BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 					return retval;
 				}
-		}
+	}
 		switch (Adapter->DDRSetting) {
-			case DDR_80_MHZ:
-				psDDRSetting = asT3LPB_DDRSetting80MHz;
-		        RegCount = (sizeof(asT3B_DDRSetting80MHz)/
-		                  sizeof(struct bcm_ddr_setting));
+		case DDR_80_MHZ:
+			psDDRSetting = asT3LPB_DDRSetting80MHz;
+			RegCount = (sizeof(asT3B_DDRSetting80MHz)/
+			sizeof(struct bcm_ddr_setting));
 			break;
-            case DDR_100_MHZ:
-				psDDRSetting = asT3LPB_DDRSetting100MHz;
-		        RegCount = (sizeof(asT3B_DDRSetting100MHz)/
-		                 sizeof(struct bcm_ddr_setting));
+		case DDR_100_MHZ:
+			psDDRSetting = asT3LPB_DDRSetting100MHz;
+			RegCount = (sizeof(asT3B_DDRSetting100MHz)/
+			sizeof(struct bcm_ddr_setting));
 			break;
-            case DDR_133_MHZ:
-				psDDRSetting = asT3LPB_DDRSetting133MHz;
-				RegCount = (sizeof(asT3B_DDRSetting133MHz)/
-						 sizeof(struct bcm_ddr_setting));
-				if (Adapter->bMipsConfig == MIPS_200_MHZ) 
-					uiClockSetting = 0x03F13652;
-				else
-					uiClockSetting = 0x03F1365B;
+		case DDR_133_MHZ:
+			psDDRSetting = asT3LPB_DDRSetting133MHz;
+			RegCount = (sizeof(asT3B_DDRSetting133MHz)/
+			sizeof(struct bcm_ddr_setting));
+			if (Adapter->bMipsConfig == MIPS_200_MHZ)
+				uiClockSetting = 0x03F13652;
+			else
+				uiClockSetting = 0x03F1365B;
 			break;
-			case DDR_160_MHZ:
-				psDDRSetting = asT3LPB_DDRSetting160MHz;
-				RegCount = sizeof(asT3LPB_DDRSetting160MHz)/sizeof(struct bcm_ddr_setting);
+		case DDR_160_MHZ:
+			psDDRSetting = asT3LPB_DDRSetting160MHz;
+			RegCount = sizeof(asT3LPB_DDRSetting160MHz)/sizeof(struct bcm_ddr_setting);
 				if (Adapter->bMipsConfig == MIPS_200_MHZ)
 					uiClockSetting = 0x03F137D2;
 				else
 					uiClockSetting = 0x03F137DB;
-			}
-			break;
+		}
+		break;
 	case 0xbece0110:
 	case 0xbece0120:
 	case 0xbece0121:
 	case 0xbece0130:
 	case 0xbece0300:
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "DDR Setting: %x\n", Adapter->DDRSetting);
-	    switch (Adapter->DDRSetting) {
-	        case DDR_80_MHZ:
-				psDDRSetting = asT3_DDRSetting80MHz;
-			    RegCount = (sizeof(asT3_DDRSetting80MHz)/
-			  	sizeof(struct bcm_ddr_setting));
-			    break;
-		    case DDR_100_MHZ:
-				psDDRSetting = asT3_DDRSetting100MHz;
-			    RegCount = (sizeof(asT3_DDRSetting100MHz)/
-			  	sizeof(struct bcm_ddr_setting));
-			    break;
-		    case DDR_133_MHZ:
-				psDDRSetting = asT3_DDRSetting133MHz;
-			    RegCount = (sizeof(asT3_DDRSetting133MHz)/
-		 	  	sizeof(struct bcm_ddr_setting));
-				break;
-		    default:
-			    return -EINVAL;
-        }
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "DDR Setting: %x\n", Adapter->DDRSetting);
+		switch (Adapter->DDRSetting) {
+		case DDR_80_MHZ:
+			psDDRSetting = asT3_DDRSetting80MHz;
+			RegCount = (sizeof(asT3_DDRSetting80MHz)/
+			sizeof(struct bcm_ddr_setting));
+			break;
+		case DDR_100_MHZ:
+			psDDRSetting = asT3_DDRSetting100MHz;
+			RegCount = (sizeof(asT3_DDRSetting100MHz)/
+			sizeof(struct bcm_ddr_setting));
+			break;
+		case DDR_133_MHZ:
+			psDDRSetting = asT3_DDRSetting133MHz;
+			RegCount = (sizeof(asT3_DDRSetting133MHz)/
+			sizeof(struct bcm_ddr_setting));
+			break;
+		default:
+			return -EINVAL;
+		}
 	case 0xbece0310:
-	{
-	    switch (Adapter->DDRSetting) {
-	        case DDR_80_MHZ:
-				psDDRSetting = asT3B_DDRSetting80MHz;
-		        RegCount = (sizeof(asT3B_DDRSetting80MHz)/
-		                  sizeof(struct bcm_ddr_setting));
-		    break;
-            case DDR_100_MHZ:
-				psDDRSetting = asT3B_DDRSetting100MHz;
-		        RegCount = (sizeof(asT3B_DDRSetting100MHz)/
-		                 sizeof(struct bcm_ddr_setting));
+
+		switch (Adapter->DDRSetting) {
+		case DDR_80_MHZ:
+			psDDRSetting = asT3B_DDRSetting80MHz;
+			RegCount = (sizeof(asT3B_DDRSetting80MHz)/
+			sizeof(struct bcm_ddr_setting));
+			break;
+		case DDR_100_MHZ:
+			psDDRSetting = asT3B_DDRSetting100MHz;
+			RegCount = (sizeof(asT3B_DDRSetting100MHz)/
+		sizeof(struct bcm_ddr_setting));
 			break;
-            case DDR_133_MHZ:
-				if (Adapter->bDPLLConfig == PLL_266_MHZ) { /*266Mhz PLL selected. */
-					memcpy(asT3B_DDRSetting133MHz, asDPLL_266MHZ,
-									 sizeof(asDPLL_266MHZ));
-					psDDRSetting = asT3B_DDRSetting133MHz;
-					RegCount = (sizeof(asT3B_DDRSetting133MHz)/
-									sizeof(struct bcm_ddr_setting));
-				} else {
-					psDDRSetting = asT3B_DDRSetting133MHz;
-					RegCount = (sizeof(asT3B_DDRSetting133MHz)/
-									sizeof(struct bcm_ddr_setting));
+		case DDR_133_MHZ:
+			if (Adapter->bDPLLConfig == PLL_266_MHZ) { /*266Mhz PLL selected. */
+				memcpy(asT3B_DDRSetting133MHz, asDPLL_266MHZ,
+				sizeof(asDPLL_266MHZ));
+				psDDRSetting = asT3B_DDRSetting133MHz;
+				RegCount = (sizeof(asT3B_DDRSetting133MHz)/
+				sizeof(struct bcm_ddr_setting));
+			} else {
+				psDDRSetting = asT3B_DDRSetting133MHz;
+				RegCount = (sizeof(asT3B_DDRSetting133MHz)/
+				sizeof(struct bcm_ddr_setting));
 					if (Adapter->bMipsConfig == MIPS_200_MHZ)
 						uiClockSetting = 0x07F13652;
-					 else
+					else
 						uiClockSetting = 0x07F1365B;
 				}
-				break;
-		    default:
-			    return -EINVAL;
+			break;
+		default:
+			return -EINVAL;
 		}
 		break;
-	}
 	default:
 		return -EINVAL;
 	}
@@ -1002,121 +1001,118 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 
 	switch (Adapter->chip_id) {
 	case 0xbece3200:
-	    switch (Adapter->DDRSetting) {
-	        case DDR_80_MHZ:
-				psDDRSetting = asT3LP_DDRSetting80MHz;
-                RegCount = ARRAY_SIZE(asT3LP_DDRSetting80MHz);
-				RegCount -= T3LP_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
-                psDDRSetting += T3LP_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
+		switch (Adapter->DDRSetting) {
+		case DDR_80_MHZ:
+			psDDRSetting = asT3LP_DDRSetting80MHz;
+			RegCount = ARRAY_SIZE(asT3LP_DDRSetting80MHz);
+			RegCount -= T3LP_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
+			psDDRSetting += T3LP_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
 			break;
-		    case DDR_100_MHZ:
-				psDDRSetting = asT3LP_DDRSetting100MHz;
-			    RegCount = ARRAY_SIZE(asT3LP_DDRSetting100MHz);
-				RegCount -= T3LP_SKIP_CLOCK_PROGRAM_DUMP_100MHZ ;
-                psDDRSetting += T3LP_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
-			    break;
-		     case DDR_133_MHZ:
-				bOverrideSelfRefresh = TRUE;
-				psDDRSetting = asT3LP_DDRSetting133MHz;
-			    RegCount = ARRAY_SIZE(asT3LP_DDRSetting133MHz);
-				RegCount -= T3LP_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
-		        psDDRSetting += T3LP_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
-				break;
-			default:
-			    return -EINVAL;
-        }
+		case DDR_100_MHZ:
+			psDDRSetting = asT3LP_DDRSetting100MHz;
+			RegCount = ARRAY_SIZE(asT3LP_DDRSetting100MHz);
+			RegCount -= T3LP_SKIP_CLOCK_PROGRAM_DUMP_100MHZ ;
+			psDDRSetting += T3LP_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
+			break;
+		case DDR_133_MHZ:
+			bOverrideSelfRefresh = TRUE;
+			psDDRSetting = asT3LP_DDRSetting133MHz;
+			RegCount = ARRAY_SIZE(asT3LP_DDRSetting133MHz);
+			RegCount -= T3LP_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
+			psDDRSetting += T3LP_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
+			break;
+		default:
+			return -EINVAL;
+		}
 		break;
 	case T3LPB:
 	case BCS220_2:
 	case BCS220_2BC:
 	case BCS250_BC:
 	case BCS220_3:
-	    switch (Adapter->DDRSetting) {
-	        case DDR_80_MHZ:
-				psDDRSetting = asT3LPB_DDRSetting80MHz;
-                RegCount = ARRAY_SIZE(asT3LPB_DDRSetting80MHz);
-				RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
-                psDDRSetting += T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
+		switch (Adapter->DDRSetting) {
+		case DDR_80_MHZ:
+			psDDRSetting = asT3LPB_DDRSetting80MHz;
+			RegCount = ARRAY_SIZE(asT3LPB_DDRSetting80MHz);
+			RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
+			psDDRSetting += T3LPB_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
 			break;
-		    case DDR_100_MHZ:
-				psDDRSetting = asT3LPB_DDRSetting100MHz;
-			    RegCount = ARRAY_SIZE(asT3LPB_DDRSetting100MHz);
-				RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_100MHZ ;
-                psDDRSetting += T3LPB_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
-			    break;
-		     case DDR_133_MHZ:
-				bOverrideSelfRefresh = TRUE;
-				psDDRSetting = asT3LPB_DDRSetting133MHz;
-			    RegCount = ARRAY_SIZE(asT3LPB_DDRSetting133MHz);
-				RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
-		        psDDRSetting += T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
-				break;
-			case DDR_160_MHZ:
-					bOverrideSelfRefresh = TRUE;
-					psDDRSetting = asT3LPB_DDRSetting160MHz;
-					RegCount = ARRAY_SIZE(asT3LPB_DDRSetting160MHz);
-					RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_160MHZ;
-					psDDRSetting += T3LPB_SKIP_CLOCK_PROGRAM_DUMP_160MHZ;
-
-					break;
-			default:
-			    return -EINVAL;
-        }
+		case DDR_100_MHZ:
+			psDDRSetting = asT3LPB_DDRSetting100MHz;
+			RegCount = ARRAY_SIZE(asT3LPB_DDRSetting100MHz);
+			RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_100MHZ ;
+			psDDRSetting += T3LPB_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
+			break;
+		case DDR_133_MHZ:
+			bOverrideSelfRefresh = TRUE;
+			psDDRSetting = asT3LPB_DDRSetting133MHz;
+			RegCount = ARRAY_SIZE(asT3LPB_DDRSetting133MHz);
+			RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
+			psDDRSetting += T3LPB_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
+			break;
+		case DDR_160_MHZ:
+			bOverrideSelfRefresh = TRUE;
+			psDDRSetting = asT3LPB_DDRSetting160MHz;
+			RegCount = ARRAY_SIZE(asT3LPB_DDRSetting160MHz);
+			RegCount -= T3LPB_SKIP_CLOCK_PROGRAM_DUMP_160MHZ;
+			psDDRSetting += T3LPB_SKIP_CLOCK_PROGRAM_DUMP_160MHZ;
+			break;
+		default:
+			return -EINVAL;
+		}
 		break;
 	case 0xbece0300:
-	    switch (Adapter->DDRSetting) {
-	        case DDR_80_MHZ:
-				psDDRSetting = asT3_DDRSetting80MHz;
-                RegCount = ARRAY_SIZE(asT3_DDRSetting80MHz);
-				RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
-                psDDRSetting += T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
+		switch (Adapter->DDRSetting) {
+		case DDR_80_MHZ:
+			psDDRSetting = asT3_DDRSetting80MHz;
+			RegCount = ARRAY_SIZE(asT3_DDRSetting80MHz);
+			RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
+			psDDRSetting += T3_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
 			break;
-		    case DDR_100_MHZ:
-				psDDRSetting = asT3_DDRSetting100MHz;
-			    RegCount = ARRAY_SIZE(asT3_DDRSetting100MHz);
-				RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ ;
-                psDDRSetting += T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
-			    break;
-		     case DDR_133_MHZ:
-				psDDRSetting = asT3_DDRSetting133MHz;
-			    RegCount = ARRAY_SIZE(asT3_DDRSetting133MHz);
-				RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
-		        psDDRSetting += T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
-				break;
-			default:
-			    return -EINVAL;
-        }
-	break;
+		case DDR_100_MHZ:
+			psDDRSetting = asT3_DDRSetting100MHz;
+			RegCount = ARRAY_SIZE(asT3_DDRSetting100MHz);
+			RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ ;
+			psDDRSetting += T3_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
+			break;
+		case DDR_133_MHZ:
+			psDDRSetting = asT3_DDRSetting133MHz;
+			RegCount = ARRAY_SIZE(asT3_DDRSetting133MHz);
+			RegCount -= T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
+			psDDRSetting += T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
 	case 0xbece0310:
-	    {
-		    switch (Adapter->DDRSetting) {
-		        case DDR_80_MHZ:
-					psDDRSetting = asT3B_DDRSetting80MHz;
-                    RegCount = ARRAY_SIZE(asT3B_DDRSetting80MHz);
-                    RegCount -= T3B_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
-                    psDDRSetting += T3B_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
-			        break;
-		        case DDR_100_MHZ:
-					psDDRSetting = asT3B_DDRSetting100MHz;
-			        RegCount = ARRAY_SIZE(asT3B_DDRSetting100MHz);
-                    RegCount -= T3B_SKIP_CLOCK_PROGRAM_DUMP_100MHZ ;
-                    psDDRSetting += T3B_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
-			        break;
-		        case DDR_133_MHZ:
-					bOverrideSelfRefresh = TRUE;
-					psDDRSetting = asT3B_DDRSetting133MHz;
-			        RegCount = ARRAY_SIZE(asT3B_DDRSetting133MHz);
-	                RegCount -= T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
-		            psDDRSetting += T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
-					break;
-		      }
-		      break;
-	     }
+		switch (Adapter->DDRSetting) {
+		case DDR_80_MHZ:
+			psDDRSetting = asT3B_DDRSetting80MHz;
+			RegCount = ARRAY_SIZE(asT3B_DDRSetting80MHz);
+			RegCount -= T3B_SKIP_CLOCK_PROGRAM_DUMP_80MHZ ;
+			psDDRSetting += T3B_SKIP_CLOCK_PROGRAM_DUMP_80MHZ;
+			break;
+		case DDR_100_MHZ:
+			psDDRSetting = asT3B_DDRSetting100MHz;
+			RegCount = ARRAY_SIZE(asT3B_DDRSetting100MHz);
+			RegCount -= T3B_SKIP_CLOCK_PROGRAM_DUMP_100MHZ ;
+			psDDRSetting += T3B_SKIP_CLOCK_PROGRAM_DUMP_100MHZ;
+			break;
+		case DDR_133_MHZ:
+			bOverrideSelfRefresh = TRUE;
+			psDDRSetting = asT3B_DDRSetting133MHz;
+			RegCount = ARRAY_SIZE(asT3B_DDRSetting133MHz);
+			RegCount -= T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ ;
+			psDDRSetting += T3B_SKIP_CLOCK_PROGRAM_DUMP_133MHZ;
+			break;
+		}
+		break;
 	default:
 		return -EINVAL;
 	}
 	/* total number of Register that has to be dumped */
-	value = RegCount  ;
+	value = RegCount;
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
 	if (retval) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
@@ -1141,16 +1137,16 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 			if (bOverrideSelfRefresh && (psDDRSetting->ulRegAddress == 0x0F007018)) {
 				value = (psDDRSetting->ulRegValue | (1<<8));
 				if (STATUS_SUCCESS != wrmalt(Adapter, ul_ddr_setting_load_addr,
-						&value, sizeof(value))) {
-					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
-					break;
+					&value, sizeof(value))) {
+						BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
+						break;
 				}
 			} else {
 				value =  psDDRSetting->ulRegValue;
 				if (STATUS_SUCCESS != wrmalt(Adapter, ul_ddr_setting_load_addr ,
-							&value, sizeof(value))) {
-					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
-					break;
+					&value, sizeof(value))) {
+						BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
+						break;
 				}
 			}
 		}
-- 
1.8.4

