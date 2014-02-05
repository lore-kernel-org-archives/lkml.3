Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaBEU1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:27:39 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48447 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbaBEUHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Colin Ian King <colin.king@canonical.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 152/213] USB: echi-dbgp: increase the controller wait time to come out of halt.
Date: Wed, 5 Feb 2014 15:01:47 -0500
Message-ID: <1391630568-49251-153-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f96a4216e85050c0a9d41a41ecb0ae9d8e39b509 upstream.

The default 10 microsecond delay for the controller to come out of
halt in dbgp_ehci_startup is too short, so increase it to 1 millisecond.

This is based on emperical testing on various USB debug ports on
modern machines such as a Lenovo X220i and an Ivybridge development
platform that needed to wait ~450-950 microseconds.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/early/ehci-dbgp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/early/ehci-dbgp.c b/drivers/usb/early/ehci-dbgp.c
index 6e98a3697844..e4c7f53dc56b 100644
--- a/drivers/usb/early/ehci-dbgp.c
+++ b/drivers/usb/early/ehci-dbgp.c
@@ -437,7 +437,7 @@ static int dbgp_ehci_startup(void)
 	writel(FLAG_CF, &ehci_regs->configured_flag);
 
 	/* Wait until the controller is no longer halted */
-	loop = 10;
+	loop = 1000;
 	do {
 		status = readl(&ehci_regs->status);
 		if (!(status & STS_HALT))
-- 
1.8.5.2

