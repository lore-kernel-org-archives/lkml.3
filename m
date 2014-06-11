Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321AbaFKRX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:23:56 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62640 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933286AbaFKRXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:23:48 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 15/22] staging: rtl8188eu: Remove function _rtw_read32()
Date: Wed, 11 Jun 2014 22:51:34 +0530
Message-Id: <1402507301-3722-15-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_rtw_read32() is a wrapper function, being used to call usb_read32().
Call usb_read32() directly and drop _rtw_read32().

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_debug.c         |   14 ++---
 drivers/staging/rtl8188eu/core/rtw_efuse.c         |    6 +-
 drivers/staging/rtl8188eu/core/rtw_io.c            |   12 ----
 drivers/staging/rtl8188eu/core/rtw_mp.c            |    8 +--
 drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c      |    2 +-
 drivers/staging/rtl8188eu/core/rtw_pwrctrl.c       |    2 +-
 drivers/staging/rtl8188eu/core/rtw_sreset.c        |    2 +-
 .../staging/rtl8188eu/hal/Hal8188ERateAdaptive.c   |    8 +--
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     |    2 +-
 drivers/staging/rtl8188eu/hal/odm.c                |    8 +--
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  |   20 +++----
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |    4 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |   36 ++++++------
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c      |    3 +-
 drivers/staging/rtl8188eu/include/rtw_io.h         |    4 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |   58 ++++++++++----------
 16 files changed, 87 insertions(+), 102 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_debug.c b/drivers/staging/rtl8188eu/core/rtw_debug.c
index d204537..615a090 100644
--- a/drivers/staging/rtl8188eu/core/rtw_debug.c
+++ b/drivers/staging/rtl8188eu/core/rtw_debug.c
@@ -104,7 +104,7 @@ int proc_get_read_reg(char *page, char **start,
 		len += snprintf(page + len, count - len, "rtw_read16(0x%x)=0x%x\n", proc_get_read_addr, rtw_read16(padapter, proc_get_read_addr));
 		break;
 	case 4:
-		len += snprintf(page + len, count - len, "rtw_read32(0x%x)=0x%x\n", proc_get_read_addr, rtw_read32(padapter, proc_get_read_addr));
+		len += snprintf(page + len, count - len, "usb_read32(0x%x)=0x%x\n", proc_get_read_addr, usb_read32(padapter, proc_get_read_addr));
 		break;
 	default:
 		len += snprintf(page + len, count - len, "error read length=%d\n", proc_get_read_len);
@@ -326,7 +326,7 @@ int proc_get_mac_reg_dump1(char *page, char **start,
 	for (i = 0x0; i < 0x300; i += 4) {
 		if (j%4 == 1)
 			len += snprintf(page + len, count - len, "0x%02x", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", rtw_read32(padapter, i));
+		len += snprintf(page + len, count - len, " 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
 			len += snprintf(page + len, count - len, "\n");
 	}
@@ -349,7 +349,7 @@ int proc_get_mac_reg_dump2(char *page, char **start,
 	for (i = 0x300; i < 0x600; i += 4) {
 		if (j%4 == 1)
 			len += snprintf(page + len, count - len, "0x%02x", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", rtw_read32(padapter, i));
+		len += snprintf(page + len, count - len, " 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
 			len += snprintf(page + len, count - len, "\n");
 	}
@@ -372,7 +372,7 @@ int proc_get_mac_reg_dump3(char *page, char **start,
 	for (i = 0x600; i < 0x800; i += 4) {
 		if (j%4 == 1)
 			len += snprintf(page + len, count - len, "0x%02x", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", rtw_read32(padapter, i));
+		len += snprintf(page + len, count - len, " 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
 			len += snprintf(page + len, count - len, "\n");
 	}
@@ -394,7 +394,7 @@ int proc_get_bb_reg_dump1(char *page, char **start,
 	for (i = 0x800; i < 0xB00; i += 4) {
 		if (j%4 == 1)
 			len += snprintf(page + len, count - len, "0x%02x", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", rtw_read32(padapter, i));
+		len += snprintf(page + len, count - len, " 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
 			len += snprintf(page + len, count - len, "\n");
 	}
@@ -415,7 +415,7 @@ int proc_get_bb_reg_dump2(char *page, char **start,
 	for (i = 0xB00; i < 0xE00; i += 4) {
 		if (j%4 == 1)
 			len += snprintf(page + len, count - len, "0x%02x", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", rtw_read32(padapter, i));
+		len += snprintf(page + len, count - len, " 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
 			len += snprintf(page + len, count - len, "\n");
 	}
@@ -436,7 +436,7 @@ int proc_get_bb_reg_dump3(char *page, char **start,
 	for (i = 0xE00; i < 0x1000; i += 4) {
 		if (j%4 == 1)
 			len += snprintf(page + len, count - len, "0x%02x", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", rtw_read32(padapter, i));
+		len += snprintf(page + len, count - len, " 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
 			len += snprintf(page + len, count - len, "\n");
 	}
diff --git a/drivers/staging/rtl8188eu/core/rtw_efuse.c b/drivers/staging/rtl8188eu/core/rtw_efuse.c
index 513e9c6..2a1b179 100644
--- a/drivers/staging/rtl8188eu/core/rtw_efuse.c
+++ b/drivers/staging/rtl8188eu/core/rtw_efuse.c
@@ -191,9 +191,9 @@ ReadEFuseByte(
 
 	/* Check bit 32 read-ready */
 	retry = 0;
-	value32 = rtw_read32(Adapter, EFUSE_CTRL);
+	value32 = usb_read32(Adapter, EFUSE_CTRL);
 	while (!(((value32 >> 24) & 0xff) & 0x80)  && (retry < 10000)) {
-		value32 = rtw_read32(Adapter, EFUSE_CTRL);
+		value32 = usb_read32(Adapter, EFUSE_CTRL);
 		retry++;
 	}
 
@@ -202,7 +202,7 @@ ReadEFuseByte(
 	/*  Designer says that there shall be some delay after ready bit is set, or the */
 	/*  result will always stay on last data we read. */
 	udelay(50);
-	value32 = rtw_read32(Adapter, EFUSE_CTRL);
+	value32 = usb_read32(Adapter, EFUSE_CTRL);
 
 	*pbuf = (u8)(value32 & 0xff);
 }
diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index 1da0936..9266d8f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -76,18 +76,6 @@ u16 _rtw_read16(struct adapter *adapter, u32 addr)
 	return r_val;
 }
 
-u32 _rtw_read32(struct adapter *adapter, u32 addr)
-{
-	u32 r_val;
-	struct io_priv *pio_priv = &adapter->iopriv;
-	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-	u32	(*_read32)(struct adapter *pintfhdl, u32 addr);
-	_read32 = pintfhdl->io_ops._read32;
-
-	r_val = _read32(adapter, addr);
-	return r_val;
-}
-
 int rtw_init_io_priv(struct adapter *padapter, void (*set_intf_ops)(struct _io_ops *pops))
 {
 	struct io_priv	*piopriv = &padapter->iopriv;
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
index c199268..77134bc 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
@@ -36,7 +36,7 @@ u32 read_macreg(struct adapter *padapter, u32 addr, u32 sz)
 		val = rtw_read16(padapter, addr);
 		break;
 	case 4:
-		val = rtw_read32(padapter, addr);
+		val = usb_read32(padapter, addr);
 		break;
 	default:
 		val = 0xffffffff;
@@ -818,7 +818,7 @@ static u32 GetPhyRxPktCounts(struct adapter *pAdapter, u32 selbit)
 	usb_write32(pAdapter, REG_RXERR_RPT, phyrx_set);
 
 	/* Read packet count */
-	count = rtw_read32(pAdapter, REG_RXERR_RPT) & RXERR_COUNTER_MASK;
+	count = usb_read32(pAdapter, REG_RXERR_RPT) & RXERR_COUNTER_MASK;
 
 	return count;
 }
@@ -853,7 +853,7 @@ static u32 rtw_GetPSDData(struct adapter *pAdapter, u32 point)
 	int psd_val;
 
 
-	psd_val = rtw_read32(pAdapter, 0x808);
+	psd_val = usb_read32(pAdapter, 0x808);
 	psd_val &= 0xFFBFFC00;
 	psd_val |= point;
 
@@ -863,7 +863,7 @@ static u32 rtw_GetPSDData(struct adapter *pAdapter, u32 point)
 
 	usb_write32(pAdapter, 0x808, psd_val);
 	mdelay(1);
-	psd_val = rtw_read32(pAdapter, 0x8B4);
+	psd_val = usb_read32(pAdapter, 0x8B4);
 
 	psd_val &= 0x0000FFFF;
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
index ebb97e8..2ba92e6 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mp_ioctl.c
@@ -808,7 +808,7 @@ int rtl8188eu_oid_rt_pro_read_register_hdl(struct oid_par_priv *poid_par_priv)
 		break;
 	default:
 		width = 4;
-		RegRWStruct->value = rtw_read32(Adapter, offset);
+		RegRWStruct->value = usb_read32(Adapter, offset);
 		break;
 	}
 	RT_TRACE(_module_mp_, _drv_notice_,
diff --git a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
index be4c094..51b2468 100644
--- a/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
+++ b/drivers/staging/rtl8188eu/core/rtw_pwrctrl.c
@@ -203,7 +203,7 @@ int ips_leave(struct adapter *padapter)
 			}
 		}
 
-		DBG_88E("==> ips_leave.....LED(0x%08x)...\n", rtw_read32(padapter, 0x4c));
+		DBG_88E("==> ips_leave.....LED(0x%08x)...\n", usb_read32(padapter, 0x4c));
 		pwrpriv->bips_processing = false;
 
 		pwrpriv->bkeepfwalive = false;
diff --git a/drivers/staging/rtl8188eu/core/rtw_sreset.c b/drivers/staging/rtl8188eu/core/rtw_sreset.c
index 3b846d3..22a3512 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sreset.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sreset.c
@@ -36,7 +36,7 @@ u8 sreset_get_wifi_status(struct adapter *padapter)
 	u8 status = WIFI_STATUS_SUCCESS;
 	u32 val32 = 0;
 
-	val32 = rtw_read32(padapter, REG_TXDMA_STATUS);
+	val32 = usb_read32(padapter, REG_TXDMA_STATUS);
 	if (val32 == 0xeaeaeaea) {
 		psrtpriv->Wifi_Error_Status = WIFI_IF_NOT_EXIST;
 	} else if (val32 != 0) {
diff --git a/drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c b/drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c
index ea5ba28..3c651d5 100644
--- a/drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c
+++ b/drivers/staging/rtl8188eu/hal/Hal8188ERateAdaptive.c
@@ -358,19 +358,19 @@ static int odm_ARFBRefresh_8188E(struct odm_dm_struct *dm_odm, struct odm_ra_inf
 		pRaInfo->RAUseRate = (pRaInfo->RateMask)&0x0000000d;
 		break;
 	case 12:
-		MaskFromReg = rtw_read32(adapt, REG_ARFR0);
+		MaskFromReg = usb_read32(adapt, REG_ARFR0);
 		pRaInfo->RAUseRate = (pRaInfo->RateMask)&MaskFromReg;
 		break;
 	case 13:
-		MaskFromReg = rtw_read32(adapt, REG_ARFR1);
+		MaskFromReg = usb_read32(adapt, REG_ARFR1);
 		pRaInfo->RAUseRate = (pRaInfo->RateMask)&MaskFromReg;
 		break;
 	case 14:
-		MaskFromReg = rtw_read32(adapt, REG_ARFR2);
+		MaskFromReg = usb_read32(adapt, REG_ARFR2);
 		pRaInfo->RAUseRate = (pRaInfo->RateMask)&MaskFromReg;
 		break;
 	case 15:
-		MaskFromReg = rtw_read32(adapt, REG_ARFR3);
+		MaskFromReg = usb_read32(adapt, REG_ARFR3);
 		pRaInfo->RAUseRate = (pRaInfo->RateMask)&MaskFromReg;
 		break;
 	default:
diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index 514d325..c4ee978 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -821,7 +821,7 @@ static void _PHY_SaveMACRegisters(
 	for (i = 0; i < (IQK_MAC_REG_NUM - 1); i++) {
 		MACBackup[i] = rtw_read8(adapt, MACReg[i]);
 	}
-	MACBackup[i] = rtw_read32(adapt, MACReg[i]);
+	MACBackup[i] = usb_read32(adapt, MACReg[i]);
 }
 
 static void reload_adda_reg(struct adapter *adapt, u32 *ADDAReg, u32 *ADDABackup, u32 RegiesterNum)
diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index 11101f3..60dbde7 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -1291,10 +1291,10 @@ void ODM_EdcaTurboInit(struct odm_dm_struct *pDM_Odm)
 	pDM_Odm->DM_EDCA_Table.bIsCurRDLState = false;
 	Adapter->recvpriv.bIsAnyNonBEPkts = false;
 
-	ODM_RT_TRACE(pDM_Odm, ODM_COMP_EDCA_TURBO, ODM_DBG_LOUD, ("Orginial VO PARAM: 0x%x\n", rtw_read32(Adapter, ODM_EDCA_VO_PARAM)));
-	ODM_RT_TRACE(pDM_Odm, ODM_COMP_EDCA_TURBO, ODM_DBG_LOUD, ("Orginial VI PARAM: 0x%x\n", rtw_read32(Adapter, ODM_EDCA_VI_PARAM)));
-	ODM_RT_TRACE(pDM_Odm, ODM_COMP_EDCA_TURBO, ODM_DBG_LOUD, ("Orginial BE PARAM: 0x%x\n", rtw_read32(Adapter, ODM_EDCA_BE_PARAM)));
-	ODM_RT_TRACE(pDM_Odm, ODM_COMP_EDCA_TURBO, ODM_DBG_LOUD, ("Orginial BK PARAM: 0x%x\n", rtw_read32(Adapter, ODM_EDCA_BK_PARAM)));
+	ODM_RT_TRACE(pDM_Odm, ODM_COMP_EDCA_TURBO, ODM_DBG_LOUD, ("Orginial VO PARAM: 0x%x\n", usb_read32(Adapter, ODM_EDCA_VO_PARAM)));
+	ODM_RT_TRACE(pDM_Odm, ODM_COMP_EDCA_TURBO, ODM_DBG_LOUD, ("Orginial VI PARAM: 0x%x\n", usb_read32(Adapter, ODM_EDCA_VI_PARAM)));
+	ODM_RT_TRACE(pDM_Odm, ODM_COMP_EDCA_TURBO, ODM_DBG_LOUD, ("Orginial BE PARAM: 0x%x\n", usb_read32(Adapter, ODM_EDCA_BE_PARAM)));
+	ODM_RT_TRACE(pDM_Odm, ODM_COMP_EDCA_TURBO, ODM_DBG_LOUD, ("Orginial BK PARAM: 0x%x\n", usb_read32(Adapter, ODM_EDCA_BK_PARAM)));
 }	/*  ODM_InitEdcaTurbo */
 
 void odm_EdcaTurboCheck(struct odm_dm_struct *pDM_Odm)
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index 71a2417..7a7d704 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -246,8 +246,8 @@ static void efuse_read_phymap_from_txpktbuf(
 			msleep(1);
 		}
 
-		lo32 = rtw_read32(adapter, REG_PKTBUF_DBG_DATA_L);
-		hi32 = rtw_read32(adapter, REG_PKTBUF_DBG_DATA_H);
+		lo32 = usb_read32(adapter, REG_PKTBUF_DBG_DATA_L);
+		hi32 = usb_read32(adapter, REG_PKTBUF_DBG_DATA_H);
 
 		if (i == 0) {
 			u8 lenc[2];
@@ -376,12 +376,12 @@ void rtw_IOL_cmd_tx_pkt_buf_dump(struct adapter *Adapter, int data_len)
 			msleep(1);
 			loop = 0;
 			do {
-				rstatus = (reg_140 = rtw_read32(Adapter, REG_PKTBUF_DBG_CTRL)&BIT24);
+				rstatus = (reg_140 = usb_read32(Adapter, REG_PKTBUF_DBG_CTRL)&BIT24);
 				if (rstatus) {
-					fifo_data = rtw_read32(Adapter, REG_PKTBUF_DBG_DATA_L);
+					fifo_data = usb_read32(Adapter, REG_PKTBUF_DBG_DATA_L);
 					memcpy(pbuf+(addr*8), &fifo_data, 4);
 
-					fifo_data = rtw_read32(Adapter, REG_PKTBUF_DBG_DATA_H);
+					fifo_data = usb_read32(Adapter, REG_PKTBUF_DBG_DATA_H);
 					memcpy(pbuf+(addr*8+4), &fifo_data, 4);
 				}
 				msleep(1);
@@ -549,7 +549,7 @@ static s32 _FWFreeToGo(struct adapter *padapter)
 
 	/*  polling CheckSum report */
 	do {
-		value32 = rtw_read32(padapter, REG_MCUFWDL);
+		value32 = usb_read32(padapter, REG_MCUFWDL);
 		if (value32 & FWDL_ChkSum_rpt)
 			break;
 	} while (counter++ < POLLING_READY_TIMEOUT_COUNT);
@@ -560,7 +560,7 @@ static s32 _FWFreeToGo(struct adapter *padapter)
 	}
 	DBG_88E("%s: Checksum report OK! REG_MCUFWDL:0x%08x\n", __func__, value32);
 
-	value32 = rtw_read32(padapter, REG_MCUFWDL);
+	value32 = usb_read32(padapter, REG_MCUFWDL);
 	value32 |= MCUFWDL_RDY;
 	value32 &= ~WINTINI_RDY;
 	usb_write32(padapter, REG_MCUFWDL, value32);
@@ -570,7 +570,7 @@ static s32 _FWFreeToGo(struct adapter *padapter)
 	/*  polling for FW ready */
 	counter = 0;
 	do {
-		value32 = rtw_read32(padapter, REG_MCUFWDL);
+		value32 = usb_read32(padapter, REG_MCUFWDL);
 		if (value32 & WINTINI_RDY) {
 			DBG_88E("%s: Polling FW ready success!! REG_MCUFWDL:0x%08x\n", __func__, value32);
 			return _SUCCESS;
@@ -1743,7 +1743,7 @@ static struct HAL_VERSION ReadChipVersion8188E(struct adapter *padapter)
 
 	pHalData = GET_HAL_DATA(padapter);
 
-	value32 = rtw_read32(padapter, REG_SYS_CFG);
+	value32 = usb_read32(padapter, REG_SYS_CFG);
 	ChipVersion.ICType = CHIP_8188E;
 	ChipVersion.ChipType = ((value32 & RTL_ID) ? TEST_CHIP : NORMAL_CHIP);
 
@@ -1907,7 +1907,7 @@ static s32 _LLTWrite(struct adapter *padapter, u32 address, u32 data)
 
 	/* polling */
 	do {
-		value = rtw_read32(padapter, LLTReg);
+		value = usb_read32(padapter, LLTReg);
 		if (_LLT_NO_ACTIVE == _LLT_OP_VALUE(value))
 			break;
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index e18a010..2f53da8 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -94,7 +94,7 @@ rtl8188e_PHY_QueryBBReg(
 {
 	u32 ReturnValue = 0, OriginalValue, BitShift;
 
-	OriginalValue = rtw_read32(Adapter, RegAddr);
+	OriginalValue = usb_read32(Adapter, RegAddr);
 	BitShift = phy_CalculateBitShift(BitMask);
 	ReturnValue = (OriginalValue & BitMask) >> BitShift;
 	return ReturnValue;
@@ -124,7 +124,7 @@ void rtl8188e_PHY_SetBBReg(struct adapter *Adapter, u32 RegAddr, u32 BitMask, u3
 	u32 OriginalValue, BitShift;
 
 	if (BitMask != bMaskDWord) { /* if not "double word" write */
-		OriginalValue = rtw_read32(Adapter, RegAddr);
+		OriginalValue = usb_read32(Adapter, RegAddr);
 		BitShift = phy_CalculateBitShift(BitMask);
 		Data = ((OriginalValue & (~BitMask)) | (Data << BitShift));
 	}
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index ef45817..80600bd 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -341,7 +341,7 @@ static void _InitNetworkType(struct adapter *Adapter)
 {
 	u32 value32;
 
-	value32 = rtw_read32(Adapter, REG_CR);
+	value32 = usb_read32(Adapter, REG_CR);
 	/*  TODO: use the other function to set network type */
 	value32 = (value32 & ~MASK_NETTYPE) | _NETTYPE(NT_LINK_AP);
 
@@ -385,7 +385,7 @@ static void _InitAdaptiveCtrl(struct adapter *Adapter)
 	u32 value32;
 
 	/*  Response Rate Set */
-	value32 = rtw_read32(Adapter, REG_RRSR);
+	value32 = usb_read32(Adapter, REG_RRSR);
 	value32 &= ~RATE_BITMAP_ALL;
 	value32 |= RATE_RRSR_CCK_ONLY_1M;
 	usb_write32(Adapter, REG_RRSR, value32);
@@ -469,7 +469,7 @@ static void usb_AggSettingTxUpdate(struct adapter *Adapter)
 		haldata->UsbTxAggMode = false;
 
 	if (haldata->UsbTxAggMode) {
-		value32 = rtw_read32(Adapter, REG_TDECTRL);
+		value32 = usb_read32(Adapter, REG_TDECTRL);
 		value32 = value32 & ~(BLK_DESC_NUM_MASK << BLK_DESC_NUM_SHIFT);
 		value32 |= ((haldata->UsbTxAggDescNum & BLK_DESC_NUM_MASK) << BLK_DESC_NUM_SHIFT);
 
@@ -633,7 +633,7 @@ static void _InitAntenna_Selection(struct adapter *Adapter)
 		return;
 	DBG_88E("==>  %s ....\n", __func__);
 
-	usb_write32(Adapter, REG_LEDCFG0, rtw_read32(Adapter, REG_LEDCFG0)|BIT23);
+	usb_write32(Adapter, REG_LEDCFG0, usb_read32(Adapter, REG_LEDCFG0)|BIT23);
 	PHY_SetBBReg(Adapter, rFPGA0_XAB_RFParameter, BIT13, 0x01);
 
 	if (PHY_QueryBBReg(Adapter, rFPGA0_XA_RFInterfaceOE, 0x300) == Antenna_A)
@@ -931,7 +931,7 @@ HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_LCK);
 	usb_write8(Adapter, REG_USB_HRPWM, 0);
 
 	/* ack for xmit mgmt frames. */
-	usb_write32(Adapter, REG_FWHW_TXQ_CTRL, rtw_read32(Adapter, REG_FWHW_TXQ_CTRL)|BIT(12));
+	usb_write32(Adapter, REG_FWHW_TXQ_CTRL, usb_read32(Adapter, REG_FWHW_TXQ_CTRL)|BIT(12));
 
 exit:
 HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_END);
@@ -1421,11 +1421,11 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 		break;
 	case HW_VAR_CHECK_BSSID:
 		if (*((u8 *)val)) {
-			usb_write32(Adapter, REG_RCR, rtw_read32(Adapter, REG_RCR)|RCR_CBSSID_DATA|RCR_CBSSID_BCN);
+			usb_write32(Adapter, REG_RCR, usb_read32(Adapter, REG_RCR)|RCR_CBSSID_DATA|RCR_CBSSID_BCN);
 		} else {
 			u32 val32;
 
-			val32 = rtw_read32(Adapter, REG_RCR);
+			val32 = usb_read32(Adapter, REG_RCR);
 
 			val32 &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 
@@ -1446,7 +1446,7 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 	case HW_VAR_MLME_SITESURVEY:
 		if (*((u8 *)val)) { /* under sitesurvey */
 			/* config RCR to receive different BSSID & not to receive data frame */
-			u32 v = rtw_read32(Adapter, REG_RCR);
+			u32 v = usb_read32(Adapter, REG_RCR);
 			v &= ~(RCR_CBSSID_BCN);
 			usb_write32(Adapter, REG_RCR, v);
 			/* reject all data frame */
@@ -1471,14 +1471,14 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				usb_write8(Adapter, REG_BCN_CTRL, rtw_read8(Adapter, REG_BCN_CTRL)&(~BIT(4)));
 			}
 			if ((pmlmeinfo->state&0x03) == WIFI_FW_AP_STATE) {
-				usb_write32(Adapter, REG_RCR, rtw_read32(Adapter, REG_RCR)|RCR_CBSSID_BCN);
+				usb_write32(Adapter, REG_RCR, usb_read32(Adapter, REG_RCR)|RCR_CBSSID_BCN);
 			} else {
 				if (Adapter->in_cta_test) {
-					u32 v = rtw_read32(Adapter, REG_RCR);
+					u32 v = usb_read32(Adapter, REG_RCR);
 					v &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);/*  RCR_ADF */
 					usb_write32(Adapter, REG_RCR, v);
 				} else {
-					usb_write32(Adapter, REG_RCR, rtw_read32(Adapter, REG_RCR)|RCR_CBSSID_BCN);
+					usb_write32(Adapter, REG_RCR, usb_read32(Adapter, REG_RCR)|RCR_CBSSID_BCN);
 				}
 			}
 		}
@@ -1494,11 +1494,11 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				usb_write16(Adapter, REG_RXFLTMAP2, 0xFFFF);
 
 				if (Adapter->in_cta_test) {
-					u32 v = rtw_read32(Adapter, REG_RCR);
+					u32 v = usb_read32(Adapter, REG_RCR);
 					v &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);/*  RCR_ADF */
 					usb_write32(Adapter, REG_RCR, v);
 				} else {
-					usb_write32(Adapter, REG_RCR, rtw_read32(Adapter, REG_RCR)|RCR_CBSSID_DATA|RCR_CBSSID_BCN);
+					usb_write32(Adapter, REG_RCR, usb_read32(Adapter, REG_RCR)|RCR_CBSSID_DATA|RCR_CBSSID_BCN);
 				}
 
 				if (check_fwstate(pmlmepriv, WIFI_STATION_STATE))
@@ -1805,9 +1805,9 @@ static void SetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 
 			if (!pwrpriv->bkeepfwalive) {
 				/* RX DMA stop */
-				usb_write32(Adapter, REG_RXPKT_NUM, (rtw_read32(Adapter, REG_RXPKT_NUM)|RW_RELEASE_EN));
+				usb_write32(Adapter, REG_RXPKT_NUM, (usb_read32(Adapter, REG_RXPKT_NUM)|RW_RELEASE_EN));
 				do {
-					if (!(rtw_read32(Adapter, REG_RXPKT_NUM)&RXDMA_IDLE))
+					if (!(usb_read32(Adapter, REG_RXPKT_NUM)&RXDMA_IDLE))
 						break;
 				} while (trycnt--);
 				if (trycnt == 0)
@@ -1875,7 +1875,7 @@ static void GetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 				val[0] = true;
 			} else {
 				u32 valRCR;
-				valRCR = rtw_read32(Adapter, REG_RCR);
+				valRCR = usb_read32(Adapter, REG_RCR);
 				valRCR &= 0x00070000;
 				if (valRCR)
 					val[0] = false;
@@ -1894,7 +1894,7 @@ static void GetHwReg8188EU(struct adapter *Adapter, u8 variable, u8 *val)
 		*val = haldata->bMacPwrCtrlOn;
 		break;
 	case HW_VAR_CHK_HI_QUEUE_EMPTY:
-		*val = ((rtw_read32(Adapter, REG_HGQ_INFORMATION)&0x0000ff00) == 0) ? true : false;
+		*val = ((usb_read32(Adapter, REG_HGQ_INFORMATION)&0x0000ff00) == 0) ? true : false;
 		break;
 	default:
 		break;
@@ -2169,7 +2169,7 @@ static void SetBeaconRelatedRegisters8188EUsb(struct adapter *adapt)
 
 	usb_write8(adapt, REG_SLOT, 0x09);
 
-	value32 = rtw_read32(adapt, REG_TCR);
+	value32 = usb_read32(adapt, REG_TCR);
 	value32 &= ~TSFRST;
 	usb_write32(adapt,  REG_TCR, value32);
 
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index c38cb11..9fd1c66 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -158,7 +158,7 @@ static u16 usb_read16(struct adapter *adapter, u32 addr)
 	return (u16)(le32_to_cpu(data)&0xffff);
 }
 
-static u32 usb_read32(struct adapter *adapter, u32 addr)
+u32 usb_read32(struct adapter *adapter, u32 addr)
 {
 	u8 request;
 	u8 requesttype;
@@ -668,5 +668,4 @@ void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
 	_rtw_memset((u8 *)pops, 0, sizeof(struct _io_ops));
 	pops->_read8 = &usb_read8;
 	pops->_read16 = &usb_read16;
-	pops->_read32 = &usb_read32;
 }
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 6c956f4..a48c5f4 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -46,7 +46,6 @@ struct intf_hdl;
 struct _io_ops {
 	u8 (*_read8)(struct adapter *pintfhdl, u32 addr);
 	u16 (*_read16)(struct adapter *pintfhdl, u32 addr);
-	u32 (*_read32)(struct adapter *pintfhdl, u32 addr);
 };
 
 struct io_req {
@@ -80,7 +79,7 @@ struct io_priv {
 
 u8 _rtw_read8(struct adapter *adapter, u32 addr);
 u16 _rtw_read16(struct adapter *adapter, u32 addr);
-u32 _rtw_read32(struct adapter *adapter, u32 addr);
+u32 usb_read32(struct adapter *adapter, u32 addr);
 u32 usb_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 void usb_read_port_cancel(struct adapter *adapter);
 
@@ -94,7 +93,6 @@ void usb_write_port_cancel(struct adapter *adapter);
 
 #define rtw_read8(adapter, addr) _rtw_read8((adapter), (addr))
 #define rtw_read16(adapter, addr) _rtw_read16((adapter), (addr))
-#define rtw_read32(adapter, addr) _rtw_read32((adapter), (addr))
 
 int rtw_init_io_priv(struct adapter *padapter,
 		     void (*set_intf_ops)(struct _io_ops *pops));
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 92e07a5..5119da3 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2187,7 +2187,7 @@ static int rtw_wx_read32(struct net_device *dev,
 		sprintf(extra, "0x%04X", data32);
 		break;
 	case 4:
-		data32 = rtw_read32(padapter, addr);
+		data32 = usb_read32(padapter, addr);
 		sprintf(extra, "0x%08X", data32);
 		break;
 	default:
@@ -2359,7 +2359,7 @@ static void rtw_dbg_mode_hdl(struct adapter *padapter, u32 id, u8 *pdata, u32 le
 			RegRWStruct->value = rtw_read16(padapter, RegRWStruct->offset);
 			break;
 		case 4:
-			RegRWStruct->value = rtw_read32(padapter, RegRWStruct->offset);
+			RegRWStruct->value = usb_read32(padapter, RegRWStruct->offset);
 			break;
 		default:
 			break;
@@ -3946,12 +3946,12 @@ static int rtw_cta_test_start(struct net_device *dev,
 		padapter->in_cta_test = 0;
 
 	if (padapter->in_cta_test) {
-		u32 v = rtw_read32(padapter, REG_RCR);
+		u32 v = usb_read32(padapter, REG_RCR);
 		v &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);/*  RCR_ADF */
 		usb_write32(padapter, REG_RCR, v);
 		DBG_88E("enable RCR_ADF\n");
 	} else {
-		u32 v = rtw_read32(padapter, REG_RCR);
+		u32 v = usb_read32(padapter, REG_RCR);
 		v |= RCR_CBSSID_DATA | RCR_CBSSID_BCN;/*  RCR_ADF */
 		usb_write32(padapter, REG_RCR, v);
 		DBG_88E("disable RCR_ADF\n");
@@ -4025,14 +4025,14 @@ static void mac_reg_dump(struct adapter *padapter)
 	for (i = 0x0; i < 0x300; i += 4) {
 		if (j%4 == 1)
 			pr_info("0x%02x", i);
-		pr_info(" 0x%08x ", rtw_read32(padapter, i));
+		pr_info(" 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
 			pr_info("\n");
 	}
 	for (i = 0x400; i < 0x800; i += 4) {
 		if (j%4 == 1)
 			pr_info("0x%02x", i);
-		pr_info(" 0x%08x ", rtw_read32(padapter, i));
+		pr_info(" 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
 			pr_info("\n");
 	}
@@ -4046,7 +4046,7 @@ static void bb_reg_dump(struct adapter *padapter)
 		if (j%4 == 1)
 			pr_info("0x%02x", i);
 
-		pr_info(" 0x%08x ", rtw_read32(padapter, i));
+		pr_info(" 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
 			pr_info("\n");
 	}
@@ -4115,7 +4115,7 @@ static int rtw_dbg_port(struct net_device *dev,
 			DBG_88E("rtw_read16(0x%x) = 0x%04x\n", arg, rtw_read16(padapter, arg));
 			break;
 		case 4:
-			DBG_88E("rtw_read32(0x%x) = 0x%08x\n", arg, rtw_read32(padapter, arg));
+			DBG_88E("usb_read32(0x%x) = 0x%08x\n", arg, usb_read32(padapter, arg));
 			break;
 		}
 		break;
@@ -4131,7 +4131,7 @@ static int rtw_dbg_port(struct net_device *dev,
 			break;
 		case 4:
 			usb_write32(padapter, arg, extra_arg);
-			DBG_88E("usb_write32(0x%x) = 0x%08x\n", arg, rtw_read32(padapter, arg));
+			DBG_88E("usb_write32(0x%x) = 0x%08x\n", arg, usb_read32(padapter, arg));
 			break;
 		}
 		break;
@@ -4284,7 +4284,7 @@ static int rtw_dbg_port(struct net_device *dev,
 			if (_SUCCESS != rtw_IOL_exec_cmds_sync(padapter, xmit_frame, 5000, 0))
 				ret = -EPERM;
 
-			final = rtw_read32(padapter, reg);
+			final = usb_read32(padapter, reg);
 			if (start_value+write_num-1 == final)
 				DBG_88E("continuous IOL_CMD_WD_REG to 0x%x %u times Success, start:%u, final:%u\n",
 					reg, write_num, start_value, final);
@@ -4586,30 +4586,30 @@ static int rtw_dbg_port(struct net_device *dev,
 			DBG_88E("rd(0xc58) = 0x%x\n", rtw_read8(padapter, 0xc58));
 			break;
 		case 0xff:
-			DBG_88E("dbg(0x210) = 0x%x\n", rtw_read32(padapter, 0x210));
-			DBG_88E("dbg(0x608) = 0x%x\n", rtw_read32(padapter, 0x608));
-			DBG_88E("dbg(0x280) = 0x%x\n", rtw_read32(padapter, 0x280));
-			DBG_88E("dbg(0x284) = 0x%x\n", rtw_read32(padapter, 0x284));
-			DBG_88E("dbg(0x288) = 0x%x\n", rtw_read32(padapter, 0x288));
+			DBG_88E("dbg(0x210) = 0x%x\n", usb_read32(padapter, 0x210));
+			DBG_88E("dbg(0x608) = 0x%x\n", usb_read32(padapter, 0x608));
+			DBG_88E("dbg(0x280) = 0x%x\n", usb_read32(padapter, 0x280));
+			DBG_88E("dbg(0x284) = 0x%x\n", usb_read32(padapter, 0x284));
+			DBG_88E("dbg(0x288) = 0x%x\n", usb_read32(padapter, 0x288));
 
-			DBG_88E("dbg(0x664) = 0x%x\n", rtw_read32(padapter, 0x664));
+			DBG_88E("dbg(0x664) = 0x%x\n", usb_read32(padapter, 0x664));
 
 			DBG_88E("\n");
 
-			DBG_88E("dbg(0x430) = 0x%x\n", rtw_read32(padapter, 0x430));
-			DBG_88E("dbg(0x438) = 0x%x\n", rtw_read32(padapter, 0x438));
+			DBG_88E("dbg(0x430) = 0x%x\n", usb_read32(padapter, 0x430));
+			DBG_88E("dbg(0x438) = 0x%x\n", usb_read32(padapter, 0x438));
 
-			DBG_88E("dbg(0x440) = 0x%x\n", rtw_read32(padapter, 0x440));
+			DBG_88E("dbg(0x440) = 0x%x\n", usb_read32(padapter, 0x440));
 
-			DBG_88E("dbg(0x458) = 0x%x\n", rtw_read32(padapter, 0x458));
+			DBG_88E("dbg(0x458) = 0x%x\n", usb_read32(padapter, 0x458));
 
-			DBG_88E("dbg(0x484) = 0x%x\n", rtw_read32(padapter, 0x484));
-			DBG_88E("dbg(0x488) = 0x%x\n", rtw_read32(padapter, 0x488));
+			DBG_88E("dbg(0x484) = 0x%x\n", usb_read32(padapter, 0x484));
+			DBG_88E("dbg(0x488) = 0x%x\n", usb_read32(padapter, 0x488));
 
-			DBG_88E("dbg(0x444) = 0x%x\n", rtw_read32(padapter, 0x444));
-			DBG_88E("dbg(0x448) = 0x%x\n", rtw_read32(padapter, 0x448));
-			DBG_88E("dbg(0x44c) = 0x%x\n", rtw_read32(padapter, 0x44c));
-			DBG_88E("dbg(0x450) = 0x%x\n", rtw_read32(padapter, 0x450));
+			DBG_88E("dbg(0x444) = 0x%x\n", usb_read32(padapter, 0x444));
+			DBG_88E("dbg(0x448) = 0x%x\n", usb_read32(padapter, 0x448));
+			DBG_88E("dbg(0x44c) = 0x%x\n", usb_read32(padapter, 0x44c));
+			DBG_88E("dbg(0x450) = 0x%x\n", usb_read32(padapter, 0x450));
 			break;
 		}
 		break;
@@ -6530,7 +6530,7 @@ static int rtw_mp_read_reg(struct net_device *dev,
 		break;
 	case 'd':
 		/*  4 bytes */
-		sprintf(data, "%08x", rtw_read32(padapter, addr));
+		sprintf(data, "%08x", usb_read32(padapter, addr));
 		/* add read data format blank */
 		for (i = 0; i <= strlen(data); i++) {
 			if (i%2 == 0) {
@@ -7253,14 +7253,14 @@ static int rtw_mp_dump(struct net_device *dev,
 		for (i = 0x0; i < 0x300; i += 4) {
 			if (j%4 == 1)
 				DBG_88E("0x%02x", i);
-			DBG_88E(" 0x%08x ", rtw_read32(padapter, i));
+			DBG_88E(" 0x%08x ", usb_read32(padapter, i));
 			if ((j++)%4 == 0)
 				DBG_88E("\n");
 		}
 		for (i = 0x400; i < 0x1000; i += 4) {
 			if (j%4 == 1)
 				DBG_88E("0x%02x", i);
-			DBG_88E(" 0x%08x ", rtw_read32(padapter, i));
+			DBG_88E(" 0x%08x ", usb_read32(padapter, i));
 			if ((j++)%4 == 0)
 				DBG_88E("\n");
 		}
-- 
1.7.10.4

