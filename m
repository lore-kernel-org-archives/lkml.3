Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048Ab3BMNyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:54:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57280 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934025Ab3BMNym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:54:42 -0500
Date: Wed, 13 Feb 2013 13:54:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regmap: irq: Add support for interrupt type
Message-ID: <20130213135440.GI5062@opensource.wolfsonmicro.com>
References: <1360761290-15976-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HkMjoL2LAeBLhbFV"
Content-Disposition: inline
In-Reply-To: <1360761290-15976-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HkMjoL2LAeBLhbFV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 13, 2013 at 06:44:49PM +0530, Laxman Dewangan wrote:
> Most of the MFD module have the GPIO and gpio interrupt is
> enabled/disabled through the rising/falling edge type. There
> is no specific mask enable/disable registers for GPIO submodules.
>=20
> Extend the regmap irq to support the irq_set_type() so that
> gpio submodule of MFD devices can use the regmap-irq framework
> for their interrupt registration.

This commit message needs to be rewritten for comprehensibility, MFD has
nothing to do with this - it's something to do with your particular
hardware that you're trying to support.  Describe the hardware feature,
not the subsystem your hardware happens to be used in.

> +	switch (type) {
> +	case IRQ_TYPE_EDGE_FALLING:
> +		d->type_buf[reg] |=3D irq_data->type_falling_mask;
> +		break;
> +
> +	case IRQ_TYPE_EDGE_RISING:
> +		d->type_buf[reg] |=3D irq_data->type_rising_mask;
> +		break;
> +
> +	case IRQ_TYPE_EDGE_BOTH:
> +		d->type_buf[reg] |=3D (irq_data->type_falling_mask |
> +					irq_data->type_rising_mask);
> +		break;

This should handle the case where an output type is not supported, for
example if the device only supports falling edge.  It'd also seem
sensible to have an explicit value to set for each trigger type rather
than reyling on the device using separate bits for everything - you
might see an encoding like 0 for falling, 1 for rising, 2 for both and 3
for level for example.

--HkMjoL2LAeBLhbFV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRG5qhAAoJELSic+t+oim9ZngP/3KMOeQLqLeByKeczMby2dsr
ix9eQEk4phVGdhumIZjvz1lVBXJZL+hJENo70BFoF8xEptmU7tFWiu1dxDOW4LBU
nfn3xKEDwJH0z741WnJN03RRd79bNeA5Ny+WI62X+w17Y4j64aTHcfadEN2fsFEU
cU1KMbxJjOdo9WukUESOEn1sKtF+FYFZebuVSKr9jJW4n9OyigPru+WKFo5dWqjB
FgF544vQ1eWdF8OSApUjGVT8sZQPKLvh2u/kO7FHcUTF3wlPM5dG8qUckPv+DR81
ijJ41i1DSym1PlkLlLXONTx9nj4gL5LH1sZ0pIWBzGHBNiuv3WUNyMcUmrq3s6jY
ADine/09OmaLbYr+JbA/OmdRr13zyzZCj/XgZg8rk5/4dWnNjl69RxCQhSTkToUR
reKqMqTG4lRdr00Ul2C7z52x+UQF6zfuklyENMeB0Gt/6RRE0PkDFRAroWHGUUDT
QrSEeLtrJyG1MLrUsAi/W/m96FJR9HIyax2Wqu0iA/dy1zuFgQV3juLyWnb8H+nC
TAA61cP+NivdthBsmJkRNpwn5C0qj5tWfWl1LYQomnLeDvHfdW5cViscNeJH3Jrv
0hV/zNMzoL55GHJhqWSUQD9VC1qI5wGwNfvZunXNCqtQu02kFYNxCTeGTUGfeh1x
IyxVrl5MOxpI1TgRAuVM
=ytOf
-----END PGP SIGNATURE-----

--HkMjoL2LAeBLhbFV--
