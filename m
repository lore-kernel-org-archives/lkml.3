Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaEVT6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:58:49 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:60673 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750760AbaEVT6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:58:48 -0400
Message-ID: <1400788726.16407.25.camel@x220>
Subject: [PATCH] [SCSI] mptfusion: remove check for CONFIG_FUSION_MAX_FC_SGE
From: Paul Bolle <pebolle@tiscali.nl>
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com
Cc: DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 22 May 2014 21:58:46 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 May 2014 19:58:46.0170 (UTC) FILETIME=[3D880FA0:01CF75F8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check for CONFIG_FUSION_MAX_FC_SGE was added in v2.6.31. But the
related Kconfig symbol was never added to the tree. Remove this check,
as it always evaluates to false.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested only.

 drivers/message/fusion/mptbase.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 76c05bc24cb7..43695ec7ac83 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -177,17 +177,7 @@
 #define MPT_SCSI_SG_DEPTH	40
 #endif
 
-#ifdef CONFIG_FUSION_MAX_FC_SGE
-#if CONFIG_FUSION_MAX_FC_SGE  < 16
-#define MPT_SCSI_FC_SG_DEPTH	16
-#elif CONFIG_FUSION_MAX_FC_SGE  > 256
-#define MPT_SCSI_FC_SG_DEPTH	256
-#else
-#define MPT_SCSI_FC_SG_DEPTH	CONFIG_FUSION_MAX_FC_SGE
-#endif
-#else
 #define MPT_SCSI_FC_SG_DEPTH	40
-#endif
 
 /* debug print string length used for events and iocstatus */
 # define EVENT_DESCR_STR_SZ             100
-- 
1.9.0

