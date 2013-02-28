Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595Ab3B1P1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:27:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41868 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab3B1Op7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:45:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 006/139] pcmcia/vrc4171: Add missing spinlock init
Date: Thu, 28 Feb 2013 14:42:36 +0000
Message-Id: <1362062689-2567-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 811af9723859884f2f771f3174f3ddedab7c53b5 upstream.

It doesn't seem this spinlock was properly initialized. This bug was
introduced by commit 7a410e8d4d97457c8c381e2de9cdc7bd3306badc.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pcmcia/vrc4171_card.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pcmcia/vrc4171_card.c b/drivers/pcmcia/vrc4171_card.c
index 86e4a1a..6bb02ab 100644
--- a/drivers/pcmcia/vrc4171_card.c
+++ b/drivers/pcmcia/vrc4171_card.c
@@ -246,6 +246,7 @@ static int pccard_init(struct pcmcia_socket *sock)
 	socket = &vrc4171_sockets[slot];
 	socket->csc_irq = search_nonuse_irq();
 	socket->io_irq = search_nonuse_irq();
+	spin_lock_init(&socket->lock);
 
 	return 0;
 }
-- 
1.8.1.2

