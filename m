Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab3IHDVF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:21:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56211 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756922Ab3IHDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eugene Surovegin" <ebs@ebshome.net>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Eugene Surovegin" <surovegin@google.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.313357386@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [103/121] powerpc/hvsi: Increase handshake timeout from 200ms to
 400ms.
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/hvc/hvsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/hvc/hvsi_lib.c
+++ b/drivers/tty/hvc/hvsi_lib.c
@@ -341,8 +341,8 @@ void hvsilib_establish(struct hvsi_priv
 
 	pr_devel("HVSI@%x:   ... waiting handshake\n", pv->termno);
 
-	/* Try for up to 200s */
-	for (timeout = 0; timeout < 20; timeout++) {
+	/* Try for up to 400ms */
+	for (timeout = 0; timeout < 40; timeout++) {
 		if (pv->established)
 			goto established;
 		if (!hvsi_get_packet(pv))

