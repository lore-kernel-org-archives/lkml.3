Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab3IBI4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:56:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37899 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab3IBIzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eugene Surovegin <surovegin@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 56/58] powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.
Date: Mon,  2 Sep 2013 09:54:41 +0100
Message-Id: <1378112083-9475-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugene Surovegin <ebs@ebshome.net>

commit d220980b701d838560a70de691b53be007e99e78 upstream.

This solves a problem observed in kexec'ed kernel where 200ms timeout is
too short and bootconsole fails to initialize. Console did eventually
become workable but much later into the boot process.

Observed timeout was around 260ms, but I decided to make it a little bigger
for more reliability.

This has been tested on Power7 machine with Petitboot as a primary
bootloader and PowerNV firmware.

Signed-off-by: Eugene Surovegin <surovegin@google.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/hvc/hvsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/hvc/hvsi_lib.c b/drivers/tty/hvc/hvsi_lib.c
index 59c135d..2c51419 100644
--- a/drivers/tty/hvc/hvsi_lib.c
+++ b/drivers/tty/hvc/hvsi_lib.c
@@ -341,8 +341,8 @@ void hvsilib_establish(struct hvsi_priv *pv)
 
 	pr_devel("HVSI@%x:   ... waiting handshake\n", pv->termno);
 
-	/* Try for up to 200s */
-	for (timeout = 0; timeout < 20; timeout++) {
+	/* Try for up to 400ms */
+	for (timeout = 0; timeout < 40; timeout++) {
 		if (pv->established)
 			goto established;
 		if (!hvsi_get_packet(pv))
-- 
1.8.3.2

