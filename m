Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab3DCEXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 00:23:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50415 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755593Ab3DCEXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 00:23:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,398,1363104000"; 
   d="scan'208";a="6993339"
Message-ID: <515BAE6E.4040502@cn.fujitsu.com>
Date: Wed, 03 Apr 2013 12:22:06 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: kbuild test robot <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] sysfs: fix compile warning in i386
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/03 12:22:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/03 12:22:45,
	Serialize complete at 2013/04/03 12:22:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes compile warning in i386:

drivers/base/cpu.c: In function 'show_crash_notes_size':
drivers/base/cpu.c:142:2: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/base/cpu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index a55b590..ee38cc2 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -138,8 +138,10 @@ static ssize_t show_crash_notes_size(struct device *dev,
 				     char *buf)
 {
 	ssize_t rc;
+	unsigned long size;
 
-	rc = sprintf(buf, "%lu\n", sizeof(note_buf_t));
+	size = sizeof(note_buf_t);
+	rc = sprintf(buf, "%lu\n", size);
 	return rc;
 }
 static DEVICE_ATTR(crash_notes_size, 0400, show_crash_notes_size, NULL);
-- 
1.7.1
