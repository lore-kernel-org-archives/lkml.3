Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaKFMML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:12:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45677 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaKFMMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:12:08 -0500
Date: Thu, 6 Nov 2014 12:11:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        eparis@redhat.com, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20141106121143.GW8509@sirena.org.uk>
References: <5458EC40.5020807@gmail.com>
 <283051037.h5QtGpv3rn@sifl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lQcP9vuZCkvmDKre"
Content-Disposition: inline
In-Reply-To: <283051037.h5QtGpv3rn@sifl>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] include/linux/audit.h: Move dummy audit_file() from
 !AUDIT area to !AUDITSYSCALL area
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lQcP9vuZCkvmDKre
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2014 at 12:43:01PM -0800, Paul Moore wrote:
> On Tuesday, November 04, 2014 11:09:52 PM Chen Gang wrote:
> > audit_file() is related with AUDITSYSCALL, not related with AUDIT, so
> > need move dummy one from !AUDIT area to !AUDITSYSCALL area. Or it will
> > cause issue if CONFIG_AUDIT with !CONFIG_AUDITSYSCALL.

> > The related error (with allmodconfig under tile):

> >     CC      fs/open.o
> >   fs/open.c: In function 'SYSC_fchmod':
> >   fs/open.c:530:3: error: implicit declaration of function 'audit_file'
> > [-Werror=3Dimplicit-function-declaration] audit_file(f.file);
> >      ^

> What version of the kernel source are you looking at?  I don't see the=20
> audit_file() function anywhere ...

This issue has been breaking ARMv8 defconfig builds in -next for a few
days now.

--lQcP9vuZCkvmDKre
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUW2V+AAoJECTWi3JdVIfQjoMH/iut4yNvwHvDPA2h5paREzVg
G6GfFRsRlrxCy6KxtPDJpoO/jfJpwiU51u3n83pC7xoi3rrq35EmUB9WhMYONx+R
qB/skW/Vm6i8AghJkFT//nsQ7+rIWhr7zyvpsgDw2zrX2v7k5eNDuyYq9SzVVssO
eQ08NXvGErI5rIdT9sUzZjNf3KKjjsjEJygD/2ehgbwGx7OS6fHv7uH6a8+Wq8nW
Oo7p5k5pSRNWIK6nBnfW+Dm600r9tNDpNRPszdtRLFDB1vP9QxfA9L8Vq6YnaJ9u
bKeFbrBp+7hsLAhZBlX2BVhhtoLRIfWQuZ4gzZmBIvTgc5JPVs86E0QVu3ZsQxE=
=yO2z
-----END PGP SIGNATURE-----

--lQcP9vuZCkvmDKre--
