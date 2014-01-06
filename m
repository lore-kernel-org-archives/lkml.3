Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbaAFWla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:41:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbaAFWlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.10 084/129] s390/3270: fix allocation of tty3270_screen structure
Date: Mon,  6 Jan 2014 14:38:33 -0800
Message-Id: <20140106223902.014985368@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/char/tty3270.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -942,7 +942,7 @@ static int tty3270_install(struct tty_dr
 		return rc;
 	}
 
-	tp->screen = tty3270_alloc_screen(tp->view.cols, tp->view.rows);
+	tp->screen = tty3270_alloc_screen(tp->view.rows, tp->view.cols);
 	if (IS_ERR(tp->screen)) {
 		rc = PTR_ERR(tp->screen);
 		raw3270_put_view(&tp->view);


