Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbaFTPBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:01:50 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:46681 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaFTPBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:01:48 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/41] staging: rtl8188eu: Rename rtl8188e_EFUSE_GetEfuseDefinition()
Date: Fri, 20 Jun 2014 20:29:18 +0530
Message-Id: <1403276387-11841-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
References: <1403276387-11841-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename rtl8188e_EFUSE_GetEfuseDefinition() to EFUSE_GetEfuseDefinition()
and remove original EFUSE_GetEfuseDefinition() function,
so that driver can call rtl8188e_EFUSE_GetEfuseDefinition() directly
without going through EFUSE_GetEfuseDefinition().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_efuse.c        |   26 ++++++++-------------
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c     |    6 ++---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c |   13 +++++------
 drivers/staging/rtl8188eu/include/hal_intf.h      |    2 --
 drivers/staging/rtl8188eu/include/rtw_efuse.h     |    2 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |   22 ++++++++---------
 6 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index bae0fca..4c6ed3b 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -220,12 +220,6 @@ static void efuse_ReadEFuse(struct adapter *Adapter, u8 efuseType, u16 _offset,
 	Adapter->HalFunc.ReadEFuse(Adapter, efuseType, _offset, _size_byte, pbuf, pseudo);
 }
 
-void EFUSE_GetEfuseDefinition(struct adapter *pAdapter, u8 efuseType, u8 type, void *pOut, bool pseudo
-	)
-{
-	pAdapter->HalFunc.EFUSEGetEfuseDefinition(pAdapter, efuseType, type, pOut);
-}
-
 /*-----------------------------------------------------------------------------
  * Function:	EFUSE_Read1Byte
  *
@@ -250,7 +244,7 @@ u8 EFUSE_Read1Byte(struct adapter *Adapter, u16 Address)
 	u32 k = 0;
 	u16 contentLen = 0;
 
-	EFUSE_GetEfuseDefinition(Adapter, EFUSE_WIFI , TYPE_EFUSE_REAL_CONTENT_LEN, (void *)&contentLen, false);
+	EFUSE_GetEfuseDefinition(Adapter, EFUSE_WIFI , TYPE_EFUSE_REAL_CONTENT_LEN, (void *)&contentLen);
 
 	if (Address < contentLen) {	/* E-fuse 512Byte */
 		/* Write E-fuse Register address bit0~7 */
@@ -440,8 +434,8 @@ u8 rtw_efuse_access(struct adapter *padapter, u8 write, u16 start_addr, u16 cnts
 	u8 res = _FAIL;
 	u8 (*rw8)(struct adapter *, u16, u8*);
 
-	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_EFUSE_REAL_CONTENT_LEN, (void *)&real_content_len, false);
-	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size, false);
+	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_EFUSE_REAL_CONTENT_LEN, (void *)&real_content_len);
+	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
 
 	if (start_addr > real_content_len)
 		return _FAIL;
@@ -476,7 +470,7 @@ u8 rtw_efuse_access(struct adapter *padapter, u8 write, u16 start_addr, u16 cnts
 u16 efuse_GetMaxSize(struct adapter *padapter)
 {
 	u16 max_size;
-	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI , TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_size, false);
+	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI , TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_size);
 	return max_size;
 }
 /*  */
@@ -493,7 +487,7 @@ u8 rtw_efuse_map_read(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 {
 	u16 mapLen = 0;
 
-	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&mapLen, false);
+	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&mapLen);
 
 	if ((addr + cnts) > mapLen)
 		return _FAIL;
@@ -511,7 +505,7 @@ u8 rtw_BT_efuse_map_read(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 {
 	u16 mapLen = 0;
 
-	EFUSE_GetEfuseDefinition(padapter, EFUSE_BT, TYPE_EFUSE_MAP_LEN, (void *)&mapLen, false);
+	EFUSE_GetEfuseDefinition(padapter, EFUSE_BT, TYPE_EFUSE_MAP_LEN, (void *)&mapLen);
 
 	if ((addr + cnts) > mapLen)
 		return _FAIL;
@@ -534,7 +528,7 @@ u8 rtw_efuse_map_write(struct adapter *padapter, u16 addr, u16 cnts, u8 *data)
 	u8 ret = _SUCCESS;
 	u16 mapLen = 0;
 
-	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&mapLen, false);
+	EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&mapLen);
 
 	if ((addr + cnts) > mapLen)
 		return _FAIL;
@@ -626,7 +620,7 @@ u8 rtw_BT_efuse_map_write(struct adapter *padapter, u16 addr, u16 cnts, u8 *data
 	u8 ret = _SUCCESS;
 	u16 mapLen = 0;
 
-	EFUSE_GetEfuseDefinition(padapter, EFUSE_BT, TYPE_EFUSE_MAP_LEN, (void *)&mapLen, false);
+	EFUSE_GetEfuseDefinition(padapter, EFUSE_BT, TYPE_EFUSE_MAP_LEN, (void *)&mapLen);
 
 	if ((addr + cnts) > mapLen)
 		return _FAIL;
@@ -795,7 +789,7 @@ static void Efuse_ReadAllMap(struct adapter *pAdapter, u8 efuseType, u8 *Efuse,
 
 	Efuse_PowerSwitch(pAdapter, false, true);
 
-	EFUSE_GetEfuseDefinition(pAdapter, efuseType, TYPE_EFUSE_MAP_LEN, (void *)&mapLen, pseudo);
+	EFUSE_GetEfuseDefinition(pAdapter, efuseType, TYPE_EFUSE_MAP_LEN, (void *)&mapLen);
 
 	efuse_ReadEFuse(pAdapter, efuseType, 0, mapLen, Efuse, pseudo);
 
@@ -826,7 +820,7 @@ void EFUSE_ShadowMapUpdate(
 	struct eeprom_priv *pEEPROM = GET_EEPROM_EFUSE_PRIV(pAdapter);
 	u16 mapLen = 0;
 
-	EFUSE_GetEfuseDefinition(pAdapter, efuseType, TYPE_EFUSE_MAP_LEN, (void *)&mapLen, pseudo);
+	EFUSE_GetEfuseDefinition(pAdapter, efuseType, TYPE_EFUSE_MAP_LEN, (void *)&mapLen);
 
 	if (pEEPROM->bautoload_fail_flag)
 		_rtw_memset(pEEPROM->efuse_eeprom_data, 0xFF, mapLen);
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
index ad55994..e62cca8 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
@@ -1099,7 +1099,7 @@ int rtl8188eu_oid_rt_pro_read_efuse_hdl(struct oid_par_priv *poid_par_priv)
 		 ("+rtl8188eu_oid_rt_pro_read_efuse_hd: buf_len=%d addr=%d cnts=%d\n",
 		  poid_par_priv->information_buf_len, addr, cnts));
 
-	EFUSE_GetEfuseDefinition(Adapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size, false);
+	EFUSE_GetEfuseDefinition(Adapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
 
 	if ((addr + cnts) > max_available_size) {
 		RT_TRACE(_module_mp_, _drv_err_, ("!rtl8188eu_oid_rt_pro_read_efuse_hdl: parameter error!\n"));
@@ -1141,7 +1141,7 @@ int rtl8188eu_oid_rt_pro_write_efuse_hdl(struct oid_par_priv *poid_par_priv)
 		 ("+rtl8188eu_oid_rt_pro_write_efuse_hdl: buf_len=%d addr=0x%04x cnts=%d\n",
 		  poid_par_priv->information_buf_len, addr, cnts));
 
-	EFUSE_GetEfuseDefinition(Adapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size, false);
+	EFUSE_GetEfuseDefinition(Adapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
 
 	if ((addr + cnts) > max_available_size) {
 		RT_TRACE(_module_mp_, _drv_err_, ("!rtl8188eu_oid_rt_pro_write_efuse_hdl: parameter error"));
@@ -1284,7 +1284,7 @@ int rtl8188eu_oid_rt_pro_efuse_map_hdl(struct oid_par_priv *poid_par_priv)
 
 	RT_TRACE(_module_mp_, _drv_notice_, ("+rtl8188eu_oid_rt_pro_efuse_map_hdl\n"));
 
-	EFUSE_GetEfuseDefinition(Adapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&maplen, false);
+	EFUSE_GetEfuseDefinition(Adapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&maplen);
 
 	*poid_par_priv->bytes_rw = 0;
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index b3bc125..80cb54d 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -957,7 +957,7 @@ exit:
 }
 
 /* Do not support BT */
-static void rtl8188e_EFUSE_GetEfuseDefinition(struct adapter *pAdapter, u8 efuseType, u8 type, void *pOut)
+void EFUSE_GetEfuseDefinition(struct adapter *pAdapter, u8 efuseType, u8 type, void *pOut)
 {
 	switch (type) {
 	case TYPE_EFUSE_MAX_SECTION:
@@ -1131,7 +1131,7 @@ static int hal_EfusePgPacketRead_8188e(struct adapter *pAdapter, u8 offset, u8 *
 	u8 max_section = 0;
 	u8 tmp_header = 0;
 
-	EFUSE_GetEfuseDefinition(pAdapter, EFUSE_WIFI, TYPE_EFUSE_MAX_SECTION, (void *)&max_section, bPseudoTest);
+	EFUSE_GetEfuseDefinition(pAdapter, EFUSE_WIFI, TYPE_EFUSE_MAX_SECTION, (void *)&max_section);
 
 	if (data == NULL)
 		return false;
@@ -1240,7 +1240,7 @@ static bool hal_EfusePgPacketWrite2ByteHeader(struct adapter *pAdapter, u8 efuse
 	u8 pg_header = 0, tmp_header = 0, pg_header_temp = 0;
 	u8 repeatcnt = 0;
 
-	EFUSE_GetEfuseDefinition(pAdapter, efuseType, TYPE_AVAILABLE_EFUSE_BYTES_BANK, (void *)&efuse_max_available_len, bPseudoTest);
+	EFUSE_GetEfuseDefinition(pAdapter, efuseType, TYPE_AVAILABLE_EFUSE_BYTES_BANK, (void *)&efuse_max_available_len);
 
 	while (efuse_addr < efuse_max_available_len) {
 		pg_header = ((pTargetPkt->offset & 0x07) << 5) | 0x0F;
@@ -1420,8 +1420,8 @@ static bool hal_EfusePartialWriteCheck(struct adapter *pAdapter, u8 efuseType, u
 	u16	startAddr = 0, efuse_max_available_len = 0, efuse_max = 0;
 	struct pgpkt curPkt;
 
-	EFUSE_GetEfuseDefinition(pAdapter, efuseType, TYPE_AVAILABLE_EFUSE_BYTES_BANK, (void *)&efuse_max_available_len, bPseudoTest);
-	EFUSE_GetEfuseDefinition(pAdapter, efuseType, TYPE_EFUSE_REAL_CONTENT_LEN, (void *)&efuse_max, bPseudoTest);
+	EFUSE_GetEfuseDefinition(pAdapter, efuseType, TYPE_AVAILABLE_EFUSE_BYTES_BANK, (void *)&efuse_max_available_len);
+	EFUSE_GetEfuseDefinition(pAdapter, efuseType, TYPE_EFUSE_REAL_CONTENT_LEN, (void *)&efuse_max);
 
 	if (efuseType == EFUSE_WIFI) {
 		if (bPseudoTest) {
@@ -1509,7 +1509,7 @@ hal_EfusePgCheckAvailableAddr(
 	u16	efuse_max_available_len = 0;
 
 	/* Change to check TYPE_EFUSE_MAP_LEN , because 8188E raw 256, logic map over 256. */
-	EFUSE_GetEfuseDefinition(pAdapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&efuse_max_available_len, false);
+	EFUSE_GetEfuseDefinition(pAdapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&efuse_max_available_len);
 
 	if (Efuse_GetCurrentSize(pAdapter, bPseudoTest) >= efuse_max_available_len)
 		return false;
@@ -1673,7 +1673,6 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	/*  Efuse related function */
 	pHalFunc->EfusePowerSwitch = &rtl8188e_EfusePowerSwitch;
 	pHalFunc->ReadEFuse = &ReadEFuseByIC;
-	pHalFunc->EFUSEGetEfuseDefinition = &rtl8188e_EFUSE_GetEfuseDefinition;
 	pHalFunc->EfuseGetCurrentSize = &hal_EfuseGetCurrentSize_8188e;
 	pHalFunc->Efuse_PgPacketRead = &hal_EfusePgPacketRead_8188e;
 	pHalFunc->Efuse_PgPacketWrite = &hal_EfusePgPacketWrite_8188e;
diff --git a/drivers/staging/rtl8188eu/include/hal_intf.h b/drivers/staging/rtl8188eu/include/hal_intf.h
index f4f6443..d9b0e71 100644
--- a/drivers/staging/rtl8188eu/include/hal_intf.h
+++ b/drivers/staging/rtl8188eu/include/hal_intf.h
@@ -237,8 +237,6 @@ struct hal_ops {
 				 u8 PwrState);
 	void (*ReadEFuse)(struct adapter *padapter, u8 efuseType, u16 _offset,
 			  u16 _size_byte, u8 *pbuf, bool bPseudoTest);
-	void (*EFUSEGetEfuseDefinition)(struct adapter *padapter, u8 efuseType,
-					u8 type, void *pOut);
 	u16	(*EfuseGetCurrentSize)(struct adapter *padapter,
 				       bool bPseudoTest);
 	int	(*Efuse_PgPacketRead)(struct adapter *adapter, u8 offset,
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index cc19e19..7d1f28f 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -131,7 +131,7 @@ u16 Efuse_GetCurrentSize(struct adapter *adapter, bool test);
 u8 Efuse_CalculateWordCnts(u8 word_en);
 void ReadEFuseByte(struct adapter *adapter, u16 _offset, u8 *pbuf, bool test);
 void EFUSE_GetEfuseDefinition(struct adapter *adapt, u8 type, u8 type1,
-			      void *out, bool bPseudoTest);
+			      void *out);
 u8 efuse_OneByteRead(struct adapter *adapter, u16 addr, u8 *data, bool test);
 u8 efuse_OneByteWrite(struct adapter *adapter, u16 addr, u8 data, bool	test);
 
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 11b71ec..c43322d 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -5800,7 +5800,7 @@ static int rtw_mp_efuse_get(struct net_device *dev,
 		}
 		DBG_88E("%s: cnts =%d\n", __func__, cnts);
 
-		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size, false);
+		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
 		if ((addr + cnts) > max_available_size) {
 			DBG_88E("%s: addr(0x%X)+cnts(%d) parameter error!\n", __func__, addr, cnts);
 			err = -EINVAL;
@@ -5839,7 +5839,7 @@ static int rtw_mp_efuse_get(struct net_device *dev,
 	} else if (strcmp(tmp[0], "mac") == 0) {
 		cnts = 6;
 
-		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size, false);
+		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
 		if ((addr + cnts) > max_available_size) {
 			DBG_88E("%s: addr(0x%02x)+cnts(%d) parameter error!\n", __func__, addr, cnts);
 			err = -EFAULT;
@@ -5861,7 +5861,7 @@ static int rtw_mp_efuse_get(struct net_device *dev,
 	} else if (strcmp(tmp[0], "vidpid") == 0) {
 		cnts = 4;
 
-		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size, false);
+		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
 		if ((addr + cnts) > max_available_size) {
 			DBG_88E("%s: addr(0x%02x)+cnts(%d) parameter error!\n", __func__, addr, cnts);
 			err = -EFAULT;
@@ -5938,7 +5938,7 @@ static int rtw_mp_efuse_get(struct net_device *dev,
 		}
 		DBG_88E("%s: cnts =%d\n", __func__, cnts);
 
-		EFUSE_GetEfuseDefinition(padapter, EFUSE_BT, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size, false);
+		EFUSE_GetEfuseDefinition(padapter, EFUSE_BT, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
 		if ((addr + cnts) > max_available_size) {
 			DBG_88E("%s: addr(0x%X)+cnts(%d) parameter error!\n", __func__, addr, cnts);
 			err = -EFAULT;
@@ -6094,7 +6094,7 @@ static int rtw_mp_efuse_set(struct net_device *dev,
 		for (jj = 0, kk = 0; jj < cnts; jj++, kk += 2)
 			setdata[jj] = key_2char2num(tmp[2][kk], tmp[2][kk + 1]);
 		/* Change to check TYPE_EFUSE_MAP_LEN, because 8188E raw 256, logic map over 256. */
-		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&max_available_size, false);
+		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&max_available_size);
 		if ((addr+cnts) > max_available_size) {
 			DBG_88E("%s: addr(0x%X)+cnts(%d) parameter error!\n", __func__, addr, cnts);
 			err = -EFAULT;
@@ -6169,7 +6169,7 @@ static int rtw_mp_efuse_set(struct net_device *dev,
 		for (jj = 0, kk = 0; jj < cnts; jj++, kk += 2)
 			setdata[jj] = key_2char2num(tmp[1][kk], tmp[1][kk + 1]);
 		/* Change to check TYPE_EFUSE_MAP_LEN, because 8188E raw 256, logic map over 256. */
-		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&max_available_size, false);
+		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_EFUSE_MAP_LEN, (void *)&max_available_size);
 		if ((addr+cnts) > max_available_size) {
 			DBG_88E("%s: addr(0x%X)+cnts(%d) parameter error!\n", __func__, addr, cnts);
 			err = -EFAULT;
@@ -6207,7 +6207,7 @@ static int rtw_mp_efuse_set(struct net_device *dev,
 		for (jj = 0, kk = 0; jj < cnts; jj++, kk += 2)
 			setdata[jj] = key_2char2num(tmp[1][kk], tmp[1][kk + 1]);
 
-		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size, false);
+		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
 		if ((addr+cnts) > max_available_size) {
 			DBG_88E("%s: addr(0x%X)+cnts(%d) parameter error!\n", __func__, addr, cnts);
 			err = -EFAULT;
@@ -6246,7 +6246,7 @@ static int rtw_mp_efuse_set(struct net_device *dev,
 		for (jj = 0, kk = 0; jj < cnts; jj++, kk += 2)
 			setdata[jj] = key_2char2num(tmp[2][kk], tmp[2][kk + 1]);
 
-		EFUSE_GetEfuseDefinition(padapter, EFUSE_BT, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size, false);
+		EFUSE_GetEfuseDefinition(padapter, EFUSE_BT, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
 		if ((addr+cnts) > max_available_size) {
 			DBG_88E("%s: addr(0x%X)+cnts(%d) parameter error!\n", __func__, addr, cnts);
 			err = -EFAULT;
@@ -6301,7 +6301,7 @@ static int rtw_mp_efuse_set(struct net_device *dev,
 	} else if (strcmp(tmp[0], "btfk2map") == 0) {
 		memcpy(pEfuseHal->BTEfuseModifiedMap, pEfuseHal->fakeBTEfuseModifiedMap, EFUSE_BT_MAX_MAP_LEN);
 
-		EFUSE_GetEfuseDefinition(padapter, EFUSE_BT, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size, false);
+		EFUSE_GetEfuseDefinition(padapter, EFUSE_BT, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
 		if (max_available_size < 1) {
 			err = -EFAULT;
 			goto exit;
@@ -6313,7 +6313,7 @@ static int rtw_mp_efuse_set(struct net_device *dev,
 			goto exit;
 		}
 	} else if (strcmp(tmp[0], "wlfk2map") == 0) {
-		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size, false);
+		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
 		if (max_available_size < 1) {
 			err = -EFAULT;
 			goto exit;
@@ -7198,7 +7198,7 @@ static int rtw_mp_thermal(struct net_device *dev,
 	Hal_GetThermalMeter(padapter, &val);
 
 	if (bwrite == 0) {
-		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size, false);
+		EFUSE_GetEfuseDefinition(padapter, EFUSE_WIFI, TYPE_AVAILABLE_EFUSE_BYTES_TOTAL, (void *)&max_available_size);
 		if (2 > max_available_size) {
 			DBG_88E("no available efuse!\n");
 			return -EFAULT;
-- 
1.7.10.4

