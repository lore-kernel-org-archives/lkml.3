Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030382Ab3E3K2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:28:43 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:52739 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968206Ab3E3K2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:28:19 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        renner@efe-gmbh.de, Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH v2 3/6] net: emaclite: Let's make xemaclite_adjust_link static
Date: Thu, 30 May 2013 12:28:05 +0200
Message-Id: <f8cc399b5ffff2314210c31e4d5040ca83129086.1369909618.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1369909618.git.michal.simek@xilinx.com>
References: <cover.1369909618.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1369909618.git.michal.simek@xilinx.com>
References: <cover.1369909618.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-5461-1369909695-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-5461-1369909695-0001

xemaclite_adjust_link is used locally.
It removes sparse warning:
drivers/net/ethernet/xilinx/xilinx_emaclite.c:916:6: warning:
symbol 'xemaclite_adjust_link' was not declared. Should it be static?

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v2: None

 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index fcd1e0b..93bb14e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -913,7 +913,7 @@ err_register:
  * There's nothing in the Emaclite device to be configured when the link
  * state changes. We just print the status.
  */
-void xemaclite_adjust_link(struct net_device *ndev)
+static void xemaclite_adjust_link(struct net_device *ndev)
 {
 	struct net_local *lp = netdev_priv(ndev);
 	struct phy_device *phy = lp->phy_dev;
--
1.8.2.3


--=_mimegpg-monstr-desktop-5461-1369909695-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGnKb8ACgkQykllyylKDCGNqgCfcL058oZNwap+O5tcMNCkRN1T
DBsAoIyl+la0xnT+uLV7o+z/slkxocsf
=qZrC
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-5461-1369909695-0001--
