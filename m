Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109Ab3BZCWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:22:44 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:36896 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759991Ab3BZCWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:22:34 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 01/10] ipc: Fix potential oops when src msg > 4k w/ MSG_COPY
Date: Mon, 25 Feb 2013 21:21:38 -0500
Message-Id: <1361845307-12737-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
References: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the src msg is > 4k, then dest->next points to the
next allocated segment; resetting it just prior to dereferencing
is bad.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 ipc/msgutil.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index ebfcbfa..5df8e4b 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -117,9 +117,6 @@ struct msg_msg *copy_msg(struct msg_msg *src, struct msg_msg *dst)
 	if (alen > DATALEN_MSG)
 		alen = DATALEN_MSG;
 
-	dst->next = NULL;
-	dst->security = NULL;
-
 	memcpy(dst + 1, src + 1, alen);
 
 	len -= alen;
-- 
1.8.1.2

