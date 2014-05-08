Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaEHCuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 22:50:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35056 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751851AbaEHCuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 22:50:17 -0400
Date: Wed, 7 May 2014 21:45:20 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chen-Yu Tsai <wens@csie.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH 5/7] clk: sunxi: add PRCM (Power/Reset/Clock Management)
 clks support
Message-ID: <20140508024520.GH7047@lukather>
References: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com>
 <1398697130-8338-6-git-send-email-boris.brezillon@free-electrons.com>
 <20140428234039.GT3134@lukather>
 <536A697E.5000107@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNpeiK4tTqhYOExY"
Content-Disposition: inline
In-Reply-To: <536A697E.5000107@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNpeiK4tTqhYOExY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 07:12:30PM +0200, Boris BREZILLON wrote:
>=20
> On 29/04/2014 01:40, Maxime Ripard wrote:
> > On Mon, Apr 28, 2014 at 04:58:48PM +0200, Boris BREZILLON wrote:
> >> The PRCM (Power/Reset/Clock Management) unit provides several clock
> >> devices:
> >> - AR100 clk: used to clock the Power Management co-processor
> >> - AHB0 clk: used to clock the AHB0 bus
> >> - APB0 clk and gates: used to clk
> > Used to clk?
> "Used to clk peripherals connected on the APB0 bus"
>=20
> I'll add the missing words in the next version :-).
>=20
> >
> [...]
> > Ditto.
> >
> > And you'll probably want to use devm_ioremap_resource when you'll have
> > a single clock for the AR100.
>=20
> Absolutely.
>=20
> >
> >> +
> >> +	clk_parent =3D of_clk_get_parent_name(np, 0);
> >> +	if (!clk_parent)
> >> +		return -EINVAL;
> [...]
> >> +
> >> +static struct platform_driver sun6i_a31_prcm_clk_driver =3D {
> >> +	.driver =3D {
> >> +		.name =3D "sun6i-a31-prcm-clk",
> >> +		.owner =3D THIS_MODULE,
> >> +		.of_match_table =3D sun6i_a31_prcm_clk_dt_ids,
> >> +	},
> >> +	.probe =3D sun6i_a31_prcm_clk_probe,
> > You're not calling the of_clk_del_provider, and you should probably
> > unregister your clocks too.
>=20
> This driver cannot be compiled as a module, and as a result the probed
> clks will never be removed.
>=20
> Do you really want to support clk removal for this HW block ?

Hmm, no, then it's fine.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--PNpeiK4tTqhYOExY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTau/AAAoJEBx+YmzsjxAgF4MP/REXX3DCYLkrt/OwMQ89Tmx8
TyJD4e8SEj1nmGX1rzW1/V6pCpNgj0CoVo5nRXCzVOiwLrFATQB3c4dgtzorz8Vc
Judw5pe5FkLAKW6PvxNNcGMyIkD/b9OLe73NMF3FJ9ovu3O+8yGmZrBw81ABom5b
3zLICu6qoY1HEnTyEfKwP3OlMAlDtf7iQL6Snx/Cl9Ys3sDiVX4WHevERjDETIAQ
wNDbZWjQlmKOSGWXACS6yBB4q15lohRIDjwfIMPX0ughZ50vGzzaPFJ7nUMWsXN0
VNTxH6Fg4BLZpDdpWU7X2za4cYYYr8hhhLENCteqjHWPMKLySXTiOLFtQfU0G0Nj
SpD16AKkYfLQa/YVm4WHgFTRGGOl6p2G7fTPsLP3BQrqzBh0AfG2QIHAxGNB2mYo
9ePZc6qFocUp9JCmHhYZYxUXY39BxxDvytbILDgUYYbC5razpyvDjnBrck/GFrIJ
tLWe3D72GdN0BM6T7JVefkmetRucmFqsDpJm63/FESvOfE3L+L0YwO5CPcZcR0HY
4rxtnk/0DUVMgJHvHfXn3oJI7w8wwA3oFn2S7K7pojSre9RiyqZTeJX2zGVDD5Ln
75XEc0VlqCglb7FiSEXeGcektcF8TTBqeivpRscSgbO0XdNWhuvnKoqGYTVoYzjj
+8oOo2ZKQsXS5U8rwo2/
=b36f
-----END PGP SIGNATURE-----

--PNpeiK4tTqhYOExY--
