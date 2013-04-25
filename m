Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab3DYRar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:30:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61428 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab3DYR3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 10/21] [SCSI] nsp32: use mdelay instead of large udelay constants
Date: Thu, 25 Apr 2013 19:28:53 +0200
Message-Id: <1366910944-3033663-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:gH3DuRcIe8HKU2pybRUJB6WaCtBKyUbZbrfP/0IoXvf
 9Qekb5VrNN9/+tMDgtUsghwch0Sxic632qKl5a95dk2k9YjSp3
 DI5fDS0CNAzI9ruuKWC1w9iVh9vmc57lMTD5JDViFOivUGFAsR
 1B3YZ0RIL3P2z1c5cVm8f7HB0Bg5STqKDhx+ZUDyAcdy8AWIS1
 u7zmq+CMHFvYbhRloMhfkKe8eNUDGF2dDjQm5GAO/gbcukBzxg
 MRL8q3yyI/6C2qzXbr6GwtlubVCGzawRKpahDutsWVxEBI6yzz
 Zl/9PMevS/L/6sYcqN2f0UiwMSR3TL84v1MYQa9WZrLf/USfNu
 4r64reADab9JG11qbepXPSiuQ0SK+Ub4wVu0mOzyR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM cannot handle udelay for more than 2 miliseconds, so we
should use mdelay instead for those.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: GOTO Masanori <gotom@debian.or.jp>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/nsp32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 1e3879d..0665f9c 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -2899,7 +2899,7 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
 	 * reset SCSI bus
 	 */
 	nsp32_write1(base, SCSI_BUS_CONTROL, BUSCTL_RST);
-	udelay(RESET_HOLD_TIME);
+	mdelay(RESET_HOLD_TIME / 1000);
 	nsp32_write1(base, SCSI_BUS_CONTROL, 0);
 	for(i = 0; i < 5; i++) {
 		intrdat = nsp32_read2(base, IRQ_STATUS); /* dummy read */
-- 
1.8.1.2

