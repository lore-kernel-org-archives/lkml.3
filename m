Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbbAVPb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:31:57 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55486 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbbAVPby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:31:54 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: sis: remove unused variables
Date: Thu, 22 Jan 2015 21:01:39 +0530
Message-Id: <1421940699-20670-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

removed some variables which were not used. Few calls to SiS_GetReg()
were left behind as they are reading from the hardare, removing them
might affect the overall functionality.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
This patch will generate checkpatch error, to fix that error we need
to change the style of init.c and init301.c

 drivers/video/fbdev/sis/init.c     | 33 +++++----------------------------
 drivers/video/fbdev/sis/init301.c  | 10 ++--------
 drivers/video/fbdev/sis/sis_main.c |  9 ++++-----
 3 files changed, 11 insertions(+), 41 deletions(-)

diff --git a/drivers/video/fbdev/sis/init.c b/drivers/video/fbdev/sis/init.c
index dfe3eb7..bfeb550 100644
--- a/drivers/video/fbdev/sis/init.c
+++ b/drivers/video/fbdev/sis/init.c
@@ -2649,7 +2649,7 @@ static void
 SiS_SetCRT1ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 		unsigned short ModeIdIndex, unsigned short RRTI)
 {
-   unsigned short data, infoflag = 0, modeflag, resindex;
+   unsigned short data, infoflag = 0, modeflag;
 #ifdef CONFIG_FB_SIS_315
    unsigned char  *ROMAddr  = SiS_Pr->VirtualRomBase;
    unsigned short data2, data3;
@@ -2660,7 +2660,6 @@ SiS_SetCRT1ModeRegs(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
    if(SiS_Pr->UseCustomMode) {
       infoflag = SiS_Pr->CInfoFlag;
    } else {
-      resindex = SiS_GetResInfo(SiS_Pr, ModeNo, ModeIdIndex);
       if(ModeNo > 0x13) {
 	 infoflag = SiS_Pr->SiS_RefIndex[RRTI].Ext_InfoFlag;
       }
@@ -3539,17 +3538,13 @@ SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata,
 			struct fb_var_screeninfo *var, bool writeres
 )
 {
-   unsigned short HRE, HBE, HRS, HBS, HDE, HT;
-   unsigned short VRE, VBE, VRS, VBS, VDE, VT;
-   unsigned char  sr_data, cr_data, cr_data2;
-   int            A, B, C, D, E, F, temp;
+   unsigned short HRE, HBE, HRS, HDE;
+   unsigned short VRE, VBE, VRS, VDE;
+   unsigned char  sr_data, cr_data;
+   int B, C, D, E, F, temp;
 
    sr_data = crdata[14];
 
-   /* Horizontal total */
-   HT =  crdata[0] | ((unsigned short)(sr_data & 0x03) << 8);
-   A = HT + 5;
-
    /* Horizontal display enable end */
    HDE = crdata[1] | ((unsigned short)(sr_data & 0x0C) << 6);
    E = HDE + 1;
@@ -3558,9 +3553,6 @@ SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata,
    HRS = crdata[4] | ((unsigned short)(sr_data & 0xC0) << 2);
    F = HRS - E - 3;
 
-   /* Horizontal blank start */
-   HBS = crdata[2] | ((unsigned short)(sr_data & 0x30) << 4);
-
    sr_data = crdata[15];
    cr_data = crdata[5];
 
@@ -3589,13 +3581,6 @@ SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata,
    sr_data = crdata[13];
    cr_data = crdata[7];
 
-   /* Vertical total */
-   VT  = crdata[6] |
-	 ((unsigned short)(cr_data & 0x01) << 8) |
-	 ((unsigned short)(cr_data & 0x20) << 4) |
-	 ((unsigned short)(sr_data & 0x01) << 10);
-   A = VT + 2;
-
    /* Vertical display enable end */
    VDE = crdata[10] |
 	 ((unsigned short)(cr_data & 0x02) << 7) |
@@ -3610,14 +3595,6 @@ SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata,
 	 ((unsigned short)(sr_data & 0x08) << 7);
    F = VRS + 1 - E;
 
-   cr_data2 = (crdata[16] & 0x01) << 5;
-
-   /* Vertical blank start */
-   VBS = crdata[11] |
-	 ((unsigned short)(cr_data  & 0x08) << 5) |
-	 ((unsigned short)(cr_data2 & 0x20) << 4) |
-	 ((unsigned short)(sr_data  & 0x04) << 8);
-
    /* Vertical blank end */
    VBE = crdata[12] | ((unsigned short)(sr_data & 0x10) << 4);
    temp = VBE - ((E - 1) & 511);
diff --git a/drivers/video/fbdev/sis/init301.c b/drivers/video/fbdev/sis/init301.c
index 295e0de..20f7234 100644
--- a/drivers/video/fbdev/sis/init301.c
+++ b/drivers/video/fbdev/sis/init301.c
@@ -2151,17 +2151,15 @@ SiS_GetVCLK2Ptr(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned shor
 		unsigned short RefreshRateTableIndex)
 {
   unsigned short CRT2Index, VCLKIndex = 0, VCLKIndexGEN = 0, VCLKIndexGENCRT = 0;
-  unsigned short modeflag, resinfo, tempbx;
+  unsigned short resinfo, tempbx;
   const unsigned char *CHTVVCLKPtr = NULL;
 
   if(ModeNo <= 0x13) {
-     modeflag = SiS_Pr->SiS_SModeIDTable[ModeIdIndex].St_ModeFlag;
      resinfo = SiS_Pr->SiS_SModeIDTable[ModeIdIndex].St_ResInfo;
      CRT2Index = SiS_Pr->SiS_SModeIDTable[ModeIdIndex].St_CRT2CRTC;
      VCLKIndexGEN = (SiS_GetRegByte((SiS_Pr->SiS_P3ca+0x02)) >> 2) & 0x03;
      VCLKIndexGENCRT = VCLKIndexGEN;
   } else {
-     modeflag = SiS_Pr->SiS_EModeIDTable[ModeIdIndex].Ext_ModeFlag;
      resinfo = SiS_Pr->SiS_EModeIDTable[ModeIdIndex].Ext_RESINFO;
      CRT2Index = SiS_Pr->SiS_RefIndex[RefreshRateTableIndex].Ext_CRT2CRTC;
      VCLKIndexGEN = SiS_Pr->SiS_RefIndex[RefreshRateTableIndex].Ext_CRTVCLK;
@@ -7270,7 +7268,7 @@ SiS_ShiftXPos(struct SiS_Private *SiS_Pr, int shift)
 static void
 SiS_SetGroup4_C_ELV(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short ModeIdIndex)
 {
-   unsigned short temp, temp1, resinfo = 0;
+   unsigned short temp, temp1;
    unsigned char  *ROMAddr = SiS_Pr->VirtualRomBase;
 
    if(!(SiS_Pr->SiS_VBType & VB_SIS30xCLV)) return;
@@ -7282,10 +7280,6 @@ SiS_SetGroup4_C_ELV(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned
       if(!(ROMAddr[0x61] & 0x04)) return;
    }
 
-   if(ModeNo > 0x13) {
-      resinfo = SiS_Pr->SiS_EModeIDTable[ModeIdIndex].Ext_RESINFO;
-   }
-
    SiS_SetRegOR(SiS_Pr->SiS_Part4Port,0x3a,0x08);
    temp = SiS_GetReg(SiS_Pr->SiS_Part4Port,0x3a);
    if(!(temp & 0x01)) {
diff --git a/drivers/video/fbdev/sis/sis_main.c b/drivers/video/fbdev/sis/sis_main.c
index fcf610e..39e4dfd 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -4991,7 +4991,6 @@ static void sisfb_post_xgi_ddr2(struct sis_video_info *ivideo, u8 regb)
 	static const u8 cs168[8] = {
 		0x48, 0x78, 0x88, 0x00, 0x00, 0x00, 0x00, 0x00
 	};
-	u8 reg;
 	u8 v1;
 	u8 v2;
 	u8 v3;
@@ -4999,9 +4998,9 @@ static void sisfb_post_xgi_ddr2(struct sis_video_info *ivideo, u8 regb)
 	SiS_SetReg(SISCR, 0xb0, 0x80); /* DDR2 dual frequency mode */
 	SiS_SetReg(SISCR, 0x82, 0x77);
 	SiS_SetReg(SISCR, 0x86, 0x00);
-	reg = SiS_GetReg(SISCR, 0x86);
+	SiS_GetReg(SISCR, 0x86);
 	SiS_SetReg(SISCR, 0x86, 0x88);
-	reg = SiS_GetReg(SISCR, 0x86);
+	SiS_GetReg(SISCR, 0x86);
 	v1 = cs168[regb]; v2 = cs160[regb]; v3 = cs158[regb];
 	if (ivideo->haveXGIROM) {
 		v1 = bios[regb + 0x168];
@@ -5011,9 +5010,9 @@ static void sisfb_post_xgi_ddr2(struct sis_video_info *ivideo, u8 regb)
 	SiS_SetReg(SISCR, 0x86, v1);
 	SiS_SetReg(SISCR, 0x82, 0x77);
 	SiS_SetReg(SISCR, 0x85, 0x00);
-	reg = SiS_GetReg(SISCR, 0x85);
+	SiS_GetReg(SISCR, 0x85);
 	SiS_SetReg(SISCR, 0x85, 0x88);
-	reg = SiS_GetReg(SISCR, 0x85);
+	SiS_GetReg(SISCR, 0x85);
 	SiS_SetReg(SISCR, 0x85, v2);
 	SiS_SetReg(SISCR, 0x82, v3);
 	SiS_SetReg(SISCR, 0x98, 0x01);
-- 
1.8.1.2

