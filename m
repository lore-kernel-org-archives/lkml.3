Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3CLEsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 00:48:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27161 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab3CLEsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 00:48:43 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355068800"; 
   d="scan'208";a="6856184"
Message-ID: <513EB34C.5060608@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 12:47:08 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-ia64@vger.kernel.org
Subject: [PATCH 02/18] ia64: remove cast for kmalloc return value
References: <513EB23D.7020303@cn.fujitsu.com>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 12:47:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 12:47:29,
	Serialize complete at 2013/03/12 12:47:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove cast for kmalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/kernel/mca_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/mca_drv.c b/arch/ia64/kernel/mca_drv.c
index 9392e02..94f8bf7 100644
--- a/arch/ia64/kernel/mca_drv.c
+++ b/arch/ia64/kernel/mca_drv.c
@@ -349,7 +349,7 @@ init_record_index_pools(void)
 
 	/* - 3 - */
 	slidx_pool.max_idx = (rec_max_size/sect_min_size) * 2 + 1;
-	slidx_pool.buffer = (slidx_list_t *)
+	slidx_pool.buffer =
 		kmalloc(slidx_pool.max_idx * sizeof(slidx_list_t), GFP_KERNEL);
 
 	return slidx_pool.buffer ? 0 : -ENOMEM;
-- 
1.7.1

