Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab3EWMcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:32:17 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:62296 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777Ab3EWMcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:32:14 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Graeme Smecher <gsmecher@threespeedlogic.com>
Subject: [PATCH 2/2] xilinx systemace: Fix sparse warnings
Date: Thu, 23 May 2013 14:31:56 +0200
Message-Id: <13f757593d672bf87b89b4eba9c31e65baceb1d9.1369312303.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <4b5d6615a1338145a461a6d4e1c7d3e42d4f4522.1369312303.git.michal.simek@xilinx.com>
References: <4b5d6615a1338145a461a6d4e1c7d3e42d4f4522.1369312303.git.michal.simek@xilinx.com>
In-Reply-To: <4b5d6615a1338145a461a6d4e1c7d3e42d4f4522.1369312303.git.michal.simek@xilinx.com>
References: <4b5d6615a1338145a461a6d4e1c7d3e42d4f4522.1369312303.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-1158-1369312329-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-1158-1369312329-0001

Fix sysace sparse warnings.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/block/xsysace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 3fd130f..1393b88 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -407,7 +407,7 @@ static void ace_dump_regs(struct ace_device *ace)
 		 ace_in32(ace, ACE_CFGLBA), ace_in(ace, ACE_FATSTAT));
 }

-void ace_fix_driveid(u16 *id)
+static void ace_fix_driveid(u16 *id)
 {
 #if defined(__BIG_ENDIAN)
 	int i;
@@ -463,7 +463,7 @@ static inline void ace_fsm_yieldirq(struct ace_device *ace)
 }

 /* Get the next read/write request; ending requests that we don't handle */
-struct request *ace_get_next_request(struct request_queue * q)
+static struct request *ace_get_next_request(struct request_queue *q)
 {
 	struct request *req;

--
1.8.2.3


--=_mimegpg-monstr-desktop-1158-1369312329-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGeDEkACgkQykllyylKDCEmHgCfVrbs1p8NzQIsHLpqNh00fhnQ
pmkAoJ23pZhlJjqdTJStRHGtcD/5rLQo
=Hffa
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-1158-1369312329-0001--
