Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3A3Bf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:35:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:17270 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab3A3BfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:35:25 -0500
X-IronPort-AV: E=Sophos;i="4.84,564,1355068800"; 
   d="scan'208";a="6662341"
Message-ID: <51087878.4010109@cn.fujitsu.com>
Date: Wed, 30 Jan 2013 09:33:44 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] KEXEC: Get rid of duplicate check for hole_end
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/30 09:34:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/30 09:34:14,
	Serialize complete at 2013/01/30 09:34:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hole_end has been checked to make sure it is <= crash_res.end in the
while condition check, so the if condition check is duplicate.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 kernel/kexec.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 5e4bd78..c2826fc 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -497,8 +497,6 @@ static struct page *kimage_alloc_crash_control_pages(struct kimage *image,
 
 		if (hole_end > KEXEC_CRASH_CONTROL_MEMORY_LIMIT)
 			break;
-		if (hole_end > crashk_res.end)
-			break;
 		/* See if I overlap any of the segments */
 		for (i = 0; i < image->nr_segments; i++) {
 			unsigned long mstart, mend;
-- 
1.7.1
