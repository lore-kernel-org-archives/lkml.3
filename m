Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab3IZMwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:52:04 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:45656 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab3IZMwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:52:00 -0400
Date: Thu, 26 Sep 2013 14:50:21 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Mike Dunn <mikedunn@newsguy.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] pwm-backlight: add support for device tree gpio control
Message-ID: <20130926125020.GA2141@ulmo>
References: <1378236372-15711-1-git-send-email-mikedunn@newsguy.com>
 <20130910172130.GC22111@ulmo>
 <523056A6.5060000@newsguy.com>
 <524408BE.40402@ti.com>
 <20130926120248.GB1680@ulmo>
 <524427E5.50403@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <524427E5.50403@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2013 at 03:26:13PM +0300, Tomi Valkeinen wrote:
> On 26/09/13 15:02, Thierry Reding wrote:
> > On Thu, Sep 26, 2013 at 01:13:18PM +0300, Tomi Valkeinen wrote:
> >> On 11/09/13 14:40, Mike Dunn wrote:
> >>> On 09/10/2013 10:21 AM, Thierry Reding wrote:
> >>
> >>>> Do you have a real setup that actually needs multiple GPIOs? Usually
> >>>> such a setup requires some kind of timing or other additional constr=
aint
> >>>> which can't be represented by this simple binding.
> >>>>
> >>>> Looking at the Palm Treo code it seems like the reason why multiple
> >>>> GPIOs are needed is because one is to enable the backlight, while the
> >>>> other is in fact used to enable the LCD panel.=20
> >>>
> >>>
> >>> There are actually four GPIOs involved!  (There is an embarrasingly h=
orrible
> >>> hack in arch/arm/mach-pxa/palmtreo.c that handles the others.)  One i=
s almost
> >>> certainly simply backlight power.  The other three are probably LCD r=
elated.
> >>
> >> When you say "power", do you mean the gpio enables a regulator to feed
> >> power to the backlight? If so, wouldn't that be a regulator, not gpio,
> >> from the bl driver's point of view?
> >>
> >> Generally speaking, this same problem appears in many places, but for
> >> some reason especially in display. I'm a bit hesitant in adding "free
> >> form" gpio/regulator support for drivers, as, as Thierry pointed out,
> >> there are often timing requirements, or sometimes the gpios are
> >> inverted, or sometimes the gpio is, in fact, a reset gpio, where you'll
> >> assert the gpio for a short moment only.
> >=20
> > I sent out another series a few days ago that somewhat obsoletes this
> > patch. What it does is basically add a single enable GPIO that can be
> > used to turn the backlight on and off. In a separate patch, support is
> > added for a power regulator. The combination of both should be able to
> > cover the majority of use-cases.
>=20
> But Mike's case required 4 GPIOs? Or can that be reduced to one gpio and
> one regulator?

Well, at least for the backlight it only seemed to involve a single
GPIO. The other three were probably related to LCD and therefore not
really suitable for a backlight driver. Traditionally it has been that
the backlight driver handled these things as well (via the callbacks
installed by board setup code). While really they should be handled by a
separate driver (for the LCD).

> > That series doesn't handle any timing requirements, but again, for the
> > majority of the setups supported by a power supply and enable GPIO the
> > timing doesn't matter.
> >=20
> >> I haven't seen new versions for the power sequences framework (without
> >> DT support), I think it could help us here a bit by simplifying how we
> >> present the sequences inside the driver. But we still need multiple
> >> drivers or the same driver supporting multiple devices.
> >=20
> > I'm not sure if power sequences will be very helpful here. There was an
> > attempt to get those merged, but the patches were NAKed in the end. I'm
> > not aware of any work currently being done on them.
>=20
> I thought the NAK was for the DT parts, not for the sequences as such. I
> don't remember anyone shooting down the idea of defining power sequences
> inside a driver.

Yes, but the DT parts were the primary reason why they were written in
the first place. Without DT we can just use the existing hooks to do the
sequencing. There is not much to be gained from power sequences.

> >> And I also think that the model where we have just one driver for, say,
> >> backlight may not be enough. There may be multiple hardware components,
> >> that used together will generate the backlight. And each component
> >> requires specific management.
> >=20
> > I'm not sure what other components you are talking about here. Can you
> > elaborate?
>=20
> I don't have any specific case in mind, and maybe these are quite rare.
> But there could be some kind of mix of muxes, regulators, gpios and
> whatnot that need to be managed in certain way to make backlight (or
> display) work.
>=20
> I'm making this up, so I'm not sure if this is sensible, but consider a
> board where there's a mux to select where a backlight gets its PWM
> input, and the mux is controlled via i2c. And maybe insert some kind of
> level shifter in between, enabled with a GPIO. And some third component,
> as this hypothetical board is a development board, and hardware people
> seem to love to make bizarre designs, that work in theory but the SW is
> almost impossible to design...
>=20
> So to enable the backlight, we might need to do multiple different
> things, depending on which components this particular board has.
> Especially for a mux controlled via i2c it would make sense to have a
> separate driver. Having just a single backlight driver might not be enoug=
h.
>=20
> Sometimes, or hopefully often, that kind of complexity can be hidden
> behind common frameworks. For example, enabling a gpio could result in
> the gpio driver enabling a regulator, sending i2c messages, or whatever.
> But I don't think that's possible in all cases.
>=20
> Anyway, this was really more of "thinking out loud" than any suggestion.

There is unfortunately always the next crazy setup that one can think
of. I personally prefer to support what we have (or at least the
majority of that) with something generic and tackle the more exotic
setups later on (or when they appear, as the case may be).

As things stand right now, there's no way to get the simplest panel
setup to work properly if you use DT. By adding both an enable GPIO and
a power supply regulator we can at least cover the sane use-cases with
some sane and pretty simple code.

Thierry

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSRC2MAAoJEN0jrNd/PrOhghcP+wavliLdLw4rVaBai1rMBkoL
X+ZIadVFmtaaWf+NgOkECZ8C6qKPMBvCSRRp2GUxEbQCD6D44YU6LgW28zLH9kq7
JLos1ohzndB148/6YnpS3JxQa4UYhZGzgnpOi5rrLEFaq+bxbkkVyf+GFBxlfiPR
UxDCpMTvN5nR6W5q/t/ZhreHHrvew/NvaJZ+gN1tNOrkAWTbvHxomc1gsbgBC3MI
4jE4xe0zbtLJcAaE4X+VUKXglCJ5/k1MqbSZ3xfw2gbEjAwSVg5feseLCUgfzCPq
SgvPQ2FL2ISonvGi00fxME9+WoxxUSU/mxiA3y+Vri94upkulLOQYSxT3iqt0i2V
qo/Za1I2Y7PtzqCl3tjyjBFNXAh0r8I7asNMMnZ1YtQ05D7OFOoq3SkdzJA2FxqS
UUWKqyp4eeL72/Ysh+xLRv17Fzx0p668CxQ2huBuWdtoQUWN7zOJQGI6hYzU/xzg
spNwy6iizp2MQaoigFqSH+fbWEw8KyL48XA2POk/c+mDZuThIS5NkJV4UDnhxVxE
vtipECiQXitTeqpPjEeya3G4gx23DnEaKI3V+9WdRvmkwfZrfS2NATtoIkan2XEh
siA6XTmTxStAtn+ea/MD9Chjl31q9KyXPMRp/TTXasAbwwyK/pmq+NtMDtwoukKh
xGq2/jzNpiFCEsZGD5Ax
=NwvR
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
