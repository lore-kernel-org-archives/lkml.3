Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab3BZF0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:26:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:10511 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab3BZF0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:26:30 -0500
X-IronPort-AV: E=Sophos;i="4.84,738,1355068800"; 
   d="scan'208";a="6769798"
Message-ID: <512C44E4.70907@cn.fujitsu.com>
Date: Tue, 26 Feb 2013 13:15:16 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Simon Horman <horms@verge.net.au>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/2] kexec: fix wrong types of some local variables
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 13:16:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 13:16:10,
	Serialize complete at 2013/02/26 13:16:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The types of the following local variables:
  - ubytes/mbytes in kimage_load_crash_segment()/kimage_load_normal_segment()
  - r in vmcoreinfo_append_str()
are wrong, so fix them.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 kernel/kexec.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 2436ffc..3cbfcc7 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -789,7 +789,7 @@ static int kimage_load_normal_segment(struct kimage *image,
 					 struct kexec_segment *segment)
 {
 	unsigned long maddr;
-	unsigned long ubytes, mbytes;
+	size_t ubytes, mbytes;
 	int result;
 	unsigned char __user *buf;
 
@@ -853,7 +853,7 @@ static int kimage_load_crash_segment(struct kimage *image,
 	 * We do things a page at a time for the sake of kmap.
 	 */
 	unsigned long maddr;
-	unsigned long ubytes, mbytes;
+	size_t ubytes, mbytes;
 	int result;
 	unsigned char __user *buf;
 
@@ -1455,7 +1455,7 @@ void vmcoreinfo_append_str(const char *fmt, ...)
 {
 	va_list args;
 	char buf[0x50];
-	int r;
+	size_t r;
 
 	va_start(args, fmt);
 	r = vsnprintf(buf, sizeof(buf), fmt, args);
-- 
1.7.1
