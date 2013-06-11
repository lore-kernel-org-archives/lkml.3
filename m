Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3FKKsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 06:48:08 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:36291 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3FKKsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 06:48:06 -0400
Date: Tue, 11 Jun 2013 12:48:01 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xorg-devel@lists.x.org
Subject: Re: [PATCH 2/6] gpu: host1x: Fix syncpoint wait return value
Message-ID: <20130611104800.GA29395@mithrandir>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
 <1368791388-31441-3-git-send-email-amerilainen@nvidia.com>
 <20130526101243.GB1652@mithrandir>
 <51A30372.6080907@nvidia.com>
 <20130528103927.GB11547@mithrandir>
 <86y5ay6hrn.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <86y5ay6hrn.fsf@miki.keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2013 at 01:12:12PM -0600, Keith Packard wrote:
> Thierry Reding <thierry.reding@gmail.com> writes:
>=20
>=20
> > That doesn't sound right. Maybe drmIoctl() needs fixing instead. Looking
> > at the history, drmIoctl() was introduced to automatically loop if a
> > signal was received (commit 8b9ab108ec1f2ba2b503f713769c4946849b3cb2).
> > However the ioctl(3p) manpage doesn't mention that ioctl() returns
> > EAGAIN in case it is interrupted by a signal.
>=20
> EAGAIN is being returned when the GPU is wedged to ask the application
> to re-submit the request, which will presumably be held until the  GPU
> is un-wedged.

Isn't that a bit risky? What if something special needs to be done to
unwedge the GPU other than re-submit the request, or if it just can't
be reasonably unwedged. In that case drmIoctl() will keep looping
indefinitely.

If the above is indeed the expected behaviour for drivers, then we need
a different error code for the SYNCPT_WAIT ioctl. EAGAIN is the best fit
and anything else doesn't quite match the use-case. A different option
might be not to use drmIoctl() on Tegra.

Thierry

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtwBgAAoJEN0jrNd/PrOhivUP/A5yqr0FYcREdBaHC+eLGz7v
Vlvq1uoeTm8VALGb2gJe1ZC1jyIwsif9yHYyw7YRlikXwN/dl7WXqaisYH1NqbaJ
pnfwzLae3CuIM97PYm89HmqbnVNUAXfBwPZonE6+shqIX3dV0n200Qw2o2chb5/3
xLmXUnI2qmlmJ8TpV10nIhhgozY6ZDGkGmS95gjXLIxZg6rCWJBEWpQ7zSHQO7zQ
MmHB0ZFppVRLX4Ww3KXvzVHDZSicPU2f4bxrYo1qfK6Pg4+V7JUZHqghz3hqWglZ
qekD4Zn0/7rdwj4jw9X07IVxgI/KAm0vFyX7UYvf/iWLggrdj7AAGxjwhOx7/U63
f3uYTiO1fKLZ4dxYvuVuFVK7Jg+ET+BEpk4FAtrciOZiMUACqc4WqC/nEvqgnS7x
+gaOgIxDVkUtjMdTb8VPNVwgDaTORblclglZQv/JOqbPtBXlPNhigw3iEfFqXayz
Hq94l9N4UwpEl5G+E5Y4ctMOigB5c5T1Z4IfQorFIPBA4bSmzNNqXlfiDyA2OG23
f5BbFiYa3Zu39FpTNQLr2xKwG2cOeZ2j56rWFQIz5/yPHm7N84zFqvToJQiA/9W/
MC11hO7ZJhhY1oGeslTLM1yjCu0eP6/dXu8Q6FFkoQvBkCSTULt8Lmp81oo8/rpl
TSBo6+mxYeUgg1boZwFa
=ozms
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
