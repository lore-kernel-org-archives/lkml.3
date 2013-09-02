Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab3IBIy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:54:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37624 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab3IBIyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:54:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 03/58] serial: mxs: fix buffer overflow
Date: Mon,  2 Sep 2013 09:53:48 +0100
Message-Id: <1378112083-9475-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa@the-dreams.de>

commit 4829e7650f8a40645e4e32b26a37fb833a5e75f0 upstream.

SMATCH correctly found an off-by-one error:

drivers/tty/serial/mxs-auart.c:889 auart_console_write() error: buffer overflow 'auart_port' 5 <= 5

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/mxs-auart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 64565f8..5ceeed8 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -547,7 +547,7 @@ auart_console_write(struct console *co, const char *str, unsigned int count)
 	unsigned int old_ctrl0, old_ctrl2;
 	unsigned int to = 20000;
 
-	if (co->index >	MXS_AUART_PORTS || co->index < 0)
+	if (co->index >= MXS_AUART_PORTS || co->index < 0)
 		return;
 
 	s = auart_port[co->index];
-- 
1.8.3.2

