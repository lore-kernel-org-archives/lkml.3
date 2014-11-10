Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaKJEvu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:51:50 -0500
Received: from ozlabs.org ([103.22.144.67]:43136 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbaKJEvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:51:48 -0500
Date: Mon, 10 Nov 2014 15:51:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 sound-asoc tree
Message-ID: <20141110155142.6c76de7b@canb.auug.org.au>
In-Reply-To: <20141110043853.GA25797@kroah.com>
References: <20141110153132.259d49d9@canb.auug.org.au>
	<20141110043853.GA25797@kroah.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Z_SJK+W+TrXiFtOW/h9.Kdc"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Z_SJK+W+TrXiFtOW/h9.Kdc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 10 Nov 2014 13:38:53 +0900 Greg KH <greg@kroah.com> wrote:
>
> On Mon, Nov 10, 2014 at 03:31:32PM +1100, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the driver-core tree got a conflict in
> > sound/soc/intel/sst-haswell-pcm.c between commit 2e4f75919e5a ("ASoC:
> > Intel: Add PM support to HSW/BDW PCM driver") from the sound-asoc tree
> > and commit 3c1af8802e45 ("ASoC: intel: drop owner assignment from
> > platform_drivers") from the driver-core tree.
> >=20
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
> >=20
> > --=20
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> >=20
> > diff --cc sound/soc/intel/sst-haswell-pcm.c
> > index 7eb9afc9b33d,ad21e636edc6..000000000000
> > --- a/sound/soc/intel/sst-haswell-pcm.c
> > +++ b/sound/soc/intel/sst-haswell-pcm.c
> > @@@ -1173,9 -899,6 +1173,8 @@@ static const struct dev_pm_ops hsw_pcm_
> >   static struct platform_driver hsw_pcm_driver =3D {
> >   	.driver =3D {
> >   		.name =3D "haswell-pcm-audio",
> > - 		.owner =3D THIS_MODULE,
> >  +		.pm =3D &hsw_pcm_pm,
> >  +
> >   	},
> >  =20
> >   	.probe =3D hsw_pcm_dev_probe,
>=20
>=20
> Fix looks good, thanks.

I assume that there was a good reason not to farm these patches out to
their respective maintainers?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Z_SJK+W+TrXiFtOW/h9.Kdc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYERiAAoJEMDTa8Ir7ZwVZR4QAJWbwHVPSv4XDAyNFQFgq2Vx
qUPkdKM6/H8evJd+ca/IELjVOBFKDMOyfYny/VYaKoaM2cdMHor9rOjvyDL1ffwk
9hF/m0KUJ7jPck7DPdfVGgV3qUOAr1QzPI0+hZ/KUXAwIAlaAqxJMzY5pNtwNlxJ
Zci7vKz2UOsx4MdsctTeIX3GnXjFDQXDonADiJnbURBAC0bRMAHFP39lOHTN22lT
hcnocbQCyNgkqPvVKQ5ddpdZscRdnMTpRPpdzbTCSIxxCevXwRHVR1Wwu08zlwJl
DvMJCdfz02udg/7eWr0JhUJQuz1VDMpQGDst5iFx+ejTPSJEjVEmUJa56NSbjZb3
Rr38jdI6wqdf4a90TWmBfLqPeO12/vCADjxDCwOh6z/hvi+zSqLj/Mpa3pDwLDsa
jXTk0r2Q1BG7TOe6829TqzCSGYNvqcYZaU9+CsQkwm6+dammv4M0Ltq5Tfc55GW3
oicH8FHOz49xmoqgP06btXdDVrh7kC/uGWo+1rGGhRdjJeDK78vTd9JjY6K+kBCJ
+lmMtj26/8AgQYn9b9MHPkIsn2LEB8D4eTGHMQ+e9zoNvH2XqeDNSlD3gWccWrtN
XJKnKAfAvP4w9hbyXCz49DSMf8QIXmlhkfCjMUSL/bg9VG1x2AlUjzV4xGxqEktO
tCrA2PL4k6hfV1aFRsTf
=sHK4
-----END PGP SIGNATURE-----

--Sig_/Z_SJK+W+TrXiFtOW/h9.Kdc--
