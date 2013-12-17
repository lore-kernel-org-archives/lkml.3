Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3LQNTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:19:44 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:48967 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3LQNTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:19:42 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
Date: Tue, 17 Dec 2013 14:19:38 +0100
User-Agent: KMail/1.13.7 (Linux/3.12.0-5-generic; KDE/4.11.3; x86_64; ; )
Cc: David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <201311201430.56135@pali> <20131215230004.97d14ce7.akpm@linux-foundation.org>
In-Reply-To: <20131215230004.97d14ce7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5643856.4tIZ9J6O1x";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312171419.38790@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5643856.4tIZ9J6O1x
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 16 December 2013 08:00:04 Andrew Morton wrote:
> On Wed, 20 Nov 2013 14:30:55 +0100 Pali Roh__r=20
<pali.rohar@gmail.com> wrote:
> > Both proc files are writeable and used for configuring
> > cells. But there is missing correct mode flag for writeable
> > files. Without this patch both proc files are read only.
> >=20
> > diff --git a/fs/afs/proc.c b/fs/afs/proc.c
> > index 526e4bb..276cb6e 100644
> > --- a/fs/afs/proc.c
> > +++ b/fs/afs/proc.c
> > @@ -147,11 +147,11 @@ int afs_proc_init(void)
> >=20
> >  	if (!proc_afs)
> >  =09
> >  		goto error_dir;
> >=20
> > -	p =3D proc_create("cells", 0, proc_afs,
> > &afs_proc_cells_fops); +	p =3D proc_create("cells", S_IFREG |
> > S_IRUGO | S_IWUSR, proc_afs, &afs_proc_cells_fops);
> >=20
> >  	if (!p)
> >  =09
> >  		goto error_cells;
> >=20
> > -	p =3D proc_create("rootcell", 0, proc_afs,
> > &afs_proc_rootcell_fops); +	p =3D proc_create("rootcell",
> > S_IFREG | S_IRUGO | S_IWUSR, proc_afs,
> > &afs_proc_rootcell_fops);
> >=20
> >  	if (!p)
> >  =09
> >  		goto error_rootcell;
>=20
> Please send a signed-off-by: for this, as per
> Documentation/SubmittingPatches, section 12.
>=20
> David ack?

Sorry, I forgot to add Signed-off-by. Here it is:

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart5643856.4tIZ9J6O1x
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKwT2oACgkQi/DJPQPkQ1LixwCgmgqoqqOoAbs+pR3IGMsS/QSV
uhAAn2e04uR46eGZvg5cE+WMiEf670Ov
=r24O
-----END PGP SIGNATURE-----

--nextPart5643856.4tIZ9J6O1x--
