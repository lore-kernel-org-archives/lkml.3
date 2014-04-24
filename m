Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaDXV6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:58:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbaDXVxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:53:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 14/27] isdnloop: Validate NUL-terminated strings from user.
Date: Thu, 24 Apr 2014 14:55:48 -0700
Message-Id: <20140424215552.380669343@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140424215551.942390050@linuxfoundation.org>
References: <20140424215551.942390050@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

[ Upstream commit 77bc6bed7121936bb2e019a8c336075f4c8eef62 ]

Return -EINVAL unless all of user-given strings are correctly
NUL-terminated.

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/isdnloop/isdnloop.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/isdn/isdnloop/isdnloop.c
+++ b/drivers/isdn/isdnloop/isdnloop.c
@@ -1070,6 +1070,12 @@ isdnloop_start(isdnloop_card *card, isdn
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


