Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaANOUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:20:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54001 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaANOU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:20:26 -0500
Date: Tue, 14 Jan 2014 14:20:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: lgirdwood@gmail.com, Xiubo Li <Li.Xiubo@freescale.com>,
        alsa-devel@alsa-project.org, kuninori.morimoto.gx@renesas.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140114142014.GM15567@sirena.org.uk>
References: <20140114123606.2241d8ab@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QqzFzR/RUlLahzby"
Content-Disposition: inline
In-Reply-To: <20140114123606.2241d8ab@armhf>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: simplify code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QqzFzR/RUlLahzby
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2014 at 12:36:06PM +0100, Jean-Francois Moine wrote:
> This patch
> - removes the fields of the platform data which are of no use to the
>   non-DT platform callers,
> - uses a new private structure to handle all the sound card information,
> - simplifies the code and make easier a possible multi-DAI links extensio=
n.
>=20
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
> Xiubo, I also removed 'of_device_is_available' which seems really
> useless: the module is not probed when the DT status is not "okay".

Please send this as a patch series to aid review, one patch doing four
different changes is much harder to review.

>  		ret =3D asoc_simple_card_sub_parse_of(np,
> -						  &info->cpu_dai,
> -						  of_cpu);
> +						  &priv->cpu_dai,
> +					  (struct device_node **)
> +						  &dai_link->cpu_of_node,
> +						  &dai_link->cpu_dai_name);


What's this cast here for?  That code doesn't look at all safe.

--QqzFzR/RUlLahzby
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1UebAAoJELSic+t+oim9n/EQAJYfDiya2h2k595VXqeMpQ5s
ueWeFI2novw43r944ire0/CzMO490MTRkuh1LTBN+0dT2Ef7tKOmIid/5wsvgk8v
rzcC9JhWwth4Z6gVHCB0/t5qh6tkzjwzZyiNYQixh5XogJ9xKwZ8UCcyUYnJDkep
cy3JsAXzcw6gGAMn0pnKEojFnRysSVNrO7R7cHgdAhQLrOFoyK8ZICpowe6gI1SW
683509CP4Qr4cpqlGrLD3AGqYmwf6RRercm+rYPN+6h9tu58zfOuEPOGCdRPyDr2
Fhbhw/TMQTbgduiufBB8wpcvEyArLryA0lg2XhcCAO0RFpgsg524xjLqe7WJ0f1r
8uyB4PQCIgNCU7KV7L+Pz2gR0rfdS9huO25JyXT6EmCg6Eq1gPYIGAiyXfcwjTHb
Lxa+NdqpT8opqW7dK/ogS7dByJEtnTmi7dfT8KP6TLLoq8V7ZzWY0K+j2A5fMZ59
u7U376PHJ4M5CiaguB8SKdJPVcUMYMs7ijcF0+7JubzopIOR/7xSgT3sKsNblNn3
xtbHPyGC3L4t0OWuPbYsR4MbwEDxLBn6rH9yI5gVkXHLB5HV3VTEsyN0mXOBQofZ
6SI2nNgIRYJ9p6qTEFnLyh9UPvowg+1imJ/sKDToYAIPEV1i2GyBOZ6js+rZ6Ivy
qKhl/UuhyKagPFfb47z5
=Lp9F
-----END PGP SIGNATURE-----

--QqzFzR/RUlLahzby--
