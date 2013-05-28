Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab3E1KRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:17:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46109 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3E1KRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:17:05 -0400
Date: Tue, 28 May 2013 12:17:01 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, kernel@pengutronix.de
Subject: Re: [PATCH v2] pwm: add pca9685 driver
Message-ID: <20130528101659.GA11547@mithrandir>
References: <1369646907-18424-1-git-send-email-s.trumtrar@pengutronix.de>
 <20130527191333.GA10219@mithrandir>
 <20130528073801.GD31991@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <20130528073801.GD31991@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2013 at 09:38:01AM +0200, Steffen Trumtrar wrote:
> On Mon, May 27, 2013 at 09:13:34PM +0200, Thierry Reding wrote:
> > On Mon, May 27, 2013 at 11:28:27AM +0200, Steffen Trumtrar wrote:
[...]
> > > +Optional properties:
> > > +  - invrt:  <0> output logic state not inverted
> > > +	    <1> output logic state inverted
> >=20
> > Why not make this "invert"?
> >=20
>=20
> I used the naming of NXPs datasheet, but I can change that.

I didn't say it explicitly, but "invert" should also be a boolean
property.

> > > +  - outdrv: <0> configure outputs with open-drain structure
> > > +	    <1> configure outputs with totem pole structure
> >=20
> > And this could be a boolean property called "totem-pole"? I think that's
> > much more intuitive to use.
> >=20
>=20
> This is also a register field from NXP. The datasheet references the invr=
t and
> outdrv bit in different locations to describe some use case and the corre=
sponding
> setting of this two bits. That is why I thought it might be easier to use.
> Get use case from datasheet -> put corresponding value in DT -> done.
> On the other hand, the DT might be easier to understand with a boolean pr=
operty.

That was exactly my reasoning. I think it's good and meaningful to
mirror the naming of the datasheet in the driver source code, but the DT
description can be much more intuitive by using common language instead
of some abbreviation taken from the datasheet.

> I would than go for "open-drain" though, as totem-pole is the reset defau=
lt.

Sounds good.

> > > +	if (duty_ns < 1)
> > > +		return 0;
> >=20
> > Doesn't duty_ns < 1 mean the signal is off? Why are you ignoring this
> > case?
> >=20
>=20
> I just tested with led-pwm which calls config and then disable.
> So, I don't need to do any setup in this case. I don't know, if that is
> PWM framework or driver specific. Maybe I do have to do something in this
> case? I will have a look.

Generally it can't be assumed that every user will call pwm_disable()
after configuring the duty-cycle to be 0. Both of the in-kernel users do
that, but it's not a strict requirement by the API. Calling
pwm_disable() typically results in the PWM signal being switched off.
pwm_config() with a zero duty-cycle isn't necessarily the same thing,
even if there is often no way to distinguish between both cases on a
physical level.

> > > +	/* the PWM subsystem does not support a pre-delay */
> >=20
> > What do you mean by that? How is it relevant to this code. Maybe there's
> > a case to be made to add functionality that you miss.
> >=20
>=20
> Well, you are right. The PCA supports setting two delays: start of duty c=
ycle and end of
> duty cycle. The PWM subsystem AFAIK only supports setting the length of t=
he duty cycle.
> Which results in me setting the start of duty cycle to 0.
> If other PWM chips also support this and there actually is a use case for=
 this,
> than that might be a functionality missing from the PWM subsystem.

So the PCA doesn't define the length of the duty-cycle, but rather an
offset where it starts as well as an offset where it ends? That's very
different from other chips we currently support. I don't think any of
them can do this.

On a related note, there's a bit of a gray area in the PWM subsystem
when it comes to what the PWM signal is supposed to look like. This
first came up when a chip was added that could invert the pin output.
None of our use-cases currently care about the exact form of the signal
and are only interested in the power delivered by the signal (LED,
backlight).

As you say, there's currently no use-case that requires this
functionality, so little sense it adding support now.

Thierry

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRpIQbAAoJEN0jrNd/PrOhrxQP/RHODmWI+zLiF9443aZpvfar
o55gtNB8gTUyCQCCzN9+1IaKjjWXsYcwWRPEjA4kGALlzMhqdgtZhhtdpbje/3ER
S0/dmjR7xaO9VTOPQ5pcdZXBlxTbknsmR+T5WUwjtrNo1IK0bXOYOrQFyirqJFMn
PzdCCdZkvmtIe02Bs6WH+9PFh25H2IesFNZpKmruu73Brp/sVXg9kqqe7W7P1g+j
MGvOOxbDnKHL0ZTWrllNtJIXirncQ+4nJpgzZoJmEVAQuSfAyxSJOr6RlfxxCKZa
3/rKWItsYVlIEjByvai20CvFuwOqu8AJ/Xv+aLGopR20ArNYQf1vrrnLROfN53zL
Ueh3M3gRn3M0OaU87w22bMuOZ9/TXmdooFPGY/X0+lcFKgqRCN/J/C0HWMcVyVXc
peExChZiRSoAXAgWmggYkkN5/vdVuoqDDwz3UJfbox9s4EDpj+7/O+H2qdhpHpfP
W+CXAgCocvKGcBgotK/d6ha6QY+3ScVNypzgMgN+czvrszMUsykDqwhg+VMYHBNP
+j8bTkRwcmF3vkODuTI8y5Z3/erRoPjGw2zSSEXXjCjFgdwXv4rccFi904QApEao
Do+ZdxrQ6/97Tk0CNb9UHUfo4Xa7uzXAJveqxfXguB+CpXFgCtTnRwVaayc7ji/B
tIXDgFkIPSCrgTiIIeQV
=MI/1
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
