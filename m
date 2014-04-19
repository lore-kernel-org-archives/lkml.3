Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbaDSLf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 07:35:26 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:55869 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754283AbaDSLfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 07:35:14 -0400
X-IronPort-AV: E=Sophos;i="4.97,888,1389715200"; 
   d="scan'208";a="29471763"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 9/9 V2] idr: remove useless C-PreProcessor branch
Date: Sat, 19 Apr 2014 19:38:16 +0800
Message-ID: <1397907496-5993-10-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397907496-5993-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397907496-5993-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"#ifndef TEST" can't work for user space test now, just remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 lib/idr.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index e3c1da0..d77cdca 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -20,11 +20,9 @@
  * that id to this code and it returns your pointer.
  */
 
-#ifndef TEST                        // to test in user space...
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/export.h>
-#endif
 #include <linux/err.h>
 #include <linux/string.h>
 #include <linux/idr.h>
-- 
1.7.4.4

