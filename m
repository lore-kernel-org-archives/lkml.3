Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaHNKuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 06:50:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60949 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753485AbaHNKuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 06:50:05 -0400
Date: Thu, 14 Aug 2014 12:47:38 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Houcheng Lin <houcheng@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, sre@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Vikas Sajjan <vikas.sajjan@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3] reset: Add a defer reset object to send board
 specific reset
Message-ID: <20140814104738.GV15297@lukather>
References: <1403098673-3058-1-git-send-email-houcheng@gmail.com>
 <CACRpkdYfu8HmVCkn9JFh+YP5OPdr8o9nTfoCnkJ7SSpGoenQUg@mail.gmail.com>
 <20140708080535.GJ13423@lukather>
 <CACRpkdbFPAsu1gE-AVyD=-RxyE7mUJPSbFga7HLh0mxjE-mQuQ@mail.gmail.com>
 <1407507789.3354.20.camel@paszta.hi.pengutronix.de>
 <20140811173356.GN15297@lukather>
 <1408008998.4035.43.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A47bNRIYjYQgpFVi"
Content-Disposition: inline
In-Reply-To: <1408008998.4035.43.camel@paszta.hi.pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A47bNRIYjYQgpFVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2014 at 11:36:38AM +0200, Philipp Zabel wrote:
> Hi Maxime,
>=20
> Am Montag, den 11.08.2014, 19:33 +0200 schrieb Maxime Ripard:
> > > Mostly because Maxime and I seem to have a completely different opini=
on
> > > and nobody else argued one way or the other.
> >=20
> > Yep, mostly because I don't see how a generic approach can work.
> >=20
> > The existing reset-gpios property only provide the gpio to use, but
> > some informations are encoded in the driver, such as the reset
> > duration, or a reset sequence if any.
>=20
> The driver should provide the duration.

How? This used to be in the code, and reset_control_reset doesn't take
such argument.

> I'd really like to see an example where sequencing is necessary.

Well, if you have several reset lines, the sequencing between each
might be important.

> I agree that as soon as things get significantly more complicated than
> pulsing a single GPIO, the reset-gpios binding is too limited.

While the generic reset bindings are perfect for that.

> Still, I'm not happy to mandate a separate gpio reset device for each
> reset line if most devices are simple enough for it to work without.

Well, it's pretty much already the case for other subsystems, such as
regulator.

I guess we can treat this as a legacy option, but allow the reset-gpio
code to be a full driver of its own, if we need more advanced use
cases?

> What about using reset-gpios for the majority of simple cases and have a
> separate gpio-reset-sequencer driver when multiple GPIO resets have to
> be timed?

I don't know. I feel like it should be in the driver itself, rather
than in a generic layer.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--A47bNRIYjYQgpFVi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT7JPKAAoJEBx+YmzsjxAgqoUP/2YeD7cQIo3mFXzDDSqOahUo
w6NYrevoNsau4/FG5IT3oqrnAlugln2HbGuALQLMcgOgYeEQzmc2oeJkqw8dKHBg
vvXWV+HZkQeGj2LuW8J2ZcIA1ilX1RIb1/oiPMT0sv0+IRiFnpCk4PAnpty0QWQK
K4ZDUi0Ki/zq/4ZYfRVzIWsLkKT1KprqjC+/tTWdkS9EnjVPBCnZiIopvhPsr5OM
AKCGQIn0OpzcGJfynpps3RY9gN2uLTJ2+3JW+3qKWInZs+WimehIH/VuFYlo1k0C
9qZS9FdBBco4poVynANKNiS2pb1erT/EGwb9PDpxh7CRGe2TtCjkk+XV6aO+HwEh
kOGFwrWziALZBXmxtevqzchhZ8KmK0W6jOS6n/43HWuQaH16qAznmwxXCL6xtW/9
fRfzOhPiljpE4dKnbUG9MwHfqrl+VKvKynjAYI7ztLr7HoNxHYi9Ue7t8RwKEx2I
0sCLg2Jc+1dpmiOV6u0fs9m7O/iXQYEoHqTAPGBqtM3UtkiISWnxsoK+yBOEA7GH
PYACjyAsuBoIiidELwYdgAyROO6/lS85TyDZND8Wlfan1k1uwibDfa/1hUzDa6bq
i14WQndnFH4dO6LfRuPXQsGhymRnJCo94EbaQOMWYM9Rr/EwYEcu2RC7PSwy6gz2
HcXCN1BxiQAfZrLx1cnM
=gRc3
-----END PGP SIGNATURE-----

--A47bNRIYjYQgpFVi--
