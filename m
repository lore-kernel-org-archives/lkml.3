Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaFEWMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:12:20 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47951 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbaFEWMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:12:16 -0400
Date: Fri, 6 Jun 2014 00:09:28 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Bresticker <abrestic@chromium.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pinctrl: Add NVIDIA Tegra XUSB pad controller support
Message-ID: <20140605220927.GB28817@ulmo>
References: <1401894990-30092-1-git-send-email-thierry.reding@gmail.com>
 <5390A426.1050307@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <5390A426.1050307@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 11:08:54AM -0600, Stephen Warren wrote:
> On 06/04/2014 09:16 AM, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > The XUSB pad controller found on NVIDIA Tegra SoCs provides several pads
> > that lanes can be assigned to in order to support a variety of interface
> > options: USB 2.0, USB 3.0, PCIe and SATA.
> >=20
> > In addition to the pin controller used to assign lanes to pads two PHYs
> > are exposed to allow the bricks for PCIe and SATA to be powered up and
> > down by PCIe and SATA drivers.
>=20
> > +#define TEGRA124_GROUP(_funcs)						\
> > +	{								\
> > +		.num_funcs =3D ARRAY_SIZE(tegra124_##_funcs##_functions),	\
> > +		.funcs =3D tegra124_##_funcs##_functions,			\
> > +	}
> > +
> > +static const struct tegra_xusb_padctl_group tegra124_groups[] =3D {
> > +	TEGRA124_GROUP(otg),
> > +	TEGRA124_GROUP(usb),
> > +	TEGRA124_GROUP(pci),
> > +};
>=20
> I'm not sure what this set of groups is for.
>=20
> pinctrl muxes functions onto groups, so given that each pin in padctl is
> individually configurable, we need 1 group per pin. As far as I can
> tell, tegra_xusb_padctl_get_groups_count()/name() implement this
> correctly, and this array isn't used anywhere?

Indeed, there seems to be no need for this anymore. Probably left-over
=66rom some prior version.

Thanks,
Thierry

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTkOqXAAoJEN0jrNd/PrOh5xoP/1D2s4fU3sPViB/XON+IskLL
C7dWRWBN3jGQvW5TQpmlDW9ftoU5xA2Dh7zEEmbQOzlvy6cLSy2buEfMlZ+2mHlV
3mskZBjEQsn9hdUMBFavHy0I8uRIqcYAPXTOeXVRFEoqfKXh/dw73ob5XvWIzgA3
eMvgcxYi1LdYTpTWs1haj7iTLSF7wmd3dp8cIzu1QQUtJoXzGC8LCFBEwFmEKZYJ
11ZOgAuQ5Kh3VWwQ4ql/QdfOv1aiPMldo8uhkVLVTGTMwCKLjYUYbV625vyRnTz2
uotTxobfqHs8W+Z6tRHtt0WrFENajCNwzw41n7ckfrJZIFrct/foLSbCF/XpS/73
4lYvo087WlTMgdPUjGE0ThcHgdIZ13ZgiKwp5HXZOolKJ2Bqbky4Sn94O9K3iQ1e
GPAmzTzdLBhf85bGRvjEK+ExfVoFwcGqf8cqZ/NI8evy9pGBXCk5QIUwxukfJL9E
5g2IEVg/kE5WcliemWZMjoJwPVkGE5mRWU78KAntmHoBmRLGTwNItzOTeBsAdbEq
mGS3xP3POob4nYyZ4Wl2mHtpPTXD/LOonoxyYAIwTGTIZ5NgOm7/GiwzydWFiDk2
et7fc19qL89zqTJB2CPMEsWSzKX34Q5G0Z58O9XCyp71/YTgcCZhJmxtZZbCl/sM
OxKuLM5pQTd4II3lvOvj
=RURV
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
