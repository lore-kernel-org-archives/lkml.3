Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab3KHCSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:18:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34577 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab3KHCQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 88/91] Staging: sb105x: info leak in mp_get_count()
Date: Thu,  7 Nov 2013 18:15:43 -0800
Message-Id: <1383876946-2396-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a8b33654b1e3b0c74d4a1fed041c9aae50b3c427 upstream.

The icount.reserved[] array isn't initialized so it leaks stack
information to userspace.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/sb105x/sb_pci_mp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/sb105x/sb_pci_mp.c b/drivers/staging/sb105x/sb_pci_mp.c
index 9464f38..0f5e262 100644
--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -1063,7 +1063,7 @@ static int mp_wait_modem_status(struct sb_uart_state *state, unsigned long arg)
 
 static int mp_get_count(struct sb_uart_state *state, struct serial_icounter_struct *icnt)
 {
-	struct serial_icounter_struct icount;
+	struct serial_icounter_struct icount = {};
 	struct sb_uart_icount cnow;
 	struct sb_uart_port *port = state->port;
 
-- 
1.8.1.2

