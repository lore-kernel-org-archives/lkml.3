Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab3C0Lpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:45:54 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:54303 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab3C0Lox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:44:53 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Min Zhang <mzhang@mvista.com>, Ilya Zykov <linux@izyk.ru>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 07/18] tty: Deprecate ldisc .chars_in_buffer() method
Date: Wed, 27 Mar 2013 07:43:57 -0400
Message-Id: <1364384648-6636-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364384648-6636-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
 <1364384648-6636-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 51b08d9..446674e 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -319,6 +319,7 @@ static ssize_t chars_in_buffer(struct tty_struct *tty)
 
 static ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
 {
+	WARN_ONCE(1, "%s is deprecated and scheduled for removal.", __func__);
 	return chars_in_buffer(tty);
 }
 
-- 
1.8.1.2

