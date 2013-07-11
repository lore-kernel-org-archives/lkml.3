Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3GKWB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:01:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3GKWBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:01:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [ 12/19] tty: Reset itty for other pty
Date: Thu, 11 Jul 2013 15:01:29 -0700
Message-Id: <20130711214832.037841851@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130711214830.611455274@linuxfoundation.org>
References: <20130711214830.611455274@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit 64e377dcd7d75c241d614458e9619d3445de44ef upstream.

Commit 19ffd68f816878aed456d5e87697f43bd9e3bd2b
('pty: Remove redundant itty reset') introduced a regression
whereby the other pty's linkage is not cleared on teardown.
This triggers a false positive diagnostic in testing.

Properly reset the itty linkage.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/tty_io.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1618,6 +1618,8 @@ static void release_tty(struct tty_struc
 	tty_free_termios(tty);
 	tty_driver_remove_tty(tty->driver, tty);
 	tty->port->itty = NULL;
+	if (tty->link)
+		tty->link->port->itty = NULL;
 	cancel_work_sync(&tty->port->buf.work);
 
 	if (tty->link)


