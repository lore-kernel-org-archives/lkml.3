Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3JXIip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 04:38:45 -0400
Received: from ring0.de ([91.143.88.219]:45260 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab3JXIin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 04:38:43 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Thu, 24 Oct 2013 10:38:39 +0200
From: Sebastian Reichel <sre@debian.org>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv4 1/3] Input: twl4030-pwrbutton - add device tree support
Message-ID: <20131024083837.GA28938@earth.universe>
Mail-Followup-To: Florian Vaussard <florian.vaussard@epfl.ch>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <1382550852-11508-1-git-send-email-sre@debian.org>
 <1382550852-11508-2-git-send-email-sre@debian.org>
 <5268D095.3060302@epfl.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <5268D095.3060302@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Florian,

On Thu, Oct 24, 2013 at 09:47:33AM +0200, Florian Vaussard wrote:
> > +Required SoC Specific Properties:
> > +- compatible: should be one of the following
> > +   - "ti,twl4030-pwrbutton": For controllers compatible with twl4030
> > +- interrupt: should be one of the following
> > +   - <8>: For controllers compatible with twl4030
>=20
> This is <8> for your particular case, but it will depend on your
> SoC, won't it?  Moreover, this property will be most likely
> inherited from the root twl node, so I do not see the need to
> document it here. See:
>=20
> Documentation/devicetree/bindings/mfd/twl-familly.txt

No. This is an internal twl4030 interrupt. TWL4030 functions
itself as an interrupt controller.

> > +
> > +Example:
> > +	twl_pwrbutton: pwrbutton {
> > +		compatible =3D "ti,twl4030-pwrbutton";
> > +		interrupts =3D <8>;
> > +	};
>=20
> You are missing the root twl node here, no?

So should I document it like this?

twl4030 {
    compatible =3D "ti,twl4030";

    pwrbutton {
        compatible =3D "ti,twl4030-pwrbutton";
        interrupts =3D <8>;
    };
};

> > diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/mis=
c/twl4030-pwrbutton.c
> > index b9a05fd..a3a0fe3 100644
> > --- a/drivers/input/misc/twl4030-pwrbutton.c
> > +++ b/drivers/input/misc/twl4030-pwrbutton.c
>=20
> Missing #include <linux/of.h> ?

It's included indirectly, but I should probably add a direct
include. Thanks.

> Best regards,

Thanks for the comments. I will sent out an updated patchset later.

-- Sebastian

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSaNyNAAoJENju1/PIO/qaviEQAJgWOewpGQxQ0hPJP325+1Rm
LVM5YxDke2xPKWteEDgEnOjGlgZjqOGU9ZwW5bOTc9yB7M0vlPK1qS9hKjF/7nRS
cKPsoXo/8JxgfBjo9eBsUoXPv1gO/QpwBisLtiVfcQFDlSZlWYMwuQtD+rrdEUbq
whTUvniz9vmGk3dyRFOWch7B6PGjVXA2rjrr7FzO5MgmfWgR8RlTQCFVm3I65wNM
DYNfsTF/Mbah40wwJohF/QDk+4ZQKUbq5NLZKpO+yFR/Pc/IK2ePRaGVLl9WFv98
uGWu99FvJ9gZq5K8N7WAWJWxaj456+6PXts6TlXQbUhWRrPa4xfFs5F9CQ6AKpsb
4AmB2WYEt2r9SEcX8VYHMKCXQVy0/3O2DUiFpFzJUVcp4SqfRshhfP8L4vFU+6fz
K0GmT2joL+gwcBqkRZ+Di1+uD4OrwfBKIxVG0YK38T1DNpZGJB2W3P62t0839Fmw
tS1vUJnX6vOfbAbWTDLNz9iOBMqzFBX8cojZ9L0MAAHmbVra1OEMDjMXmdPp0J30
P6vcV6PBFXMtt0X1DJLdGtx5Pl7paelKQGCgJI5YE2PBUWNQb7AvaTUhcjWO1rW+
g8O7nmgIbwLjMZmJYjFaxx5V0kNroB23iPmgP2/9XLJekLdBlisQxjD99JDoH4f1
4UBQQJEH3fkIPCE2jl2f
=KrTs
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
