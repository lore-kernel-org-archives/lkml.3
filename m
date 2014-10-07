Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbaJGXlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:41:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbaJGXTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Alexandru M Stan <amstan@chromium.org>,
        Max Schwarz <max.schwarz@online.de>, Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.16 08/26] i2c: rk3x: fix 0 length write transfers
Date: Tue,  7 Oct 2014 16:19:24 -0700
Message-Id: <20141007231848.736935822@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231848.487609292@linuxfoundation.org>
References: <20141007231848.487609292@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru M Stan <amstan@chromium.org>

commit cf27020d2f253bac6457d6833b97141030f0122a upstream.

i2cdetect -q was broken (everything was a false positive, and no transfers were
actually being sent over i2c). The way it works is by sending a 0 length write
request and checking for NACK. This patch fixes the 0 length writes and actually
sends them.

Reported-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Alexandru M Stan <amstan@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
Tested-by: Max Schwarz <max.schwarz@online.de>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-rk3x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -238,7 +238,7 @@ static void rk3x_i2c_fill_transmit_buf(s
 	for (i = 0; i < 8; ++i) {
 		val = 0;
 		for (j = 0; j < 4; ++j) {
-			if (i2c->processed == i2c->msg->len)
+			if ((i2c->processed == i2c->msg->len) && (cnt != 0))
 				break;
 
 			if (i2c->processed == 0 && cnt == 0)


