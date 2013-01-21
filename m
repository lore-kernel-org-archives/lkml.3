Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab3AUW0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:26:37 -0500
Received: from gimli.pxnet.com ([89.1.7.7]:45315 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab3AUW0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:26:36 -0500
X-Greylist: delayed 1730 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 17:26:35 EST
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
        i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130121-patch-isdn-06.tilman@imap.cc>
In-Reply-To: <20130121-patch-isdn-00.tilman@imap.cc>
References: <20130121-patch-isdn-00.tilman@imap.cc>
Subject: [PATCH 6/6] isdn/gigaset: fix zero size border case in debug dump
Date: Mon, 21 Jan 2013 22:57:21 +0100 (CET)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (mail.pxnet.com [89.1.7.7]); Mon, 21 Jan 2013 22:57:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If subtracting 12 from l leaves zero we'd do a zero size allocation,
leading to an oops later when we try to set the NUL terminator.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
CC: stable <stable@kernel.org>
---
 drivers/isdn/gigaset/capi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index 68452b7..03a0a01 100644
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
1.7.3.4

