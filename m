Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab3BLUlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:41:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab3BLUlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:41:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tilman Schmidt <tilman@imap.cc>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 15/36] isdn/gigaset: fix zero size border case in debug dump
Date: Tue, 12 Feb 2013 12:41:09 -0800
Message-Id: <20130212203859.111143418@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203857.305594226@linuxfoundation.org>
References: <20130212203857.305594226@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Tilman Schmidt <tilman@imap.cc>

[ Upstream commit d721a1752ba544df8d7d36959038b26bc92bdf80 ]

If subtracting 12 from l leaves zero we'd do a zero size allocation,
leading to an oops later when we try to set the NUL terminator.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/gigaset/capi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -264,6 +264,8 @@ static inline void dump_rawmsg(enum debu
 		CAPIMSG_APPID(data), CAPIMSG_MSGID(data), l,
 		CAPIMSG_CONTROL(data));
 	l -= 12;
+	if (l <= 0)
+		return;
 	dbgline = kmalloc(3 * l, GFP_ATOMIC);
 	if (!dbgline)
 		return;


