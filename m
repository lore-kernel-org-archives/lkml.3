Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161595AbaKNRmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:42:01 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51270 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161175AbaKNRl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:41:59 -0500
Date: Fri, 14 Nov 2014 11:41:52 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <chris@printf.net>, <ulf.hansson@linaro.org>, <tony@atomide.com>,
        <devicetree@vger.kernel.org>, <nsekhar@ti.com>, <afenkart@gmail.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 2/3] mmc: omap_hsmmc: add tuning support
Message-ID: <20141114174152.GM11538@saruman>
Reply-To: <balbi@ti.com>
References: <1415883379-19654-1-git-send-email-kishon@ti.com>
 <1415883379-19654-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TXIPBuAs4GDcsx9K"
Content-Disposition: inline
In-Reply-To: <1415883379-19654-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TXIPBuAs4GDcsx9K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 13, 2014 at 06:26:18PM +0530, Kishon Vijay Abraham I wrote:
> @@ -233,6 +263,48 @@ struct omap_mmc_of_data {
>  	u8 controller_flags;
>  };
> =20
> +static const u32 ref_tuning_4bits[] =3D {
> +	0x00FF0FFF, 0xCCC3CCFF, 0xFFCC3CC3, 0xEFFEFFFE,
> +	0xDDFFDFFF, 0xFBFFFBFF, 0xFF7FFFBF, 0xEFBDF777,
> +	0xF0FFF0FF, 0x3CCCFC0F, 0xCFCC33CC, 0xEEFFEFFF,
> +	0xFDFFFDFF, 0xFFBFFFDF, 0xFFF7FFBB, 0xDE7B7FF7
> +};
> +
> +static const u32 ref_tuning_8bits[] =3D {
> +	0xFF00FFFF, 0x0000FFFF, 0xCCCCFFFF, 0xCCCC33CC,
> +	0xCC3333CC, 0xFFFFCCCC, 0xFFFFEEFF, 0xFFEEEEFF,
> +	0xFFDDFFFF, 0xDDDDFFFF, 0xBBFFFFFF, 0xBBFFFFFF,
> +	0xFFFFFFBB, 0XFFFFFF77, 0x77FF7777, 0xFFEEDDBB,
> +	0x00FFFFFF, 0x00FFFFFF, 0xCCFFFF00, 0xCC33CCCC,
> +	0x3333CCCC, 0xFFCCCCCC, 0xFFEEFFFF, 0xEEEEFFFF,
> +	0xDDFFFFFF, 0xDDFFFFFF, 0xFFFFFFDD, 0XFFFFFFBB,
> +	0xFFFFBBBB, 0xFFFF77FF, 0xFF7777FF, 0xEEDDBB77
> +};

yet another feature we would've gotten for free if we were already using
sdhci. This is just a copy of what's on sdhci-msm.c, probably because
they license the same IP we do.

It would be much better to just convert omap-hsmmc.c into sdhci-omap.c
much like it was done for 8250-omap.c, with the added benefit that this
will incur no userland regressions due to devnode names.

--=20
balbi

--TXIPBuAs4GDcsx9K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUZj7gAAoJEIaOsuA1yqREmbYP/A3aKmMOFLbdhe5G3WwrCG8U
e4vP9xY4VoQ4ItZKDaj3vG7F2BXL7aVV975ksd8k+zGFN+g+9OxXxNFeVNF8/TgY
jDPW8VGwfA9XolLVDj2faURDRMmx/VgDK9nlUOsldIpRfIeDQywidzZwBND+SQZf
6Blnn/YaJEMh8DhJiRHufHJltohvPinJ/n5qTv9ZL3Ql8ND/UC3nK+XOoHueCUOU
bDzXjssTP2Xl5paHcHmuUUL9UgmXTaA0rJrH9MS68hAS4S21uUfHX06JV4QuZlMH
9t+roZceCljjYSL+bP3jsc+Nxizm6Q+k0wkYo964G45AvxnG3138tSmPx28In8qQ
5Ip4a0ODdLrHj98qWHl/+KqyuEbRoyLNX7llJuVmMRfu5FWufIJEtBnNglT3hg5u
05EqZRVmp4+aBj1T4oADcWQSub6/a91OnX0wZEYTwkuypoqTmiO77bhUMt2hqAcP
YYD+ffovmxXoGFJgUjuTjvJ2npIstyZeVnNCal2ePliDxP5AhUndBvKtEo+oT8z4
/1XirQjBvA47E/gd9K8AgRJ6Rkp3EXPUXLjuLAOLbFY+RvEmFwNgKD2/5ku5/5EB
ymVHivyIIbIByWtDwNJBl4l/1Sld0FtMmaxTX7ryHLm0JiQczJkpp8AnwImUxxh4
FReNNPFeNdOH2wTGj+0o
=vXtc
-----END PGP SIGNATURE-----

--TXIPBuAs4GDcsx9K--
