Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaJCHaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 03:30:13 -0400
Received: from ozlabs.org ([103.22.144.67]:39251 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaJCHaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 03:30:12 -0400
Date: Fri, 3 Oct 2014 17:30:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: linux-next: build warnings after merge of the akpm-current tree
Message-ID: <20141003173004.7ac4edce@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5miqDsxQp2pRr5vKXDL+Eey"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5miqDsxQp2pRr5vKXDL+Eey
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (arm
multi_v7_defconfig) produced these warnings:

drivers/base/dma-contiguous.c:244:2: warning: initialization from incompati=
ble pointer type
  .device_init =3D rmem_cma_device_init,
  ^
drivers/base/dma-contiguous.c:244:2: warning: (near initialization for 'rme=
m_cma_ops.device_init')
drivers/base/dma-coherent.c:303:2: warning: initialization from incompatibl=
e pointer type
  .device_init =3D rmem_dma_device_init,
  ^

Introduced by commit e92f6296f3a2 ("drivers: dma-coherent: add
initialization from device tree").  This init routine is supposed to
return void ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/5miqDsxQp2pRr5vKXDL+Eey
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJULlCBAAoJEMDTa8Ir7ZwVmjcP/ivoW8UvsDXtfaF3dJTmUu71
zgGB4qTWk8XVf9jZEty9+t5lmxmH8/9wcmr7IdYi879EWBuB0fkWb70nYRvEQy1v
fJ6zZWh2YyIb2wf4gDLE+PqSx1iF8EPxBA49ybwg0S/ljc6c9QUAx2mU4lJ7ujkr
byk+f+mGQzNuNC9cJ3DPnAtMGgFZH6ceDUk1FU+1jVKCvPIDiKeNv96afzIrV5F9
13qtXrck+0Ptu86fSEHNsgQk6h5Pu55TMeOsgbFK1ouueFUKd/Lcv5I/A4vmLr+t
mwfadp4z7vZF3SizFsiLYOLRJSfigRrAf1ZfKXTjiNk6Li5WBRjyrqnGevFutafa
kZtIRWuc5PkOKX3QK2gEK7OsUV96y226N5n7r4NnSfKfvEUwidLdme8xOsJf2rbD
YLq8027lws9f/uoYiEd6PJJ8k/8WyEgns0POliPWkI/K8rUphQbOSBNGjibqeV+A
kYaeih4Vj7RWfCkM7pvR+pZIUSRyOWZduIcWFxF+iW06+Jb1ci855pjQXWmHcGpC
k0AodJEF9ijqCyntmnvjPa4DNYDk/2JldRG0fRfNdmMw29iDZ7J8ZBj8/v1a3ioN
IEEO6ofdsFd88IeC1vbPu0vaGiWloHO/FYgY2JYvxYqWY3YwDuirLSK8yFHDPGnA
f22DMADSPMuJTbm0leyF
=2Zeh
-----END PGP SIGNATURE-----

--Sig_/5miqDsxQp2pRr5vKXDL+Eey--
