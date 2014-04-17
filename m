Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaDQFMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 01:12:55 -0400
Received: from ozlabs.org ([103.22.144.67]:56435 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaDQFMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 01:12:53 -0400
Date: Thu, 17 Apr 2014 15:12:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Subject: linux-next: build failure after merge of the userns tree
Message-Id: <20140417151245.467efa8bd8d084277fd471c9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_Apr_2014_15_12_45_+1000_vxtK1j2rTTnckXmX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Apr_2014_15_12_45_+1000_vxtK1j2rTTnckXmX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

After merging the userns tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/namespace.c: In function 'new_mountpoint':
fs/namespace.c:725:9: error: implicit declaration of function 'hash' [-Werr=
or=3Dimplicit-function-declaration]
  struct list_head *chain =3D mountpoint_hashtable + hash(NULL, dentry);
         ^
fs/namespace.c:725:28: warning: initialization from incompatible pointer ty=
pe [enabled by default]
  struct list_head *chain =3D mountpoint_hashtable + hash(NULL, dentry);
                            ^
fs/namespace.c:741:2: warning: passing argument 2 of 'hlist_add_head' from =
incompatible pointer type [enabled by default]
  hlist_add_head(&mp->m_hash, chain);
  ^
In file included from include/linux/signal.h:4:0,
                 from include/linux/syscalls.h:72,
                 from fs/namespace.c:11:
include/linux/list.h:637:20: note: expected 'struct hlist_head *' but argum=
ent is of type 'struct list_head *'
 static inline void hlist_add_head(struct hlist_node *n, struct hlist_head =
*h)
                    ^

So clearly my merge conflict resolution was not sufficient.

I will just drop the userns tree for today.  Please give me some help
with the resolutions - or fix this stuff up yourselves.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__17_Apr_2014_15_12_45_+1000_vxtK1j2rTTnckXmX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTT2LTAAoJEMDTa8Ir7ZwVs6AP/1SkLD1fXA58m+K6wvVgy9rM
3Nz1FYHO2lHN6eqLj1vuhTKAT4jUOOjoXzaOV4Dh5xOxkI3oASD7VYRFN346kSg0
0JuM9RX4Wx5bw0aKtueFgppD947q1JPNAMFdGOkEvL90URwYglw8zBIIXxRrcdAk
hmLTxuwoAMQZWOTr0dQ8Q1PPGRBGfCumZ78hA0Zh+zs1QbFM99s+kiybvHM/iPbo
YNfyW3syLur3qWM+Ukhszxf143G9ZcMAj8z0NCTy4d1HOu1gULde6KjJRj3Gy4/j
9djO98Hi9EQ5CwJez+2SxrZH8mfP4Sp12CF5MHHYzp3Pfu9wNYn8ojxU0rzVxgfl
Roj/kKhI9ouWfp4G4Cqtk9ia4IXjg9jGwUQu59PinXLPq61C+iegVnyrijHXCs7r
8VEIfarZ5lewmXB0XqUaUBb+aAfFRZBFHkTNMX9frhbZ9wu+TfP6+L2pIiipwKnZ
FgcIx21KZA+AalrF0n07/wL5PmLqzDMPJR4f25cwhazM8tLx/MBhisU9LKFBQ/Lk
EBxa+rvl5wb1lEFYx0n9mes5/ZlfCnn+cku2+xrpVm2+G17tAyFRHDK1zDd1CygH
74WuZK5/NUQhznDhW5yRhC4hW20HmcKDfNVQXSbkrf/zgME4N9fl0LcMOv/AUVjx
nOOvV8TjQpbbyg7qJ4lS
=yW7W
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Apr_2014_15_12_45_+1000_vxtK1j2rTTnckXmX--
