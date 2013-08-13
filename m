Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab3HMGi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:38:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522Ab3HMGeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:34:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 15/17] SCSI: nsp32: use mdelay instead of large udelay constants
Date: Mon, 12 Aug 2013 23:36:01 -0700
Message-Id: <20130813063502.946145118@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063501.728847844@linuxfoundation.org>
References: <20130813063501.728847844@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit b497ceb964a80ebada3b9b3cea4261409039e25a upstream.

ARM cannot handle udelay for more than 2 miliseconds, so we
should use mdelay instead for those.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: GOTO Masanori <gotom@debian.or.jp>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/nsp32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -2926,7 +2926,7 @@ static void nsp32_do_bus_reset(nsp32_hw_
 	 * reset SCSI bus
 	 */
 	nsp32_write1(base, SCSI_BUS_CONTROL, BUSCTL_RST);
-	udelay(RESET_HOLD_TIME);
+	mdelay(RESET_HOLD_TIME / 1000);
 	nsp32_write1(base, SCSI_BUS_CONTROL, 0);
 	for(i = 0; i < 5; i++) {
 		intrdat = nsp32_read2(base, IRQ_STATUS); /* dummy read */


