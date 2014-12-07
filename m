Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaLGTbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 14:31:31 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:5006 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430AbaLGT0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 14:26:46 -0500
X-IronPort-AV: E=Sophos;i="5.07,534,1413237600"; 
   d="scan'208";a="111932932"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk, joe@perches.com,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/20] TTY: fix misspelling of current function in string
Date: Sun,  7 Dec 2014 20:20:48 +0100
Message-Id: <1417980062-25151-7-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the last argument of serial_paranoia_check by the actual function
name.

This was done using Coccinelle, including the use of Levenshtein distance,
as proposed by Rasmus Villemoes.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch is difficult to summarize, but is available in the cover
letter of this patch series.

 drivers/tty/amiserial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index d9f85f9..b2d7600 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -931,7 +931,7 @@ static void rs_send_xchar(struct tty_struct *tty, char ch)
 	struct serial_state *info = tty->driver_data;
         unsigned long flags;
 
-	if (serial_paranoia_check(info, tty->name, "rs_send_char"))
+	if (serial_paranoia_check(info, tty->name, "rs_send_xchar"))
 		return;
 
 	info->x_char = ch;

