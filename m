Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab3E3NuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:50:17 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63775 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab3E3Nt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:49:58 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] of: Export of_irq_count for using in modules
Date: Thu, 30 May 2013 15:49:43 +0200
Message-Id: <6aa29b1d109a46278a7f37b598defe07d6edfe60.1369921774.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-9587-1369921783-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-9587-1369921783-0001

Export of_irq_count for modules.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
We are using this function in remoteproc module drivers.
There is also drivers/gpio/gpio-mvebu.c in the tree
which use this function but this driver can't be compiled
as module. This could be also the reason why is not this driver as module.
---
 drivers/of/irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index a3c1c5a..c918dde 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -374,6 +374,7 @@ int of_irq_count(struct device_node *dev)

 	return nr;
 }
+EXPORT_SYMBOL_GPL(of_irq_count);

 /**
  * of_irq_to_resource_table - Fill in resource table with node's IRQ info
--
1.8.2.3


--=_mimegpg-monstr-desktop-9587-1369921783-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGnWPcACgkQykllyylKDCGXcQCfS3tTNrxzX02PzyO+iVbc9UuT
Bx8AoINF/8ZfB9Hw6Tyu+vR/xKiL66KK
=UDmo
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-9587-1369921783-0001--
