Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaAaOSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:18:42 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:44283 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbaAaOSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:18:39 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/10] watchdog: xilinx: Move control_status_reg to functions
Date: Fri, 31 Jan 2014 15:18:11 +0100
Message-Id: <ca50a63f8e204043247268217f7981102da1e530.1391177880.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
In-Reply-To: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-23082-1391177913-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-23082-1391177913-0001

control_status_reg is temp variables and should be
used locally by specific function.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/watchdog/of_xilinx_wdt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index 8c2814e..aca9bab 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -52,13 +52,14 @@ struct xwdt_device {
 static struct xwdt_device xdev;

 static  u32 timeout;
-static  u32 control_status_reg;
 static  u8  no_timeout;

 static  DEFINE_SPINLOCK(spinlock);

 static int xilinx_wdt_start(struct watchdog_device *wdd)
 {
+	u32 control_status_reg;
+
 	spin_lock(&spinlock);

 	/* Clean previous status and enable the watchdog timer */
@@ -77,6 +78,8 @@ static int xilinx_wdt_start(struct watchdog_device *wdd)

 static int xilinx_wdt_stop(struct watchdog_device *wdd)
 {
+	u32 control_status_reg;
+
 	spin_lock(&spinlock);

 	control_status_reg = ioread32(xdev.base + XWT_TWCSR0_OFFSET);
@@ -94,6 +97,8 @@ static int xilinx_wdt_stop(struct watchdog_device *wdd)

 static int xilinx_wdt_keepalive(struct watchdog_device *wdd)
 {
+	u32 control_status_reg;
+
 	spin_lock(&spinlock);

 	control_status_reg = ioread32(xdev.base + XWT_TWCSR0_OFFSET);
--
1.8.2.3


--=_mimegpg-monstr-desktop-23082-1391177913-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLrsLkACgkQykllyylKDCFAOQCeOCXfeQVVC2jows3RrHCwHH0W
5qgAn2pe64Ue/84cZcnZ9I3est5xsFNX
=5zeM
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-23082-1391177913-0001--
