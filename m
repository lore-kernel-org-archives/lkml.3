Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaDVBex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:34:53 -0400
Received: from [101.0.96.218] ([101.0.96.218]:49707 "EHLO pide.tip.net.au"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaDVBev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:34:51 -0400
Date: Tue, 22 Apr 2014 11:34:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Subject: Re: linux-next: build failure after merge of the userns tree
Message-Id: <20140422113422.a49a96ab12274a1bff6cb14b@canb.auug.org.au>
In-Reply-To: <87bnw0ctkb.fsf@x220.int.ebiederm.org>
References: <20140417151245.467efa8bd8d084277fd471c9@canb.auug.org.au>
	<87bnw0ctkb.fsf@x220.int.ebiederm.org>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Apr_2014_11_34_22_+1000_nv42p9rl5.qUrH8Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Apr_2014_11_34_22_+1000_nv42p9rl5.qUrH8Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Thu, 17 Apr 2014 00:18:44 -0700 ebiederm@xmission.com (Eric W. Biederman=
) wrote:
>
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>=20
> > After merging the userns tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >
> > fs/namespace.c: In function 'new_mountpoint':
> > fs/namespace.c:725:9: error: implicit declaration of function 'hash' [-=
Werror=3Dimplicit-function-declaration]
> >   struct list_head *chain =3D mountpoint_hashtable + hash(NULL, dentry);
> >          ^
> > fs/namespace.c:725:28: warning: initialization from incompatible pointe=
r type [enabled by default]
> >   struct list_head *chain =3D mountpoint_hashtable + hash(NULL, dentry);
> >                             ^
> > fs/namespace.c:741:2: warning: passing argument 2 of 'hlist_add_head' f=
rom incompatible pointer type [enabled by default]
> >   hlist_add_head(&mp->m_hash, chain);
> >   ^
> > In file included from include/linux/signal.h:4:0,
> >                  from include/linux/syscalls.h:72,
> >                  from fs/namespace.c:11:
> > include/linux/list.h:637:20: note: expected 'struct hlist_head *' but a=
rgument is of type 'struct list_head *'
> >  static inline void hlist_add_head(struct hlist_node *n, struct hlist_h=
ead *h)
> >                     ^
> >
> > So clearly my merge conflict resolution was not sufficient.
> >
> > I will just drop the userns tree for today.  Please give me some help
> > with the resolutions - or fix this stuff up yourselves.
>=20
> You had this exact conflict succesfully resolved yesterday.  Sigh.
>=20
> Line 725 of fs/namespace.c: Simply need to read.
> 	struct hlist_head *chain =3D mp_hash(dentry);

Yes, sorry about that - fixed for today (hopefully).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_Apr_2014_11_34_22_+1000_nv42p9rl5.qUrH8Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVcciAAoJEMDTa8Ir7ZwVWjYP/2KHa0SrQ7CRNL19tRk8bVsK
gZYx6WblfeJ3hcXrCdgjGttsNGt5wBI7HnhwX88lpaQrMPMngYk+8im5c4gbAR+S
+jQdr+luwc18noN1hmZ0l0/Gs4nCDyXw4xoP2x08JRZXCRhrgPWGOwtodfIoh7EH
75B5LSRV6NTFd4lEYvbI5IWMxFJQl94TlfoHKvliENWk6pQgkMI1+NoYCP9lCD+5
8hqS9PVAix8aONVy7TK4RQX22GtMQTX1gc+mNrRCONFRlTXA+tvlthkoss72acQm
DrmUASYeLK7kXEqLXTi9fXkqInuYMniCG9DAH7vedq30pxDWTgPINhNoTNmZZL9S
AQ6w3UJw6HixoqYzTbh+ghxakTbpzvPM3anOnk0CIO+TWvW1w7hw4McFCLR+jvDp
z0cKuj9UdRpUTmXeZKBEPxvHD28BGL6PVEkAstdNGwrVMkjeCC6EiHJh49kCZKa1
e5xH7lfi2rh7/mXSyBfKA6RwSzcnB9tAvEpv1XKvM4e42J00iNhcElC9MIaGhtjZ
Ff8itlfrh9HdFor1TNMHCGKeKlY30myYjmQvDhDV1bIKbO870ZFEONet+oxFAUKk
EcjEGAMvPQwYm9GdMnuxXLmQ89QdMTV8/mOaohud+Fe1ptyT15Rgq633ian/Jar+
v7DDF3EG28Xgzc0axX6v
=uhRf
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Apr_2014_11_34_22_+1000_nv42p9rl5.qUrH8Q--
