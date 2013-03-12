Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab3CLFPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:15:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51203 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab3CLFPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:15:23 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355068800"; 
   d="scan'208";a="6856347"
Message-ID: <513EB98B.9010400@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 13:13:47 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Karsten Keil <isdn@linux-pingi.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/18] driver: isdn: capi: remove cast for kmalloc return
 value
References: <513EB23D.7020303@cn.fujitsu.com>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:14:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:14:08,
	Serialize complete at 2013/03/12 13:14:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove cast for kmalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
---
 drivers/isdn/capi/capidrv.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index 832bc80..cc9f192 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -469,8 +469,7 @@ static int capidrv_add_ack(struct capidrv_ncci *nccip,
 {
 	struct ncci_datahandle_queue *n, **pp;
 
-	n = (struct ncci_datahandle_queue *)
-		kmalloc(sizeof(struct ncci_datahandle_queue), GFP_ATOMIC);
+	n = kmalloc(sizeof(struct ncci_datahandle_queue), GFP_ATOMIC);
 	if (!n) {
 		printk(KERN_ERR "capidrv: kmalloc ncci_datahandle failed\n");
 		return -1;
-- 
1.7.1

