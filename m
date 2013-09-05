Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab3IEUez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:34:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab3IEU2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eugene Surovegin <surovegin@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 04/14] powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.
Date: Thu,  5 Sep 2013 13:28:15 -0700
Message-Id: <20130905202614.921504590@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202614.354156084@linuxfoundation.org>
References: <20130905202614.354156084@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/hvc/hvsi_lib.c |    4 ++--
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


