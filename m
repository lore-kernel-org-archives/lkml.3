Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab3EWMcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:32:12 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44204 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758253Ab3EWMcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:32:11 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Graeme Smecher <gsmecher@threespeedlogic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/2] xilinx systemace: Fix device name assignment for SystemACE (from "xs`" to "xsa").
Date: Thu, 23 May 2013 14:31:55 +0200
Message-Id: <4b5d6615a1338145a461a6d4e1c7d3e42d4f4522.1369312303.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-1140-1369312316-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-1140-1369312316-0001

From: Graeme Smecher <gsmecher@threespeedlogic.com>

This fixes a bug introduced in 5d10302f46d, where device trees that don't
provide the "port-number" attribute are mistakenly assigned the device "xs`".
The error check that's supposed to assign a default letter can't succeed,
since it tests an unsigned type against a negative return code.

Signed-off-by: Graeme Smecher <gsmecher@threespeedlogic.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/block/xsysace.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index f8ef15f..3fd130f 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1160,8 +1160,7 @@ static int ace_probe(struct platform_device *dev)
 	dev_dbg(&dev->dev, "ace_probe(%p)\n", dev);

 	/* device id and bus width */
-	of_property_read_u32(dev->dev.of_node, "port-number", &id);
-	if (id < 0)
+	if (of_property_read_u32(dev->dev.of_node, "port-number", &id))
 		id = 0;
 	if (of_find_property(dev->dev.of_node, "8-bit", NULL))
 		bus_width = ACE_BUS_WIDTH_8;
--
1.8.2.3


--=_mimegpg-monstr-desktop-1140-1369312316-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGeDDwACgkQykllyylKDCEY3wCffT5m5T9N0NiJEsycOrqcYsAP
DzkAn3+2PO588a+Lrv8W4xHXODcmS48x
=UbY6
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-1140-1369312316-0001--
