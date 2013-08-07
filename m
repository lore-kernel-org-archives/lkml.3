Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab3HGTkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:40:47 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:60258 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab3HGTkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:40:45 -0400
Message-ID: <5202A2B9.6070207@gmail.com>
Date: Wed, 07 Aug 2013 20:40:41 +0100
From: Paul McQuade <paulmcquad@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, Linux-Devel <devel@driverdev.osuosl.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging:BCM:DDRInit.c:Replacing __FUNCTION__
Content-Type: multipart/mixed;
 boundary="------------010404060706030008020609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010404060706030008020609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------010404060706030008020609
Content-Type: text/x-patch;
 name="0001-Subject-PATCH-Staging-BCM-DDRInit.c-Replacing-__FUNC.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Subject-PATCH-Staging-BCM-DDRInit.c-Replacing-__FUNC.pa";
 filename*1="tch"

>From 31cc3c00d2699a846a8bb54d0831ab6480c8bd12 Mon Sep 17 00:00:00 2001
From: Paul McQuade <paulmcquad@gmail.com>
Date: Wed, 7 Aug 2013 20:29:13 +0100
Subject: [PATCH] Subject: [PATCH] Staging:BCM:DDRInit.c:Replacing
 __FUNCTION__

__func__ replaces __Function__.

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 drivers/staging/bcm/DDRInit.c |   75 ++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
index 8c696b6..d9ec455 100644
--- a/drivers/staging/bcm/DDRInit.c
+++ b/drivers/staging/bcm/DDRInit.c
@@ -801,13 +801,9 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			    RegCount=(sizeof(asT3LP_DDRSetting133MHz)/
 		 	  		sizeof(struct bcm_ddr_setting));
 				if(Adapter->bMipsConfig == MIPS_200_MHZ)
-				{
 					uiClockSetting = 0x03F13652;
-				}
 				else
-				{
 					uiClockSetting = 0x03F1365B;
-				}
 				break;
 		    default:
 			    return -EINVAL;
@@ -828,44 +824,37 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		{
 				retval= rdmalt(Adapter,(UINT)0x0f000830, &uiResetValue, sizeof(uiResetValue));
 				if(retval < 0) {
-					BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+					BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 					return retval;
 				}
 				uiResetValue |= 0x44;
 				retval = wrmalt(Adapter,(UINT)0x0f000830, &uiResetValue, sizeof(uiResetValue));
 				if(retval < 0) {
-					BCM_DEBUG_PRINT(Adapter,CMHOST, WRM, DBG_LVL_ALL, "%s:%d WRM failed\n", __FUNCTION__, __LINE__);
+					BCM_DEBUG_PRINT(Adapter, CMHOST, WRM, DBG_LVL_ALL, "%s:%d WRM failed\n", __func__, __LINE__);
 					return retval;
 				}
 		}
 		switch(Adapter->DDRSetting)
 		{
-
-
-
-			case DDR_80_MHZ:
+	case DDR_80_MHZ:
 				psDDRSetting = asT3LPB_DDRSetting80MHz;
 		        RegCount=(sizeof(asT3B_DDRSetting80MHz)/
 		                  sizeof(struct bcm_ddr_setting));
 			break;
-            case DDR_100_MHZ:
+	case DDR_100_MHZ:
 				psDDRSetting=asT3LPB_DDRSetting100MHz;
 		        RegCount=(sizeof(asT3B_DDRSetting100MHz)/
 		                 sizeof(struct bcm_ddr_setting));
 			break;
-            case DDR_133_MHZ:
+	case DDR_133_MHZ:
 				psDDRSetting = asT3LPB_DDRSetting133MHz;
 				RegCount=(sizeof(asT3B_DDRSetting133MHz)/
 						 sizeof(struct bcm_ddr_setting));
 
 				if(Adapter->bMipsConfig == MIPS_200_MHZ)
-				{
 					uiClockSetting = 0x03F13652;
-				}
 				else
-				{
 					uiClockSetting = 0x03F1365B;
-				}
 			break;
 
 			case DDR_160_MHZ:
@@ -873,13 +862,9 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 				RegCount = sizeof(asT3LPB_DDRSetting160MHz)/sizeof(struct bcm_ddr_setting);
 
 				if(Adapter->bMipsConfig == MIPS_200_MHZ)
-				{
 					uiClockSetting = 0x03F137D2;
-				}
 				else
-				{
 					uiClockSetting = 0x03F137DB;
-				}
 			}
 			break;
 
@@ -888,7 +873,7 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 	case 0xbece0121:
 	case 0xbece0130:
 	case 0xbece0300:
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "DDR Setting: %x\n", Adapter->DDRSetting);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "DDR Setting: %x\n", Adapter->DDRSetting);
 	    switch (Adapter->DDRSetting)
 	    {
 	        case DDR_80_MHZ:
@@ -963,16 +948,14 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 	while(RegCount && !retval)
 	{
 		if(uiClockSetting && psDDRSetting->ulRegAddress == MIPS_CLOCK_REG)
-		{
 			value = uiClockSetting;
-		}
-		else
-		{
+		else {
 			value = psDDRSetting->ulRegValue;
-		}
+
 		retval = wrmalt(Adapter, psDDRSetting->ulRegAddress, &value, sizeof(value));
+}
 		if(STATUS_SUCCESS != retval) {
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"%s:%d\n", __FUNCTION__, __LINE__);
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 			break;
 		}
 
@@ -992,25 +975,25 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			uiResetValue = 0x01010001;
 			retval = wrmalt(Adapter, (UINT)0x0F007018, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x00040020;
 			retval = wrmalt(Adapter, (UINT)0x0F007094, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x01020101;
 			retval = wrmalt(Adapter, (UINT)0x0F00701c, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x01010000;
 			retval = wrmalt(Adapter, (UINT)0x0F007018, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 		}
@@ -1026,12 +1009,12 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 		{
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x1322a8;
@@ -1042,18 +1025,18 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x132296;
 			retval = wrmalt(Adapter, (UINT)0x0f000d14, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 		}
@@ -1062,34 +1045,34 @@ int ddr_init(struct bcm_mini_adapter *Adapter)
 
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x6003229a;
 			retval = wrmalt(Adapter, (UINT)0x0f000d14, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			retval = rdmalt(Adapter,(UINT)0x0f000c00, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 			uiResetValue = 0x1322a8;
 			retval = wrmalt(Adapter, (UINT)0x0f000d1c, &uiResetValue, sizeof(uiResetValue));
 			if(retval < 0) {
-				BCM_DEBUG_PRINT(Adapter,CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __FUNCTION__, __LINE__);
+				BCM_DEBUG_PRINT(Adapter, CMHOST, RDM, DBG_LVL_ALL, "%s:%d RDM failed\n", __func__, __LINE__);
 				return retval;
 			}
 		}
@@ -1235,7 +1218,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
 	if(retval)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"%s:%d\n", __FUNCTION__, __LINE__);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 
 		return retval;
 	}
@@ -1245,7 +1228,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 	retval = wrmalt(Adapter, ul_ddr_setting_load_addr, &value, sizeof(value));
 	if(retval)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"%s:%d\n", __FUNCTION__, __LINE__);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 		return retval;
 	}
 
@@ -1264,7 +1247,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 				value = (psDDRSetting->ulRegValue |(1<<8));
 				if(STATUS_SUCCESS != wrmalt(Adapter, ul_ddr_setting_load_addr,
 						&value, sizeof(value))){
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"%s:%d\n", __FUNCTION__, __LINE__);
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 					break;
 				}
 			}
@@ -1274,7 +1257,7 @@ int download_ddr_settings(struct bcm_mini_adapter *Adapter)
 
 				if(STATUS_SUCCESS != wrmalt(Adapter, ul_ddr_setting_load_addr ,
 							&value, sizeof(value))){
-					BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"%s:%d\n", __FUNCTION__, __LINE__);
+					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "%s:%d\n", __func__, __LINE__);
 					break;
 				}
 			}
-- 
1.7.10.4


--------------010404060706030008020609--
