Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab3FQFdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:33:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44717 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab3FQFdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:33:05 -0400
Date: Mon, 17 Jun 2013 15:33:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Libo Chen <clbchenlibo.chen@huawei.com>
Subject: linux-next: manual merge of the driver-core tree with the
 devicetree tree
Message-Id: <20130617153302.abd2024c094b8899904acb12@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_15_33_02_+1000_T2YUYQMRaw81fshd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_15_33_02_+1000_T2YUYQMRaw81fshd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
include/linux/platform_device.h between commit 10dbc5e39a60 ("driver
core: move to_platform_driver to platform_device.h") from the devicetree
tree and commit 9447057eaff8 ("platform_device: use a macro instead of
platform_driver_register") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/platform_device.h
index 3413897,cd46ee5..0000000
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@@ -180,10 -180,13 +180,16 @@@ struct platform_driver=20
  	const struct platform_device_id *id_table;
  };
 =20
 +#define to_platform_driver(drv)	(container_of((drv), struct platform_driv=
er, \
 +				 driver))
 +
- extern int platform_driver_register(struct platform_driver *);
+ /*
+  * use a macro to avoid include chaining to get THIS_MODULE
+  */
+ #define platform_driver_register(drv) \
+ 	__platform_driver_register(drv, THIS_MODULE)
+ extern int __platform_driver_register(struct platform_driver *,
+ 					struct module *);
  extern void platform_driver_unregister(struct platform_driver *);
 =20
  /* non-hotpluggable platform devices may use this so that probe() and

--Signature=_Mon__17_Jun_2013_15_33_02_+1000_T2YUYQMRaw81fshd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvp+OAAoJEECxmPOUX5FE52IP/1cYMLSjm49SqTQd+dLPijIl
BiWs0y0HlX7SJmQ0HhtbNnGjoYsJm3FDe87YMYUGUB60xxNCIRSvqeBoNHpShueI
iLRagwgWuyl/kbSWBAg2GKt+MERSgzXNJpTLEGvHMsGy7eaIW2AEhqLJFIlCKr0e
MwM70zkYi+Gzfq/ZIwjfWPeq+eOok92xrm6EQHD+24ZvzDDtISl0gpvv/DradJmM
1cmPPUY87jHtwwLDUERclheGed04h7yQ4G9njZEvUouJMju4OQlw4xpBsi1S8yg6
f7Q/WGhSzQtUnd3ebNAAFIvCth5xBgwrWlHKIxifhny3WuViWhiZJxka55rD3jF7
BeiaI6FDQ5Zo3OdYy7MaO8tZ05123NXTzu3v47IQ+Cpo1/i1JIGvPtLlNRCsvbJL
4tRzrPFLTlsJz8NN9jPyNtX9nBTitDkpEB8sRcAzGEY126pMu8smsotFNSNdo5Fb
LSzITjjgkKDtZ7LY6J/ykQ6ZMRNMlNDg6ifqHkqeTx1EN67GPO+SEZ12+/ozfAYb
JbLrvXTq9QIG2OAJCq7ACrL4dVTDS/3BgvHRGd3Z16PrP5QQ9yS7Y3ZOQGIU6hO2
cuwXK8UeypKf8RRbcnYnQIQyavFDTLg6hgCH2q5jxtArFtak7zLwxR6KyA4+EFZI
JTUGYJOAD7jN1PjeQ4ff
=U4gG
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_15_33_02_+1000_T2YUYQMRaw81fshd--
