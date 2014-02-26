Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaBZOM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:12:57 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:56343 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaBZOMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:12:55 -0500
Date: Wed, 26 Feb 2014 15:12:44 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm,renesas-tpu: Add dependency on HAS_IOMEM
Message-ID: <20140226141243.GE29779@ulmo.nvidia.com>
References: <1391172318-17853-1-git-send-email-richard@nod.at>
 <20140226120800.GA28939@ulmo.nvidia.com>
 <530DF4E7.1060900@nod.at>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kA1LkgxZ0NN7Mz3A"
Content-Disposition: inline
In-Reply-To: <530DF4E7.1060900@nod.at>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kA1LkgxZ0NN7Mz3A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2014 at 03:06:31PM +0100, Richard Weinberger wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> Am 26.02.2014 13:08, schrieb Thierry Reding:
> > On Fri, Jan 31, 2014 at 01:45:18PM +0100, Richard Weinberger wrote:
> >> On archs like S390 or um this driver cannot build nor work. Make it de=
pend on HAS_IOMEM to bypass build failures.
> >>=20
> >> drivers/built-in.o: In function `tpu_probe': drivers/pwm/pwm-renesas-t=
pu.c:421: undefined reference to `devm_ioremap_resource'
> >>=20
> >> Signed-off-by: Richard Weinberger <richard@nod.at> --- drivers/pwm/Kco=
nfig | 1 + 1 file changed, 1 insertion(+)
> >=20
> > In the long run I think it might be better to add a dummy implementatio=
n for devm_ioremap_resource() in order to make it build properly even for a=
rchitectures where it isn't
> > implemented.
>=20
> And what should devm_ioremap_resource() or in general ioremap() do on arc=
hs without
> iomem?
> BUG()? Returning a random error and hoping that the driver handles it cor=
rectly? :)
>=20
> IMHO such a dummy implementation does not make much sense.

Well, it could still be useful for drivers that want to support
COMPILE_TEST. If we just make it return any error drivers should simply
refuse to probe just like if the error was genuine.

Thierry

--kA1LkgxZ0NN7Mz3A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDfZbAAoJEN0jrNd/PrOhbRYQAJiD67f0HDwdEibVTdSis2oD
eU5Ajo8RJ4OoeWNLxEMAgg/2yBU4iwKx51Pt14oM81gBzTFNcR5mS0l+wFloVnXg
pzgGMfLXtg82FYl7KdnQ2802eQzj+CwHMzTs6din9m2Z/9dFWxWeMKRSvsCwVza5
PKp5oJpIHQntjvjfcRku0uJl9HnynFecfRDApJTusJELxZcFuUwAjl+pBeCPJ4p7
H1YRZlDWVUES2aVbiR1X16XZdqCLHd5Azq49IwUAVNy00nCy1TYIuJ1tE0APXk3C
4HNR41oTBrypkdFECO5h4HKX68jnZPzFAs7DLrIHRKoeB07ds8Gi/RW/6plciG2+
AgSjql89djFjmDyE5kaO8AJnh3gwJRW9hbaD0I2i2SAL7suVFG5TkOSEvUX8ZDpF
4SgFz4SZfL0whWmN/UWQKHvVpLryoBfFHKzwr0LAvHfmfkVxEyjpjXxPZoAJSaA7
iZ9pVh+wwy+cSFL/FjgyxaVg/EN9SPx3ZBP9OZ7qdjJ+/RLAEOMjKiP7EjZE3+Vo
NKsyDHRkY6ujf++VY0igJfxih2EKQKkOKM7/y3HnEMuRzH8xAOJqdiZmWAouCibh
E8dJt2zz83WRxYSy/HrcY1ucc1toI06OuqQWZmmUZt2YSwQgEbvA0fFhGJ8HZR6f
xx+wOFWkCbCFjNc3GsSY
=Jh9N
-----END PGP SIGNATURE-----

--kA1LkgxZ0NN7Mz3A--
