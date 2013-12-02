Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3LBTS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:18:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab3LBTSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roel Kluin <roel.kluin@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3.12 116/212] tty: incorrect test of echo_buf() result for ECHO_OP_START
Date: Mon,  2 Dec 2013 11:15:07 -0800
Message-Id: <20131202191300.149346497@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit c476f6584b0011741b4f0316f1ac4aa3a99403e1 upstream.

test echo_buf() result for ECHO_OP_START

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/n_tty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -767,7 +767,7 @@ static size_t __process_echoes(struct tt
 	 * of echo overrun before the next commit), then discard enough
 	 * data at the tail to prevent a subsequent overrun */
 	while (ldata->echo_commit - tail >= ECHO_DISCARD_WATERMARK) {
-		if (echo_buf(ldata, tail == ECHO_OP_START)) {
+		if (echo_buf(ldata, tail) == ECHO_OP_START) {
 			if (echo_buf(ldata, tail) == ECHO_OP_ERASE_TAB)
 				tail += 3;
 			else


