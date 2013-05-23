Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030Ab3EWMwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:52:47 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:41724 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991Ab3EWMwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:52:42 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] char: xilinx_hwicap: Fix typo in comment and extend it
Date: Thu, 23 May 2013 14:52:34 +0200
Message-Id: <5503818e35ad1011d613661ade15f72fd2945213.1369313543.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <113e9af3a4a45647da48d04b68cfc50aade0fb0c.1369313543.git.michal.simek@xilinx.com>
References: <113e9af3a4a45647da48d04b68cfc50aade0fb0c.1369313543.git.michal.simek@xilinx.com>
In-Reply-To: <113e9af3a4a45647da48d04b68cfc50aade0fb0c.1369313543.git.michal.simek@xilinx.com>
References: <113e9af3a4a45647da48d04b68cfc50aade0fb0c.1369313543.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-15218-1369313558-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-15218-1369313558-0001

From: Michal Simek <monstr@monstr.eu>

s/regsiter/register/

Use origin comment from the first driver version
which also explain the usage of XHI_MAX_RETRIES better.

Signed-off-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/char/xilinx_hwicap/xilinx_hwicap.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.h b/drivers/char/xilinx_hwicap/xilinx_hwicap.h
index 96677fc..38b145e 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.h
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.h
@@ -85,7 +85,13 @@ struct hwicap_driver_config {
 	void (*reset)(struct hwicap_drvdata *drvdata);
 };

-/* Number of times to poll the done regsiter */
+/* Number of times to poll the done register. This has to be large
+ * enough to allow an entire configuration to complete. If an entire
+ * page (4kb) is configured at once, that could take up to 4k cycles
+ * with a byte-wide icap interface. In most cases, this driver is
+ * used with a much smaller fifo, but this should be sufficient in the
+ * worst case.
+ */
 #define XHI_MAX_RETRIES     5000

 /************ Constant Definitions *************/
--
1.8.2.3


--=_mimegpg-monstr-desktop-15218-1369313558-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGeERYACgkQykllyylKDCHqYQCgl9FFvUGsx13Na53OPbwHElQf
jQwAn0ihT/+H2UHTUKDrwZrlgNBA4UNK
=SB7o
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-15218-1369313558-0001--
