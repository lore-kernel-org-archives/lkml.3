Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbaCRPB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:01:26 -0400
Received: from ring0.de ([5.45.105.125]:40587 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411AbaCRPBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:01:25 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	*  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	* -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 18 Mar 2014 16:01:19 +0100
From: sre@ring0.de
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] power_supply: Add DT helper function to get
 power-supply dev from dt
Message-ID: <20140318150119.GA25116@earth.universe>
References: <1395060227-23378-1-git-send-email-cw00.choi@samsung.com>
 <20140318003818.GA17391@earth.universe>
 <5327E248.7040706@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <5327E248.7040706@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chanwoo,

On Tue, Mar 18, 2014 at 03:06:00PM +0900, Chanwoo Choi wrote:
> I checked power_supply_get_by_phandle().
> But power_supply_get_by_phandle() is different from of_power_supply_get_d=
ev()
>=20
> So, I expalin the difference between "power_supply_get_by_phandle()" and =
"of_power_supply_get_dev()".
>=20
> Existing "power_supply_get_by_phandle()"
> - Need correct the name of power_supply property.
> some device driver using power_supply_get_by_phandle() has the dependecy =
of=20
> the name of power_supply property.
>=20
> If the name of power_supply property is modified,
> have to modify some device driver using power_supply_get_by_phandle().

The property names are part of the DT ABI, which is not supposed to
be stable.

> But,
> Proposed "of_power_supply_get_dev()"
> - of_power_supply_get_dev() has not dependency of specific name.
> of_power_supply_get_dev() only need device type of power_supply device am=
ong following device type:
> 	"fuelgague"
> 	"charger"
> 	we can do addtional device type of power_supply device.
>=20
> If some device driver use of_poewr_supply_get_dev(),
> don't need to consider the name of power_supply device.=09
=20
You don't need to consider the name of the power_supply device for
power_supply_get_by_phandle either. You only need to consider the
property name, which references the power_supply device. You can
have a look at drivers/power/bq2415x_charger.c, which makes use
of this function:

power_supply_get_by_phandle(np, "ti,usb-charger-detection");

A corresponding DT node can be found in arch/arm/boot/dts/omap3-n900.dts:

bq24150a: bq24150a@6b {
    /* ... */

    ti,usb-charger-detection =3D <&isp1704>;
}

As you can see the property name has nothing to do with any
names from the referenced node. Apart from that the node name
is also needed by your proposed of_power_supply_get_dev. The
difference is, that you hardcoded it to be either "fuelgauge"
or "charger". The following two calls should return the same
node:

of_power_supply_get_dev(dev, POWER_SUPPLY_DEV_FUELGAUGE, 0);
of_power_supply_get_dev(dev, "fuelgauge");

-- Sebastian

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTKF+/AAoJENju1/PIO/qacdYP/Avu2n2CCtV3KMZDEJ6kI1fo
4Smch7Sdx1zoEBV6m6hRJ3Er5nYggvP7cTMZBr2qj2WLnVXK4jnesfh2im1/kZdz
HTX1qsRGzszIGwwA7vSnhzC+BvNaP+NjcxUXcb1nSBI/gFqwZBuymdHVNWONWGpa
Reu35mA72iEY9gSAW7d/P7q2yhzzKeq32YIOElK3m7FMCyXvBx1VaLCqYlJYyifi
z1MOBiltKuEzHbiaXG3MaZaecRORIUSEosgKxZq3RpQZTAyG9zkTLLTyssNzQJYi
WqLLVNNVk67hpioFC0+kOcnLJxf43hOJQZCx1oHOK+5MOsGMARB1UFzXkm34fkR2
Ok9Kcdjj254Upbx1VBj0uhKGvKWoYXl6VsF0zQK2eFBI612j8HQKXhAFi41sZj1k
zHHzVd+SCkkNN3HwakaDlXowy61H2FIVJeAbaj0Qu4tVEKltMx9vLN1ddCmfJ1KU
q1wQyrVrCMEcMpQRKvd1K9GQd6oauadGtQgWyaMLEdRM2Me0i6u3rpailZkMqYSj
i2NMqCniKxioUH9qOX+ft4kS5X/wFB37aDzECM/0BAK/QyQWXNH5hkXX62xVX7G5
6psg5JRin7gEudc5zMu1uZV4sZ48fHoq8gB9XdKPRTaC3jAde7YD6kL+E8vxrRQ2
9fCF0TtEEzVycbtppikn
=8CN+
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
