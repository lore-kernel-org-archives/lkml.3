Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaKFIzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:55:08 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48037 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751195AbaKFIzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:55:04 -0500
Date: Thu, 6 Nov 2014 09:54:24 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 1/6] clk: sunxi: Add support for sun9i a80 usb clocks and
 resets
Message-ID: <20141106085424.GF2989@lukather>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
 <1415074039-16590-2-git-send-email-wens@csie.org>
 <20141104165733.GI26729@lukather>
 <CAGb2v65VojZVEijdjXYGkMud7dMFzMzagfN=_4S3msZygu3YPQ@mail.gmail.com>
 <20141105100912.GD27686@lukather>
 <CAGb2v64RT4PKTji2KfDTFfc8b_kiTk0Vh49nEE9ZJukum7h2_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZYOWEO2dMm2Af3e3"
Content-Disposition: inline
In-Reply-To: <CAGb2v64RT4PKTji2KfDTFfc8b_kiTk0Vh49nEE9ZJukum7h2_Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZYOWEO2dMm2Af3e3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2014 at 10:09:27AM +0800, Chen-Yu Tsai wrote:
> >> >> +static void __init sun9i_a80_usb_mod_setup(struct device_node *nod=
e)
> >> >> +{
> >> >> +     /* AHB1 gate must be enabled to access registers */
> >> >> +     struct clk *ahb =3D of_clk_get(node, 0);
> >> >> +
> >> >> +     WARN_ON(IS_ERR(ahb));
> >> >> +     clk_prepare_enable(ahb);
> >> >
> >> > Hmmmm. That look off.
> >> >
> >> > Why do you need the clock to be enabled all the time? Isn't the CCF
> >> > already taking care of enabling the parent clock whenever it needs to
> >> > access any register?
> >>
> >> There are also resets in the same block. That and I couldn't get it
> >> working without enabling the clock beforehand.
> >
> > Ah, right.
> >
> > What happens if you just enable and disable the clocks in the
> > reset_assert and reset_deassert right before and after accessing the
> > registers?
>=20
> That doesn't work either. I forgot to mention that most of the clock
> gates have the peripheral pll as their parent, not the ahb clock gate.

Why it doesn't work? The clock needs more time to stabilize? The reset
line is set back in reset if the clocks are disabled?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ZYOWEO2dMm2Af3e3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWzdAAAoJEBx+YmzsjxAgzE8P/juU0z931GWcdgnK09+MJRiK
mZtJYMJb1Y4JmFljsZJapGrYlvrs021AXBy1PDYsd5xjbAlFkt7wpG5Wm6++QVBL
j/HEIv98r8aqXgXxE+08QgMfAdEs2NViuro6nUN82fb3xAXw1l61qXTHAk3KyxmE
tk8wAwDNl88DDDbMEtIqotLzFJ+J0aD2xwKsxLaI/2DlVPCpriRk1bfhx8nee+Bd
UN3DU2lSkUryOdL9BTvchMHdC3v56ef3TyCcvu1nEB8UwZKwK1x85fmahx6kFr46
epRVrmNLkwm2sJLe3Z878oliTvt0XeqL0wIpLoQzs/rsq09To6PglUSgiePhcRI9
rjonvP6x2zIPzwIrrK/9itTHySyMFWtc8/iy70TXXdz2AUWfo6r6W0TwXKc6M2RE
MS3g9t9ogbOXjs2l9NNuUWcC23CFKfOU9hgccyo3FgBwNRoGEJu8IBpnSrRTSch2
8HKbL4hxUMlqUrpD3W7hM9Pf379Sh74WMNIGeynOzxpXEvnt7fWpaUk2ZsPM9X4s
ULUKIl0eHqavdnMsWvMnNs47AHtjyjay0OTJXQRmooOGqZonJ+LL0QutZCiXEnxk
EjYV4oYqb92sLEvXQcDpIysLl+cSjEJja2aAbkqlC0rULXHWenxS7RSH6RK0Ya9k
omHj8N5asm/65+/ISemC
=Xd3r
-----END PGP SIGNATURE-----

--ZYOWEO2dMm2Af3e3--
