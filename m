Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbaAMQ3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:29:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53464 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbaAMQEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 138/208] s390/3270: fix allocation of tty3270_screen structure
Date: Mon, 13 Jan 2014 15:59:39 +0000
Message-Id: <1389628849-1614-139-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 36d9f4d3b68c7035ead3850dc85f310a579ed0eb upstream.

The tty3270_alloc_screen function is called from tty3270_install with
swapped arguments, the number of columns instead of rows and vice versa.
The number of rows is typically smaller than the number of columns which
makes the screen array too big but the individual cell arrays for the
lines too small. Creating lines longer than the number of rows will
clobber the memory after the end of the cell array.
The fix is simple, call tty3270_alloc_screen with the correct argument
order.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/s390/char/tty3270.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index cee69da..4dd71ca 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -942,7 +942,7 @@ static int tty3270_install(struct tty_driver *driver, struct tty_struct *tty)
 		return rc;
 	}
 
-	tp->screen = tty3270_alloc_screen(tp->view.cols, tp->view.rows);
+	tp->screen = tty3270_alloc_screen(tp->view.rows, tp->view.cols);
 	if (IS_ERR(tp->screen)) {
 		rc = PTR_ERR(tp->screen);
 		raw3270_put_view(&tp->view);
-- 
1.8.3.2

