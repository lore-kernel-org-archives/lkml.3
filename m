Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaLZHvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 02:51:31 -0500
Received: from ozlabs.org ([103.22.144.67]:59544 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaLZHva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 02:51:30 -0500
Date: Fri, 26 Dec 2014 18:51:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: linux-next: build failure after merge of the rcu tree
Message-ID: <20141226185120.402d392f@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/sUw8VThrEPS9m1il9ey3pIO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sUw8VThrEPS9m1il9ey3pIO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the rcu tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from arch/powerpc/include/asm/kvm_ppc.h:30:0,
                 from arch/powerpc/kernel/setup_64.c:68:
include/linux/kvm_host.h:366:21: error: field 'srcu' has incomplete type
  struct srcu_struct srcu;
                     ^
include/linux/kvm_host.h:367:21: error: field 'irq_srcu' has incomplete type
  struct srcu_struct irq_srcu;
                     ^

Caused by commit f01a973369dd ("srcu: Isolate srcu sections using
CONFIG_SRCU").  Please stop readding that commit after until it is
fixed :-(

I have reverted that commit for today (again :-().

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/sUw8VThrEPS9m1il9ey3pIO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUnRN+AAoJEMDTa8Ir7ZwVHGAP/12a/PwZLWwigF5QprQTtgtI
g2IbtFxIfyJ+cdqIzvxQzisJIWACWhsAltWnUKdoqGb3rvsrSuNOCpgZOD3l4tcG
55dkb5rnvcj3clKPFWGkY5s+sWmfzvG3LE3/9ZXzT9uSYYWt8YTmOAeqXW3LBD3q
dD4beL4S6KhFPm3VhOQ52eiFq0ULTtG9NDsBj/3e86sqKnh6uaT7Is7zvJIq+NJU
ch/BgIxR1DuC/lrSbf+wbF8rsyoh7RiUTZuE6ZFfwKhtSU6fYVJbai1/2A+Q/35d
VOgRmmLrhKgBiZqKoFC2MmUDHtYukGdhBGtkoHpRGUzaOnSpWRxMqk1FiAHS+diT
fb9V3BSxcGEDpvg2LAkq80cXcxE3efurMYjwSL6O2tLd7hPe0i2TT4PTY72IQScJ
/Y6wNhLrtZPYvG27s3ryl0OBraZbo9hAjJj7Nin6jenG1C/C2Lt8lp3H1bZtRJOi
4nStiEDu3gIWm84oWpKLRsY3H5sgQBx943c+rTqffqGCLb9JC7sbx5peDonYZ7F6
uAcFRQtYLjysRSbyGHkS94QGyJmSLfdpzYDY2uDfeuptUAsnnim7rNUeG4eHMX0G
TrxIpj/0Z/l0Gc6qKLqTdSDMgFdvELsqSYyznvb509VWfC/OTRYi7HyZyIvmrvT3
pUp5Z87+r6dJ+Y2iUxJm
=yP5x
-----END PGP SIGNATURE-----

--Sig_/sUw8VThrEPS9m1il9ey3pIO--
