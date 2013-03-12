Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab3CLFJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:09:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26889 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751825Ab3CLFJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:09:12 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355068800"; 
   d="scan'208";a="6856309"
Message-ID: <513EB819.3000603@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 13:07:37 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>
CC: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/18] driver: gpu: drm: i915: remove cast for kzalloc return
 value
References: <513EB23D.7020303@cn.fujitsu.com>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:07:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:07:58,
	Serialize complete at 2013/03/12 13:07:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove cast for kzalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/i915/intel_sdvo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index d07a8cd..78413ec 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -451,7 +451,7 @@ static bool intel_sdvo_write_cmd(struct intel_sdvo *intel_sdvo, u8 cmd,
 	int i, ret = true;
 
         /* Would be simpler to allocate both in one go ? */        
-	buf = (u8 *)kzalloc(args_len * 2 + 2, GFP_KERNEL);
+	buf = kzalloc(args_len * 2 + 2, GFP_KERNEL);
 	if (!buf)
 		return false;
 
-- 
1.7.1

