Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbaD1OhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:37:17 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:53991 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbaD1OhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:37:14 -0400
Date: Mon, 28 Apr 2014 10:37:09 -0400
From: Matt Porter <mporter@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>, Barry Song <baohua@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: l2c: prima2: only call l2x0_of_init() on matching
 nodes
Message-ID: <20140428143709.GC7719@beef>
References: <1398644860-22973-1-git-send-email-mporter@linaro.org>
 <20140428142950.GB30292@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20140428142950.GB30292@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 09:29:51AM -0500, Felipe Balbi wrote:
> On Sun, Apr 27, 2014 at 08:27:40PM -0400, Matt Porter wrote:
> > l2x0_of_init() is executed unconditionally within the sirfsoc_l2x0_init=
()
> > early initcall. In a multi v7 kernel this causes bcm281xx and bcm21664
> > platform to fail boot since they have their own pre l2x0 init sequence
> > that is required. Fix this by checking that a matching OF ID is present
> > before calling l2x0_of_init().
> >=20
> > Reported-by: Kevin Hilman <khilman@linaro.org>
> > Signed-off-by: Matt Porter <mporter@linaro.org>
> > ---
> > Applies against next-20140424 to fix the issue introduced in
> > 50655e6 ARM: l2c: prima2: remove cache size override
> >=20
> >  arch/arm/mach-prima2/l2x0.c | 16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/arch/arm/mach-prima2/l2x0.c b/arch/arm/mach-prima2/l2x0.c
> > index 09f68f0..1c2ed15 100644
> > --- a/arch/arm/mach-prima2/l2x0.c
> > +++ b/arch/arm/mach-prima2/l2x0.c
> > @@ -8,10 +8,24 @@
> > =20
> >  #include <linux/init.h>
> >  #include <linux/kernel.h>
> > +#include <linux/of.h>
> >  #include <asm/hardware/cache-l2x0.h>
> > =20
> > +static const struct of_device_id sirf_l2x0_ids[] __initconst =3D {
> > +	{ .compatible =3D "sirf,prima2-pl310-cache" },
> > +	{ .compatible =3D "sirf,marco-pl310-cache" },
>=20
> that same commit removed these two from DTS, did you test with old DTS,
> btw any chance ?

The "fix" is tested against bcm281xx and bcm21664 as that is what the
l2c cleanup breaks in -next. As mentioned, I don't have the sirfsoc h/w
so this first attempt at a fix also breaks their platform. It can be
addressed by adding those platform specific compatibles back to the dts,
of course.

I'd much prefer that the sirfsoc folks fix this...it's going to break
other platforms in a multi v7 build.

-Matt

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXmeVAAoJEOfTILNwq7R4Al4QANF2bjSoFYe/uWFAn8tK7ZFP
4LP4iStFgETDGOJjOq6uZPCX4QfDGRY4+rAtGtM5C15lxkDurLWfFAZ+zKv597lp
v2J4cjRLw3emRNgPXKJ1361qSvd1WFWLbRa5xD3lV3x4669rFpByTXiibUg2ezbB
J4IP4yf6FdU+000NDqwmkZjoPwpgGbGVhuviZZHWvCUJWXiat1xmLF2ij2nXQlOA
DqJvHUwi2fVygVfGrST7caiCsAw71S3KIVjScKSkUDRUfxJ1WYgH/R26MvzcbG2z
aoX7AB9sbxeXC+f0fcWYMDSWnIanVnB/JXF7CjKHTXstLGoZioX9PiB4BLzl88fW
hI74XZ2mhOKWw5hynzvCsZY8HvAnbAVPHja9OqJ9ucgTHd1UqoRxaR4YVG2o779y
SbwPp6NuzkJKPesnTOtTwuhKHgZTP7LEgQexNjGMZ9xMMBXYL8TvjmtuEskZVty3
l8Hi+cmsKq4T2yzS0uecrYoi8fFTvXSugjMnVIyD7R3BJhy4D+e5uJu2PcmdqNS6
3BrZoc6kPRjm6fWDx7gnzoUQF6ozhSwS0kgcMTBQoFKWXW3F7r4F+HoISfkfLl33
rCIVjtzDsN0w2vJKGfk8LeORGPMn52MIp1zrvMnCWaGCp1dU9B4oaclV3TVAMpe/
7+BT8+hjQ8s2emIM7VmC
=Z4+D
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
