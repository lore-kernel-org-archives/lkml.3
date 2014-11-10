Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaKJDZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 22:25:23 -0500
Received: from ozlabs.org ([103.22.144.67]:55308 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaKJDZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 22:25:20 -0500
Date: Mon, 10 Nov 2014 14:25:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>, David Miller <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Catalina Mocanu <catalina.mocanu@gmail.com>
Subject: linux-next: manual merge of the tiny tree with the net-next tree
Message-ID: <20141110142511.03354f6a@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/KiKF=PikSDJWsC.+92lBaZC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/KiKF=PikSDJWsC.+92lBaZC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Josh,

Today's linux-next merge of the tiny tree got a conflict in
lib/Makefile between commit e5a2c8999576 ("fast_hash: avoid indirect
function calls") from the net-next tree and commit 4ecea0db79ef ("lib:
rhashtable: Make rhashtable.c optional") from the tiny tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc lib/Makefile
index 04e53dd16070,47b8305288e2..000000000000
--- a/lib/Makefile
+++ b/lib/Makefile
@@@ -22,11 -22,14 +22,14 @@@ lib-$(CONFIG_SMP) +=3D cpumask.
  lib-y	+=3D kobject.o klist.o
  obj-y	+=3D lockref.o
 =20
- obj-y +=3D bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32=
.o \
+ obj-y +=3D bcd.o div64.o sort.o parser.o debug_locks.o random32.o \
  	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
- 	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iovec.o clz_ctz.o \
+ 	 gcd.o lcm.o list_sort.o uuid.o iovec.o clz_ctz.o \
  	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
- 	 percpu-refcount.o percpu_ida.o rhashtable.o
 -	 percpu-refcount.o percpu_ida.o hash.o
++	 percpu-refcount.o percpu_ida.o
+ obj-$(CONFIG_FLEX_ARRAY) +=3D flex_array.o
+ obj-$(CONFIG_HALFMD4) +=3D halfmd4.o
+ obj-$(CONFIG_RHASHTABLE) +=3D rhashtable.o
  obj-y +=3D string_helpers.o
  obj-$(CONFIG_TEST_STRING_HELPERS) +=3D test-string_helpers.o
  obj-y +=3D kstrtox.o

--Sig_/KiKF=PikSDJWsC.+92lBaZC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYDAcAAoJEMDTa8Ir7ZwVv/oP/1F1l3UCNFpQh3mlk2F8pV/O
58WqS7Vh0eQ2T7tqRL62HLsdPxFY1pTAnqOocFsXdHx6y0IrtqJBghBZPRI4bMoT
MK4tvC6/bBVPINSyDi8pZfEGKKC1bkPyUSfOCUvRoQWlO/OE1U7mFs3gJkf6T0rI
5xr6BdvxCA4VaF5OyEalUWsoXfSeqoFFyCdMo4X3NUuPUZqYUXw/la3Lj3wipkB9
oq2w7VFZoQPnJCk/0SVN7ETUQYfzXmcBimtWcKsaTCAA0x6o400SSk2702XW2nOf
JmXsbM/AkySPtDHZvjf1j3WyqgkgYKgnnMmPqaYsVVc1t9ZxFAYVSiPJiBdJPZzQ
0+3RBqurztsPHmsBJcx/PHEBZkvk4SH43UNkeaDzNbuts7gOPyCng6zFm7cPRHbu
TmT0oDHCZgriPlMwIjqe/sEeUqbrEDgDYfvhyEPQSb5TZJihSTt0PzkMmC4TwmzZ
iutkmfiDH9StpUO4M3TJlzaI6lnC6C5Vi7LUET5DJAeZCZeYu+ErfW60xCry8Fzy
PIvqcqSZ69giwsI34u+nfszyE4izoRl9K2VE4i+l0q/Hilzvs7jTdmQq5vCmbszL
mC2OI8546TWAsZwo77ljqr2R4qi08LpDdfADmFh9Bc0lZlsrMCO1CVVg+vz74Ebt
GMpzBwxCm9Ru+716ZN+z
=Kj7Z
-----END PGP SIGNATURE-----

--Sig_/KiKF=PikSDJWsC.+92lBaZC--
