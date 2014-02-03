Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaBCTkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:40:08 -0500
Received: from top.free-electrons.com ([176.31.233.9]:52636 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752559AbaBCTkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:40:05 -0500
Date: Mon, 3 Feb 2014 20:38:02 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 8/8] ARM: dts: sun7i: Add ethernet alias for GMAC
Message-ID: <20140203193802.GE25625@lukather>
References: <1391398346-5094-1-git-send-email-wens@csie.org>
 <1391398346-5094-9-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qFgkTsE6LiHkLPZw"
Content-Disposition: inline
In-Reply-To: <1391398346-5094-9-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qFgkTsE6LiHkLPZw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 03, 2014 at 11:32:26AM +0800, Chen-Yu Tsai wrote:
> U-Boot will insert MAC address into the device tree image.
> It looks up ethernet[0-5] aliases to find the ethernet nodes.
> Alias GMAC as ethernet0, as it is the only ethernet controller used.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/sun7i-a20.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index 65fb8d0..c48fb11 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -17,7 +17,7 @@
>  	interrupt-parent =3D <&gic>;
> =20
>  	aliases {
> -		ethernet0 =3D &emac;
> +		ethernet0 =3D &gmac;
>  	};

I'm not very fond of this patch.

People might rely on the fact that ethernet0 is actually the emac, and
are expecting u-boot to fill the ethaddr variable to the emac, and not
the gmac.

Since u-boot is totally able to deal with several ethernet addresses,
please add it as ethernet1.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--qFgkTsE6LiHkLPZw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS7/AaAAoJEBx+YmzsjxAgHMUQAIXqo3N3GOgg00+H22oTt0F9
2ZjCZhvbb9wdXzhl6NwzSeW9eDSfzQgECvaaw/AtPKR9dViI4Faw7QJ+JGrkYino
X5oOK+iI3dNLUDgfPmpK8s1TXtxaNdNzlPs9i9ZG5cR2Hyy/e2prXlfk6j2Qcr1l
u+NjPLG408A5aynGdr2TBSGuNfWobxkcZoNpZx4+IbSVGZ+O/QfIzjAQwYMM0qV/
vvWt1CY7r8CYqMKrtPtO06hrif5Jq5Dd8N4y1FsB5+bMQJnzgkFUv1+4ZJpv58aN
ktCjr5XeQspqr/KvGWuxFKXAalqBe8KCm2RAC7W2H2PDmSmBgo+/KLePYMxBBH2V
beX2sCDXxMHQIDXZWcm6VGmilvik04kqGpRQUYF/QplumLg1cT6tfV+TbKQYo7qC
KxO/wquXxByeBc2IRD8KpNVupUe7PUqweG/zhck1QPL/qiSl1KrxENUGUBMdDlEK
RtnunTxG83LTLRU3uzgebvgzv3t7Pv1zS/bZqlp4dsfgzlHtEI+lptCaUXClnt8r
IySR4DqKE8bWn4jrWNIaym+U3Qoat0EfpsMRUi2nqN2xlzle9Kod0lGRjtT+Wfkf
oeZAYibIK+TqyxDrUUfVPc+2ENitbGaleKnl0wH4iISpvxRz6xl640kcf/E7Z1+s
w6coxfN6mX0EeHKvupQy
=PYqa
-----END PGP SIGNATURE-----

--qFgkTsE6LiHkLPZw--
