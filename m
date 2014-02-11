Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaBKUrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:47:48 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:39432 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbaBKUro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:47:44 -0500
Date: Tue, 11 Feb 2014 21:47:39 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, josephl@nvidia.com, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: dalmore: fix irq trigger type
Message-ID: <20140211204737.GA1895@mithrandir>
References: <4fcfcfdbc86c37c6d47ec32cdbd987f3b406e9b5.1392147256.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <4fcfcfdbc86c37c6d47ec32cdbd987f3b406e9b5.1392147256.git.stefan@agner.ch>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2014 at 09:11:32PM +0100, Stefan Agner wrote:
> Trigger type needs to be IRQ_TYPE_LEVEL_HIGH since the interrupt
> signal gets inverted by the PMC (configured by the invert-interrupt
> property).

Isn't the reason the other way around? The PMIC generates a low-level
interrupt, but the GIC can only be configured to accept high-level (or
rising edge) and therefore the nvidia,invert-interrupt property needs to
be set in the PMC node?

One nitpick below.

> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/t=
egra114-dalmore.dts
[...]
> @@ -888,8 +888,9 @@
>  		palmas: tps65913@58 {
>  			compatible =3D "ti,palmas";
>  			reg =3D <0x58>;
> -			interrupts =3D <0 86 IRQ_TYPE_LEVEL_LOW>;
> =20
> +			/* active-low configured by PMC invert-interrupt */
> +			interrupts =3D <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;

I'd prefer to keep the properties grouped as before. interrupts is a
"client" property, whereas #interrupt-cells and interrupt-controller
are "provider" properties.

And I think the comment would be more appropriate in the pmc node, for
the same reason that I think the commit description isn't entirely
accurate.

Thierry

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+oxpAAoJEN0jrNd/PrOhdU8P/03MrFNVoZ5aaZmL5j3PaeRg
WuF5umaGFo9/LJ5fouFq4RtLEPlTIApQPZnn53r+OmlcTy+iVOQHbrs4/RHXocVz
7+2D67jE5/J/lURtvrB/6GnMGeoTEqT+EhdTboIBZ9xHtAScU3BXXtvQs1NVmAEX
XYPU2TVKkusajqtBjSeD97I+Zy+v+j2kVUV+Cv7L5ynrat93HEGsbV940bztcSUT
Y1N+IPoankMa1qV0a4yNfM13LF0mR09JZ/eWearqjPa+4nmggUPp/7yVE+Nksgnn
6tZydw3keR2FqYzkxda3tknCtdoQ9mfKEJWHkJxmHEUYTh/D9eF5HgeBomWrAHZC
XRPuA40H7VuO8buSi7XeU+v0a4UXbNiaJEZUkGvQZVa/cseZS6vZBhuBBIPdIGiF
X6CjF/F1r4hhtlazUmcGKCSljuxxISOagmdiMux83MFrfGiEvEvtqEfEw66sD65n
d2sZSK7UBd93re3QYgHhCD4dYJ8uqtSQkAxf13YsPW99li6zBDy4fvOGQWuc/k6L
GMpWCu3Y10pI6dpwJQpu4oS+v7WLdjeDNj7XnrSMCTkEWSX2olBmxnWyNUdgAXvA
qnSLEQYxgldmFFt3G8YXpH1r31dL41Lh8m/gENoQq5033f85g+/sqB9H/DGrobSC
/wejX6EFUwDBqVaUo1y7
=hSq5
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
