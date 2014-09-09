Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaIIPJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:09:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59580 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaIIPJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:09:18 -0400
Date: Tue, 9 Sep 2014 10:09:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Robert Baldyga <r.baldyga@samsung.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 1/3] usb: gadget: f_fs: fix the redundant ep files
 problem
Message-ID: <20140909150901.GL6151@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410243797-9719-1-git-send-email-r.baldyga@samsung.com>
 <1410243797-9719-2-git-send-email-r.baldyga@samsung.com>
 <20140909150425.GK6151@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GeDkoc8jIzHasOdk"
Content-Disposition: inline
In-Reply-To: <20140909150425.GK6151@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GeDkoc8jIzHasOdk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 10:04:26AM -0500, Felipe Balbi wrote:
> On Tue, Sep 09, 2014 at 08:23:15AM +0200, Robert Baldyga wrote:
> > Up to now, when endpoint addresses in descriptors were non-consecutive,
> > there were created redundant files, which could cause problems in kerne=
l,
> > when user tried to read/write to them. It was result of fact that maxim=
um
> > endpoint address was taken as total number of endpoints in funciton.
> >=20
> > This patch adds endpoint descriptors counting and storing their address=
es
> > in eps_addrmap to verify their cohesion in each speed.
> >=20
> > Endpoint address map would be also useful for further features, just li=
ke
> > vitual endpoint address mapping.
> >=20
> > Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> > Acked-by: Michal Nazarewicz <mina86@mina86.com>
>=20
> This is a fix, which sits in my 'fixes' branch. You can't include it
> here. This series should be rebased on top of my 'next' but it should
> not include any fixes, only new code.
>=20
> This is why we generally ask people to split the series up into fixes
> and new code and not make them depend on each other. You need to
> remember that, rather frequently, my 'next' branch is based off of -rc1.
>=20
> I only merge an -rc back into my 'next' when the conflicts start to
> become non-trivial because of all the dependencies people add :-)
>=20
> I'll see if I can fix this up myself, but if I can't, then we either
> postpone this series to v3.19 or you get it done properly and without
> any cross-dependencies :-)

alright, so patch 2 I can apply. Patch 3 I really cannot because it
depends on epaddr_map to create proper files on the filesystem.

I'll see if I can wait for -rc5 before merging patch 3, but it's likely
it'll slip into v3.19.

--=20
balbi

--GeDkoc8jIzHasOdk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDxgNAAoJEIaOsuA1yqRE9UQP/0mai4F6bnEB6NDbu629RvaU
WKkvRx9cYXuzB+h9qRWTJtykqGoeqTAIHmHDOiQ3xNaxqY33FTZ4VsmTt+5yNcqc
vSqSb1QRb5dl1pw84AXDOVlMAqLJRUBwaOKYg071BWNJbJhlKRCF45id9G3IFARm
G4dMbRSnnRwg2ajsT2P5jYmNd4mx6sXDxRFPMWrGCTV0JXXOMOA9x3EyYypgNFJO
EBynfzouHa/MJ5bgz3RAKJgKtuRAbvDMApO3GepEJSxSwFFeKjTdWNtyLiurimST
MWmqwIJp1JOMNIgsXwwdNpwct5eLd185r5vkcE/5AFG2LYKwylZCZb0jQQ7nbYE8
E3j6c79XS2Vr/hFvfCzgAHKpwilfA9suC3plaTpgGgIzdFmJdRLutGBlrX0RPvoC
OJZn52jlZ65HVV/kYRfMxRHvFBpbaBmYNhMSwVw5fME0xhWG3se07Aq4umq5D7R5
rWLLBehftCIAAS3ftiFkQNVMe5NVWEe3cXhpDffcg2kTZb/QE+j3v5KJBKtmsnTH
QK2fSyTtTUxBaFrPE9PNya67Uugwg7fPM3QPWA9657HdT5n5NAryXdz3IpQRiKOe
E83ETOXuhV1uZ3qEVdfKyxzH1+W7hJM0p9wCoNDmwayhJxJo4r/PIn+qYOyXcPoV
7sbJ66lUHgh2N21Du1Cp
=W7C/
-----END PGP SIGNATURE-----

--GeDkoc8jIzHasOdk--
