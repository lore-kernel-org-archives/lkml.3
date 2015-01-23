Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbbAWIgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:36:21 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:45437 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbAWIgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:36:16 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, netdev@vger.kernel.org
Subject: [PATCH] net: macb: Remove CONFIG_PM ifdef because of compilation warning
Date: Fri, 23 Jan 2015 09:36:03 +0100
Message-Id: <7970145ad4d864eaf31d694d22f2fecbcf6825c9.1422002161.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-10131-1422002164-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-10131-1422002164-0001

Fix compilation warning:
drivers/net/ethernet/cadence/macb.c:2415:12: warning: 'macb_suspend'
defined but not used [-Wunused-function]
 static int macb_suspend(struct device *dev)
drivers/net/ethernet/cadence/macb.c:2432:12: warning: 'macb_resume'
defined but not used [-Wunused-function]
 static int macb_resume(struct device *dev)

when CONFIG_PM=y, CONFIG_PM_SLEEP=n are used.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

 drivers/net/ethernet/cadence/macb.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index 3767271c7667..23ae32f118c2 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -2411,8 +2411,7 @@ static int __exit macb_remove(struct platform_device *pdev)
 	return 0;
 }

-#ifdef CONFIG_PM
-static int macb_suspend(struct device *dev)
+static int __maybe_unused macb_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct net_device *netdev = platform_get_drvdata(pdev);
@@ -2429,7 +2428,7 @@ static int macb_suspend(struct device *dev)
 	return 0;
 }

-static int macb_resume(struct device *dev)
+static int __maybe_unused macb_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct net_device *netdev = platform_get_drvdata(pdev);
@@ -2444,7 +2443,6 @@ static int macb_resume(struct device *dev)

 	return 0;
 }
-#endif

 static SIMPLE_DEV_PM_OPS(macb_pm_ops, macb_suspend, macb_resume);

--
1.8.2.3


--=_mimegpg-monstr-desktop-10131-1422002164-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlTCB/QACgkQykllyylKDCH7FQCggJJguVnhD3vLkYA31hivSz5S
bd4AmwUqFItZDZVBFEIO3Vf1TpZ+sfid
=/CfN
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-10131-1422002164-0001--
