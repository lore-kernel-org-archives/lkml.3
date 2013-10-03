Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3JCEMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:12:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab3JCEMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:12:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 20/52] serial: pch_uart: fix tty-kref leak in rx-error path
Date: Wed,  2 Oct 2013 21:05:38 -0700
Message-Id: <20131003040523.563238759@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit fc0919c68cb2f75bb1af759315f9d7e2a9443c28 upstream.

Fix tty-kref leak introduced by commit 384e301e ("pch_uart: fix a
deadlock when pch_uart as console") which never put its tty reference.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/pch_uart.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1071,6 +1071,8 @@ static void pch_uart_err_ir(struct eg20t
 	if (tty == NULL) {
 		for (i = 0; error_msg[i] != NULL; i++)
 			dev_err(&priv->pdev->dev, error_msg[i]);
+	} else {
+		tty_kref_put(tty);
 	}
 }
 


