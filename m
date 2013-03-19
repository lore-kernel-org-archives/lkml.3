Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924Ab3CSW5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:57:35 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:42321 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964903Ab3CSW5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:57:33 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Min Zhang <mzhang@mvista.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 07/18] tty: Deprecate ldisc .chars_in_buffer() method
Date: Tue, 19 Mar 2013 16:21:42 -0400
Message-Id: <1363724513-15604-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
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

