Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaGNJYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:24:50 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:56535 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbaGNJYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:24:42 -0400
Date: Mon, 14 Jul 2014 11:24:35 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 01/13] clk: tegra: Add binding for the Tegra124 DFLL
 clocksource
Message-ID: <20140714092434.GA9755@ulmo>
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
 <1405028569-14253-2-git-send-email-ttynkkynen@nvidia.com>
 <CAL1qeaFF0ZpUFovxTuLXrBPRg2Lbf-754Z=ztD5HFZPbfnDsAw@mail.gmail.com>
 <53C01558.3090607@nvidia.com>
 <CAL1qeaHETQ7kSGNjPiwi_9WNMtr9qZp0KwjZCCxY29+_N4AcuA@mail.gmail.com>
 <53C01D17.2050906@nvidia.com>
 <20140714083854.GO2081@ulmo>
 <20140714091233.GC6800@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <20140714091233.GC6800@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 10:12:33AM +0100, Mark Brown wrote:
> On Mon, Jul 14, 2014 at 10:38:56AM +0200, Thierry Reding wrote:
> > On Fri, Jul 11, 2014 at 08:21:27PM +0300, Tuomas Tynkkynen wrote:
>=20
> > > I don't think we can assume that each selector maps to a concrete reg=
ister
> > > value, though I'm not sure. include/linux/regulator/driver.h document=
s for
> > > @list_voltage "Selectors range from zero to one less
> > > regulator_desc.n_voltages." but maybe the consumer API could take dif=
ferent
> > > values.
>=20
> > I don't think the regulator API makes any guarantees that the selector
> > corresponds to a register value. Adding Mark Brown, maybe he can help
> > figure out the best way to do this.
>=20
> The selector value is opaque, it's entirely up to the driver to define
> it.  If you could tell me what "this" is I might be able to advise on
> how to do it.

Tegra124 (and later, also some earlier variants) have this DFLL clock
that can program a PMIC automatically depending on the CPU frequency.
This DT binding did propose putting this into device tree as a table of
<frequency value> pairs where the frequency corresponds to the CPU
frequency and the value is the register value to be programmed into the
PMIC by the DFLL hardware (there are two additional properties to define
the slave address and the register offset).

Andrew proposed that this table could instead be built by using
regulator_list_voltage() instead. However, due to the fact that the DFLL
hardware needs to know the immediate value to write into a register, the
requirement would be for a 1:1 mapping between selector and register
value. Given that the API needs to cover the general case I don't see
how it could practically ensure this.

Thierry

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw6HSAAoJEN0jrNd/PrOhbFwP/03tePNKsD5IznjxmNgv6AMm
uot8qEnBu6iDp29m/HYArNbmtbsmpvVPiYdmV26DkpT21YP8qokTEmvKHwKSJ9gV
zeZlVKUXIRf04NfZLttOxWkQYIm3rx4WLlszJa4HE6i9K/bBKqrIgemffLW7aq54
vlDYd6QMOM6fIEJUk6+tZ5LyhwVhuiNFOJWVt+onhI0bxAMU+oiHCD//z82JXNQq
Je05gDP0KqGUtM7xjDrCH0c+pQ1OVcUK1veDAmuvSJvlR3Rlf6fLn4lKlKwSSEqj
nHAtUdoDvqIrFj5KISWpuYkrkk4K6Kg0PQ4Ux/ojWEqoecAzKCnhIgzW2IL3tIUA
16tq6tn6pc6CGSchljYNG0P2zxmweBROtzPL0rBSCmxT052mK1+G6RXNMGE8dpie
U+XuXYxlweGxMVJk1OIUAg/Y2o4EBz6LUjcpmOGuB3YqeJ9qV2bD9kKQadHtYSl7
dvt1ZFdaYA6iHrFZYJ/k1QvmNey4b5sri4vTJ7d9PDJBPL07xsljDx83nXMFoC+Y
XI2GVaA2/pbsce5CTSzBcaWMp6ipaMrb6WrOsYO3b52VBELOZhO5ix54W2kZykTC
3zFh6OGqZJAXfULF7nRi/Q6IC0dVuipIHCuZIRhfvEilE0sad1zszCTtFTM/HE+v
m8SKSlf9hUiGbK7D+iHH
=8il+
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
