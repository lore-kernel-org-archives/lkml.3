Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab3CSDw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 23:52:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab3CSDw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 23:52:26 -0400
X-IronPort-AV: E=Sophos;i="4.84,869,1355068800"; 
   d="scan'208";a="6898010"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org, bhelgaas@google.com
Cc: linux-mm@kvack.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        Lin Feng <linfeng@cn.fujitsu.com>
Subject: [PATCH] kernel/range.c: subtract_range: fix the broken phrase issued by printk
Date: Tue, 19 Mar 2013 11:54:11 +0800
Message-Id: <1363665251-14377-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <CAE9FiQUrt11A0YAOLgvv3uTAWtTvVg3Mho9eD53orbxW6Jd8Vg@mail.gmail.com>
References: <CAE9FiQUrt11A0YAOLgvv3uTAWtTvVg3Mho9eD53orbxW6Jd8Vg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/19 11:50:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/19 11:51:00,
	Serialize complete at 2013/03/19 11:51:00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also replace deprecated printk(KERN_ERR...) with pr_err() as suggested
by Yinghai, attaching the function name to provide plenty info.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 kernel/range.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/range.c b/kernel/range.c
index 9b8ae2d..071b0ab 100644
--- a/kernel/range.c
+++ b/kernel/range.c
@@ -97,7 +97,8 @@ void subtract_range(struct range *range, int az, u64 start, u64 end)
 				range[i].end = range[j].end;
 				range[i].start = end;
 			} else {
-				printk(KERN_ERR "run of slot in ranges\n");
+				pr_err("%s: run out of slot in ranges\n",
+					__func__);
 			}
 			range[j].end = start;
 			continue;
-- 
1.8.0.1

