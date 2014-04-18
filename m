Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaDRJ0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:26:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:46047 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752444AbaDRJWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:50 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 67/72] isdnloop: Validate NUL-terminated strings from user.
Date: Fri, 18 Apr 2014 11:22:40 +0200
Message-Id: <2d6c1221476d05771f8b10f6ad1575fd068ab5e2.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 77bc6bed7121936bb2e019a8c336075f4c8eef62 ]

Return -EINVAL unless all of user-given strings are correctly
NUL-terminated.

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/isdn/isdnloop/isdnloop.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/isdn/isdnloop/isdnloop.c b/drivers/isdn/isdnloop/isdnloop.c
index 02125e6a9109..e1f8748ff25d 100644
--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -1070,6 +1070,12 @@ isdnloop_start(isdnloop_card *card, isdnloop_sdef *sdefp)
 		return -EBUSY;
 	if (copy_from_user((char *) &sdef, (char *) sdefp, sizeof(sdef)))
 		return -EFAULT;
+
+	for (i = 0; i < 3; i++) {
+		if (!memchr(sdef.num[i], 0, sizeof(sdef.num[i])))
+			return -EINVAL;
+	}
+
 	spin_lock_irqsave(&card->isdnloop_lock, flags);
 	switch (sdef.ptype) {
 	case ISDN_PTYPE_EURO:
-- 
1.9.2

