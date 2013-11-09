Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab3KIHXp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:23:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab3KIGvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nico Golde <nico@ngolde.de>, Fabian Yamaguchi <fabs@goesec.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 45/74] Staging: sb105x: info leak in mp_get_count()
Date: Fri,  8 Nov 2013 22:51:50 -0800
Message-Id: <20131109065116.682458370@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a8b33654b1e3b0c74d4a1fed041c9aae50b3c427 upstream.

The icount.reserved[] array isn't initialized so it leaks stack
information to userspace.

Reported-by: Nico Golde <nico@ngolde.de>
Reported-by: Fabian Yamaguchi <fabs@goesec.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/sb105x/sb_pci_mp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/sb105x/sb_pci_mp.c
+++ b/drivers/staging/sb105x/sb_pci_mp.c
@@ -1063,7 +1063,7 @@ static int mp_wait_modem_status(struct s
 
 static int mp_get_count(struct sb_uart_state *state, struct serial_icounter_struct *icnt)
 {
-	struct serial_icounter_struct icount;
+	struct serial_icounter_struct icount = {};
 	struct sb_uart_icount cnow;
 	struct sb_uart_port *port = state->port;
 


