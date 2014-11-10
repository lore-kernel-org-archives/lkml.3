Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaKJSsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:48:30 -0500
Received: from mail-bn1on0061.outbound.protection.outlook.com ([157.56.110.61]:54400
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751228AbaKJSs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:48:28 -0500
X-AuditID: ac160a68-f79d16d0000019a2-40-5460f2665ef0
From: Avi Shchislowski <avi.shchislowski@sandisk.com>
To: <ulf.hansson@linaro.org>
CC: <avi.shchislowski@sandisk.com>, <cjb@laptop.org>,
        <linux-mmc@vger.kernel.org>, <Alex.Lemberg@sandisk.com>,
        <gwendal@google.com>, Alex Lemberg <alex.lemberg@sandisk.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] mmc: Support FFU for eMMC v5.0
Date: Mon, 10 Nov 2014 19:13:49 +0200
Message-ID: <1415639632-878-1-git-send-email-avi.shchislowski@sandisk.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRoxnkW7ap4QQg6+nlC22v97IZnF35wRG
	i8u75rBZHPnfz2hxfG24A6vHgk2lHoeurGX0uHNtD5vH501yASxRXDYpqTmZZalF+nYJXBnL
	F/1lK1ggVnHi7VSmBsZvgl2MnBwSAiYSW368YoOwxSQu3FsPZHNxCAmcYJS41/ACytnBKHHh
	7nRGmI7HzdNYIRInGSUm3uxnB0mwCZhKzGxbytTFyMEhIiAj0XjAGKSGWeAOo8Saa/fAmoUF
	jCX+TT/KDGKzCKhKTO36BhbnFfCSeLRgBlivhICCxJxJNiBhTgEBie2nLzCB2EIC/BJtm/sY
	QWZKCCxildg99zo7RK+gxMmZT1hAbGYBCYmDL14wQzRoSpxcuJxtAqPwLCRls5CULWBkWsUo
	lpuZU5ybnlpgaKhXnJiXklmcrZecn7uJERz4XBk7GLdOMj/EKMDBqMTD6/A2PkSINbGsuDL3
	EKMEB7OSCG/mw4QQId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rz287L8hQTSE0tSs1NTC1KLYLJM
	HJxSDYx9ad+0VgcfsJDyk/1bX7SHYbqs/IeiVvnj16/rPp5851vBroYzK+7oHSx7eaLsF5Or
	c+7yohf57Z5zN7A0JgWYPUntnOGY/rqKtUZxgcDtK4XPlu+srWzdfpf777pzYbNyJhsefivW
	rn//mZ2fv8hT0SqhKSr7Hqcfrgl8rh8fo/ejP5uV21iJpTgj0VCLuag4EQDw9PnfeAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFJMWRmVeSWpSXmKPExsXCtZEjRTftU0KIQcsdcYubD36wWezcu47J
	YvvrjWwWd3dOYLS4vGsOm8WR//2MFsfXhjuweyzYVOpx6MpaRo871/aweUxbc57J4/MmuQDW
	KC6blNSczLLUIn27BK6M5Yv+shUsEKs48XYqUwPjN8EuRk4OCQETicfN01ghbDGJC/fWs3Ux
	cnEICRxnlOif0coGkmATMJWY2baUCcQWEZCS6HnazAxSxCxwg1Gib/snsG5hAWOJf9OPMoPY
	LAKqElO7vjGC2LwCXhLfV34EquEA2qAgMWeSDUiYU0BAYvvpC2AzhQT4Jdo29zFOYORZwMiw
	ilEsNzOnODc9s8DQUK84MS8lszhbLzk/dxMjOHQ4I3cwPp1ofoiRiYNTqoHR7DfXlt7ySdsv
	Hrkr8HCV0JTl8ryPnVTSYzoYTp5x7j/+hmPd15oY05TeO12rlr34cO7D3ebW3VOPpma1RMld
	CX3x/rmndiF30i2lE5/26E30L2CXerws8srDu73JE2w+8M6z2bzT8ILcve8dMjr/9Hal27ur
	mknOb17AItM5/VF4XOLVSedWK7EUZyQaajEXFScCAEIs3QnNAQAA
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:63.163.107.172;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(189002)(92726001)(4396001)(21056001)(50226001)(33646002)(92566001)(48376002)(97736003)(76176999)(95666004)(86362001)(11926002)(84676001)(102836001)(36756003)(50986999)(62966003)(50466002)(31966008)(77156002)(107046002)(46102003)(229853001)(87286001)(44976005)(47776003)(19580395003)(20776003)(87936001)(2351001)(64706001)(69596002)(68736004)(106466001)(81156004)(19580405001)(88136002)(110136001)(89996001)(120916001)(99396003)(104166001);DIR:OUT;SFP:1101;SCL:1;SRVR:CO1PR02MB127;H:milsmgep11.sandisk.com;FPR:;MLV:sfv;PTR:ErrorRetry;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB127;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB127;
X-Forefront-PRVS: 039178EF4A
Authentication-Results: spf=pass (sender IP is 63.163.107.172)
 smtp.mailfrom=Avi.Shchislowski@sandisk.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB127;
X-OriginatorOrg: sandisk.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add eMMC5.0 ffu ext_csd fields

Signed-off-by: Avi Shchislowski <avi.shchislowski@sandisk.com>
Signed-off-by: Alex Lemberg <alex.lemberg@sandisk.com>


diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 1eda8dd..3b86ed3 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -603,6 +603,15 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		card->ext_csd.data_sector_size = 512;
 	}
 
+	/* eMMC v5 or later */
+	if (card->ext_csd.rev >= 7) {
+		card->ext_csd.ffu_capable =
+			((ext_csd[EXT_CSD_SUPPORTED_MODE] & 0x1) == 0x1) &&
+			((ext_csd[EXT_CSD_FW_CONFIG] & 0x1) == 0x0);
+		card->ext_csd.ffu_mode_op = ext_csd[EXT_CSD_FFU_FEATURES];
+	} else {
+		card->ext_csd.ffu_capable = false;
+	}
 out:
 	return err;
 }
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index d424b9d..dd01efe 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -81,6 +81,8 @@ struct mmc_ext_csd {
 	bool			hpi_en;			/* HPI enablebit */
 	bool			hpi;			/* HPI support bit */
 	unsigned int		hpi_cmd;		/* cmd used as HPI */
+	bool			ffu_capable;		/* FFU support */
+	bool			ffu_mode_op;		/* FFU mode operation */
 	bool			bkops;		/* background support bit */
 	bool			bkops_en;	/* background enable bit */
 	unsigned int            data_sector_size;       /* 512 bytes or 4KB */
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 64ec963..787787b 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -272,6 +272,9 @@ struct _mmc_csd {
  * EXT_CSD fields
  */
 
+#define EXT_CSD_FFU_STATUS		26	/* R */
+#define EXT_CSD_MODE_OPERATION_CODES	29	/* W */
+#define EXT_CSD_MODE_CONFIG		30	/* R/W */
 #define EXT_CSD_FLUSH_CACHE		32      /* W */
 #define EXT_CSD_CACHE_CTRL		33      /* R/W */
 #define EXT_CSD_POWER_OFF_NOTIFICATION	34	/* R/W */
@@ -290,6 +293,7 @@ struct _mmc_csd {
 #define EXT_CSD_SANITIZE_START		165     /* W */
 #define EXT_CSD_WR_REL_PARAM		166	/* RO */
 #define EXT_CSD_RPMB_MULT		168	/* RO */
+#define EXT_CSD_FW_CONFIG		169	/* R/W */
 #define EXT_CSD_BOOT_WP			173	/* R/W */
 #define EXT_CSD_ERASE_GROUP_DEF		175	/* R/W */
 #define EXT_CSD_PART_CONFIG		179	/* R/W */
@@ -326,6 +330,11 @@ struct _mmc_csd {
 #define EXT_CSD_GENERIC_CMD6_TIME	248	/* RO */
 #define EXT_CSD_CACHE_SIZE		249	/* RO, 4 bytes */
 #define EXT_CSD_PWR_CL_DDR_200_360	253	/* RO */
+#define EXT_CSD_NUM_OF_FW_SEC_PROG	302	/* RO, 4 bytes */
+#define EXT_CSD_FFU_ARG			487	/* RO, 4 bytes */
+#define EXT_CSD_OPERATION_CODE_TIMEOUT	491	/* RO */
+#define EXT_CSD_FFU_FEATURES		492	/* RO */
+#define EXT_CSD_SUPPORTED_MODE		493	/* RO */
 #define EXT_CSD_TAG_UNIT_SIZE		498	/* RO */
 #define EXT_CSD_DATA_TAG_SUPPORT	499	/* RO */
 #define EXT_CSD_MAX_PACKED_WRITES	500	/* RO */
-- 
1.7.9.5

