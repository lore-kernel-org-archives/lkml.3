Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3HVKPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 06:15:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19215 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab3HVKPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 06:15:40 -0400
X-IronPort-AV: E=Sophos;i="4.89,933,1367942400"; 
   d="scan'208";a="8272357"
Message-ID: <5215E3CD.5000903@cn.fujitsu.com>
Date: Thu, 22 Aug 2013 18:11:25 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] f2fs: use strncasecmp() simplify the string comparison
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/22 18:13:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/22 18:13:51,
	Serialize complete at 2013/08/22 18:13:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/namei.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 4e47518..106c0b4 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -83,21 +83,11 @@ static int is_multimedia_file(const unsigned char *s, const char *sub)
 {
 	size_t slen = strlen(s);
 	size_t sublen = strlen(sub);
-	int ret;
 
 	if (sublen > slen)
 		return 0;
 
-	ret = memcmp(s + slen - sublen, sub, sublen);
-	if (ret) {	/* compare upper case */
-		int i;
-		char upper_sub[8];
-		for (i = 0; i < sublen && i < sizeof(upper_sub); i++)
-			upper_sub[i] = toupper(sub[i]);
-		return !memcmp(s + slen - sublen, upper_sub, sublen);
-	}
-
-	return !ret;
+	return !strncasecmp(s + slen - sublen, sub, sublen);
 }
 
 /*
-- 
1.7.7

