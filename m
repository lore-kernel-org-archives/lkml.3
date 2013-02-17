Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab3BQXBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:01:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45770 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756266Ab3BQWzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:41 -0500
Message-Id: <20130217225006.871315239@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:46 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Tilman Schmidt <tilman@imap.cc>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 45/66] isdn/gigaset: fix zero size border case in debug dump
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tilman Schmidt <tilman@imap.cc>

[ Upstream commit d721a1752ba544df8d7d36959038b26bc92bdf80 ]

If subtracting 12 from l leaves zero we'd do a zero size allocation,
leading to an oops later when we try to set the NUL terminator.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/isdn/gigaset/capi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index fd17bb3..08c2329 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -264,6 +264,8 @@ static inline void dump_rawmsg(enum debuglevel level, const char *tag,
 		CAPIMSG_APPID(data), CAPIMSG_MSGID(data), l,
 		CAPIMSG_CONTROL(data));
 	l -= 12;
+	if (l <= 0)
+		return;
 	dbgline = kmalloc(3*l, GFP_ATOMIC);
 	if (!dbgline)
 		return;


