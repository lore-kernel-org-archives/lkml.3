Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaKUFlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 00:41:40 -0500
Received: from ozlabs.org ([103.22.144.67]:40537 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbaKUFlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 00:41:39 -0500
Date: Fri, 21 Nov 2014 16:41:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>, Keerthy <j-keerthy@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the driver-core tree with the arm-soc
 tree
Message-ID: <20141121164131.0190e0ab@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/y7YDfZDjZbDRL5_Xi8nZKhb"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/y7YDfZDjZbDRL5_Xi8nZKhb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/bus/omap_l3_noc.c between commit 61b43d4e919e ("bus:
omap_l3_noc: Add resume hook to restore context") from the arm-soc tree
and commit 571b8c6adb1b ("bus: drop owner assignment from
platform_drivers") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/bus/omap_l3_noc.c
index 17d86595951c,1ff1863415c5..000000000000
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@@ -358,8 -300,6 +358,7 @@@ static struct platform_driver omap_l3_d
  	.probe		=3D omap_l3_probe,
  	.driver		=3D {
  		.name		=3D "omap_l3_noc",
- 		.owner		=3D THIS_MODULE,
 +		.pm		=3D L3_DEV_PM_OPS,
  		.of_match_table =3D of_match_ptr(l3_noc_match),
  	},
  };

--Sig_/y7YDfZDjZbDRL5_Xi8nZKhb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUbtCQAAoJEMDTa8Ir7ZwVbicP/2r1e4Uf+liz6GC2axBtdHhT
RTxBJe0JStb2Gy43/C/LLOQdCSQCsO6RIJolCEkO1oh+bRKvLiUpcwlDTIHVWG+1
5FG1VK1YSkOlinuB3DxwUluTvI66csJ1nwPuA72E0//RuXLS+oO2OfaWXG3tSRMB
03H7ZeoU9PEOz76rdSwrbv4yS4RxlttreHeclD+Mvw7/KeFtT528wYw49dcWsaYs
NjMOodttEUzwaOVXUSmllbXQ46n//Ck4HFDS+kYHuwAVFjKjXG7Jp5qD1GLDRExo
HIbGYSc9szlTXlUA+itVYwtt7AaZJMcta1g/0EbOcEB0/QMd3OfwCAJabJu8cfUL
323v80FfNfiN94+o6uhKqoP9+O/H/7ZDXXFxkqiMCeOSOWvkQrNWIzU/T/sBqP1y
Yfx5MSNThzaz5GXI2RJbnVvdmpKKslMzp0pOXWbZpGutS8LfjxkePZk72BXpz2Zh
IqqVfqfWeYbV89x3w0b3y6BHy6LzeH+4gD1jA7wvQLJX/jw6XBAWyzHHbW8c5rXi
j/QttZFG+wI1ckLqEn4UdIT2zccHPnAcnmoFGnWkEU+SdT0Kqv6PsdHHpDIAhkgT
FlOF018O3E8aQ3nyv5t7Zm9FyUOP7X08Oc7WF4rN4UJhCQIT3FGEOBISmaxYT8kS
PajCvU0gFHcAUJbq8TmJ
=6ZMd
-----END PGP SIGNATURE-----

--Sig_/y7YDfZDjZbDRL5_Xi8nZKhb--
