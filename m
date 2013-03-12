Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3CLFRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:17:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60970 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab3CLFRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:17:23 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355068800"; 
   d="scan'208";a="6856356"
Message-ID: <513EBA05.2040908@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 13:15:49 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Karsten Keil <isdn@linux-pingi.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/18] driver: isdn: hisax: remove cast for kmalloc/kzalloc
 return value
References: <513EB23D.7020303@cn.fujitsu.com>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:16:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:16:09,
	Serialize complete at 2013/03/12 13:16:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove cast for kmalloc/kzalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
---
 drivers/isdn/hisax/fsm.c    |    2 +-
 drivers/isdn/hisax/hfc_sx.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hisax/fsm.c b/drivers/isdn/hisax/fsm.c
index 1bb2910..c7a9471 100644
--- a/drivers/isdn/hisax/fsm.c
+++ b/drivers/isdn/hisax/fsm.c
@@ -26,7 +26,7 @@ FsmNew(struct Fsm *fsm, struct FsmNode *fnlist, int fncount)
 {
 	int i;
 
-	fsm->jumpmatrix = (FSMFNPTR *)
+	fsm->jumpmatrix =
 		kzalloc(sizeof(FSMFNPTR) * fsm->state_count * fsm->event_count, GFP_KERNEL);
 	if (!fsm->jumpmatrix)
 		return -ENOMEM;
diff --git a/drivers/isdn/hisax/hfc_sx.c b/drivers/isdn/hisax/hfc_sx.c
index 90f34ae..dc4574f 100644
--- a/drivers/isdn/hisax/hfc_sx.c
+++ b/drivers/isdn/hisax/hfc_sx.c
@@ -1479,7 +1479,7 @@ int setup_hfcsx(struct IsdnCard *card)
 			release_region(cs->hw.hfcsx.base, 2);
 			return (0);
 		}
-		if (!(cs->hw.hfcsx.extra = (void *)
+		if (!(cs->hw.hfcsx.extra =
 		      kmalloc(sizeof(struct hfcsx_extra), GFP_ATOMIC))) {
 			release_region(cs->hw.hfcsx.base, 2);
 			printk(KERN_WARNING "HFC-SX: unable to allocate memory\n");
-- 
1.7.1

