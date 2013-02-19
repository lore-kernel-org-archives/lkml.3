Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323Ab3BSSxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:53:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54405 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559Ab3BSSxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:53:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tilman Schmidt <tilman@imap.cc>, "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 51/81] isdn/gigaset: fix zero size border case in debug dump
Date: Tue, 19 Feb 2013 15:49:14 -0300
Message-Id: <1361299784-8830-52-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

commit d721a1752ba544df8d7d36959038b26bc92bdf80 upstream.

If subtracting 12 from l leaves zero we'd do a zero size allocation,
leading to an oops later when we try to set the NUL terminator.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/isdn/gigaset/capi.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index 27e4a3e..f45b5b0 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -248,6 +248,8 @@ static inline void dump_rawmsg(enum debuglevel level, const char *tag,
 		CAPIMSG_APPID(data), CAPIMSG_MSGID(data), l,
 		CAPIMSG_CONTROL(data));
 	l -= 12;
+	if (l <= 0)
+		return;
 	dbgline = kmalloc(3 * l, GFP_ATOMIC);
 	if (!dbgline)
 		return;
-- 
1.7.9.5

