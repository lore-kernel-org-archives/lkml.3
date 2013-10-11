Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab3JKKnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:43:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58486 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab3JKKnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 033/100] serial: pch_uart: fix tty-kref leak in rx-error path
Date: Fri, 11 Oct 2013 11:41:03 +0100
Message-Id: <1381488130-30235-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit fc0919c68cb2f75bb1af759315f9d7e2a9443c28 upstream.

Fix tty-kref leak introduced by commit 384e301e ("pch_uart: fix a
deadlock when pch_uart as console") which never put its tty reference.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/pch_uart.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 4798e94..9e97a39 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1064,6 +1064,8 @@ static void pch_uart_err_ir(struct eg20t_port *priv, unsigned int lsr)
 	if (tty == NULL) {
 		for (i = 0; error_msg[i] != NULL; i++)
 			dev_err(&priv->pdev->dev, error_msg[i]);
+	} else {
+		tty_kref_put(tty);
 	}
 }
 
-- 
1.8.3.2

