Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaKKEl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:41:58 -0500
Received: from ozlabs.org ([103.22.144.67]:59271 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbaKKEl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:41:57 -0500
Date: Tue, 11 Nov 2014 15:41:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: linux-next: manual merge of the driver-core tree with the pm tree
Message-ID: <20141111154146.3fb1dfa3@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/YqgJzm.eEOG+gkScCnQvb2U"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/YqgJzm.eEOG+gkScCnQvb2U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/base/Makefile between commit b31384fa5de3 ("Driver core:
Unified device properties interface for platform firmware") from the pm
tree and commit 246246cbde5e ("drivers: base: support cpu cache
information interface to userspace via sysfs") from the driver-core
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/base/Makefile
index 53c3fe1aeb29,e81a55ca513c..000000000000
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@@ -4,7 -4,7 +4,7 @@@ obj-y			:=3D component.o core.o bus.o dd.
  			   driver.o class.o platform.o \
  			   cpu.o firmware.o init.o map.o devres.o \
  			   attribute_container.o transport_class.o \
- 			   topology.o container.o property.o
 -			   topology.o container.o cacheinfo.o
++			   topology.o container.o property.o cacheinfo.o
  obj-$(CONFIG_DEVTMPFS)	+=3D devtmpfs.o
  obj-$(CONFIG_DMA_CMA) +=3D dma-contiguous.o
  obj-y			+=3D power/

--Sig_/YqgJzm.eEOG+gkScCnQvb2U
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYZOSAAoJEMDTa8Ir7ZwVRT0P/A3xDBTY6xLaYSuLN600Fh6I
QKr+a6zEPfthx6PlEARKLj3kih4EBgDY8W0PlObxuYf5WDNxwMTKlT9VLFewkr/M
CrNgInS1F0LvJ+Znx3HoM1D+JFyjYIF8FwNr+200AxDVh0GOFHZJ2CTdzgTBTm6q
NUgOgxwNWCzsRnnVInzC9sBlnYGd8h6Lz6/uCnmoZPAcIhux3g1xHoe0etu3nzos
LTqXh7DKmTEWf61vbABRq8+dSNMvQolQzBtxIyd+0FsWfHEG80i9HHnNGjdA58j4
Zxh+t4PVl/XjolOWzFPqHylKuXjsHBV6mCo414X3rJm+aGGSuca+5I1b+L1LBeGC
XPkKhtd2OWjJUMLlQCj1pbnxWWr4Y94/gQz46Lq4PDGyEbesfklVcoGzGuHru6nN
OWtoPHbbVLMVIG1Wx0w8+zf+rr+DHiC9tr9n/f5v4pNlO/NpANURESls2Q1d69JY
//99IQyuG2wJ+qv+bnlbms6eaUtK9GTk76uDN0q+JrLGkVWwY+Ob9tPhyCyZPEWb
2Pd8Me+hAVxLsV5nGNegRCJGz4EnaSOPYAafU8lyxDcplJ6BcSrsosZJwzKq4erY
e/UGQQ6/jUXqflZ9qyPbpR3mmYldWJKGzwMCxosnHLbxV2BH/2NsKzc5mBi/v6Qv
2SnspUlIfoGVJg+rNzdr
=usz4
-----END PGP SIGNATURE-----

--Sig_/YqgJzm.eEOG+gkScCnQvb2U--
