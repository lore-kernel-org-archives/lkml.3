Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbaCKKLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:11:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14566 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbaCKKLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:11:32 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9678282"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
Subject: [PATCH 12/17] drivers/s390: Replace hardcoding of 19 with MAX_NICE.
Date: Tue, 11 Mar 2014 18:09:20 +0800
Message-Id: <e9f9fafe2a1756d0c78de96e19d07284cae71e67.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:37,
	Serialize complete at 2014/03/11 18:08:37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
cc: linux-s390@vger.kernel.org
cc: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
---
 drivers/s390/crypto/ap_bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index ab3baa7..8eec165 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -1803,7 +1803,7 @@ static int ap_poll_thread(void *data)
 	int requests;
 	struct ap_device *ap_dev;
 
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 	while (1) {
 		if (ap_suspend_flag)
 			return 0;
-- 
1.8.2.1

