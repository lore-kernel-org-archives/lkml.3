Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab3CLFMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:12:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53828 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab3CLFMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:12:14 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355068800"; 
   d="scan'208";a="6856323"
Message-ID: <513EB8D0.8040603@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 13:10:40 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/18] driver: hv: remove cast for kmalloc return value
References: <513EB23D.7020303@cn.fujitsu.com>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:11:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:11:01,
	Serialize complete at 2013/03/12 13:11:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove cast for kmalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: devel@linuxdriverproject.org
---
 drivers/hv/hv.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 7311589..ae49237 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -289,9 +289,8 @@ void hv_synic_init(void *arg)
 	/* Check the version */
 	rdmsrl(HV_X64_MSR_SVERSION, version);
 
-	hv_context.event_dpc[cpu] = (struct tasklet_struct *)
-					kmalloc(sizeof(struct tasklet_struct),
-						GFP_ATOMIC);
+	hv_context.event_dpc[cpu] = kmalloc(sizeof(struct tasklet_struct),
+					    GFP_ATOMIC);
 	if (hv_context.event_dpc[cpu] == NULL) {
 		pr_err("Unable to allocate event dpc\n");
 		goto cleanup;
-- 
1.7.1

