Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab3HPWlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:41:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab3HPWl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:41:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 056/133] serial: mxs: fix buffer overflow
Date: Fri, 16 Aug 2013 15:33:18 -0700
Message-Id: <1376692475-28413-57-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa@the-dreams.de>

commit 4829e7650f8a40645e4e32b26a37fb833a5e75f0 upstream.

SMATCH correctly found an off-by-one error:

drivers/tty/serial/mxs-auart.c:889 auart_console_write() error: buffer overflow 'auart_port' 5 <= 5

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/serial/mxs-auart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index f0d17ee..6b00fa5 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -885,7 +885,7 @@ auart_console_write(struct console *co, const char *str, unsigned int count)
 	unsigned int old_ctrl0, old_ctrl2;
 	unsigned int to = 1000;
 
-	if (co->index >	MXS_AUART_PORTS || co->index < 0)
+	if (co->index >= MXS_AUART_PORTS || co->index < 0)
 		return;
 
 	s = auart_port[co->index];
-- 
1.8.1.2

