Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381AbaJDAsk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:48:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbaJCVcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.16 050/357] i2c: rcar: fix RCAR_IRQ_ACK_{RECV|SEND}
Date: Fri,  3 Oct 2014 14:27:16 -0700
Message-Id: <20141003212934.956670334@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit 938916fbb8e8cb67eacb784f4eda17e2950c16c5 upstream.

Bits 8-31 of all registers reflect the value of bits 0-7 on reads and should be
0 on writes, according to the manuals. RCAR_IRQ_ACK_{RECV|SEND} macros have all
1's in bits 8-31, thus going against the manuals, so fix them.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-rcar.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -76,8 +76,8 @@
 #define RCAR_IRQ_RECV	(MNR | MAL | MST | MAT | MDR)
 #define RCAR_IRQ_STOP	(MST)
 
-#define RCAR_IRQ_ACK_SEND	(~(MAT | MDE))
-#define RCAR_IRQ_ACK_RECV	(~(MAT | MDR))
+#define RCAR_IRQ_ACK_SEND	(~(MAT | MDE) & 0xFF)
+#define RCAR_IRQ_ACK_RECV	(~(MAT | MDR) & 0xFF)
 
 #define ID_LAST_MSG	(1 << 0)
 #define ID_IOERROR	(1 << 1)


