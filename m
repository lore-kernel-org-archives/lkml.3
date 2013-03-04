Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab3CDM7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:59:33 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34496 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab3CDM73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:59:29 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Michal Januszewski <spock@gentoo.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH -v3 11/23] video/uvesafb: rename random32() to prandom_u32()
Date: Mon,  4 Mar 2013 21:58:19 +0900
Message-Id: <1362401911-14074-12-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
References: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Michal Januszewski <spock@gentoo.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org
---

No change from v2

 drivers/video/uvesafb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index b75db01..0d0a43c 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -166,7 +166,7 @@ static int uvesafb_exec(struct uvesafb_ktask *task)
 	memcpy(&m->id, &uvesafb_cn_id, sizeof(m->id));
 	m->seq = seq;
 	m->len = len;
-	m->ack = random32();
+	m->ack = prandom_u32();
 
 	/* uvesafb_task structure */
 	memcpy(m + 1, &task->t, sizeof(task->t));
-- 
1.8.1.2

