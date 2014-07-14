Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbaGNIjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:39:05 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62451 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaGNIjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:39:02 -0400
Date: Mon, 14 Jul 2014 10:38:56 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Andrew Bresticker <abrestic@chromium.org>,
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
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 01/13] clk: tegra: Add binding for the Tegra124 DFLL
 clocksource
Message-ID: <20140714083854.GO2081@ulmo>
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
 <1405028569-14253-2-git-send-email-ttynkkynen@nvidia.com>
 <CAL1qeaFF0ZpUFovxTuLXrBPRg2Lbf-754Z=ztD5HFZPbfnDsAw@mail.gmail.com>
 <53C01558.3090607@nvidia.com>
 <CAL1qeaHETQ7kSGNjPiwi_9WNMtr9qZp0KwjZCCxY29+_N4AcuA@mail.gmail.com>
 <53C01D17.2050906@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MmQIYbZiCoQ2kDro"
Content-Disposition: inline
In-Reply-To: <53C01D17.2050906@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MmQIYbZiCoQ2kDro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2014 at 08:21:27PM +0300, Tuomas Tynkkynen wrote:
>=20
>=20
> On 11/07/14 20:08, Andrew Bresticker wrote:
> >On Fri, Jul 11, 2014 at 9:48 AM, Tuomas Tynkkynen <ttynkkynen@nvidia.com=
> wrote:
> >>
> >>
> >>On 11/07/14 19:28, Andrew Bresticker wrote:
> >>>
> >>>On Thu, Jul 10, 2014 at 2:42 PM, Tuomas Tynkkynen <ttynkkynen@nvidia.c=
om>
> >>>wrote:
> >>>>
> >>>>The DFLL is the main clocksource for the fast CPU cluster on Tegra124
> >>>>and also provides automatic CPU rail voltage scaling as well. The DFLL
> >>>>is a separate IP block from the usual Tegra124 clock-and-reset
> >>>>controller, so it gets its own node in the device tree.
> >>>
> >>>
> >>>>diff --git
> >>>>a/Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt
> >>>>b/Documentation/devicetree/bindings/clock/nvidia,tegra124-dfll.txt
> >>>
> >>>
> >>>>+- nvidia,pmic-voltage-table: Array of 2-tuples.  Each entry should h=
ave
> >>>>the
> >>>>+  form <register-value voltage-in-uV>, indicating the register value
> >>>>that
> >>>>+  needs to be programmed to the PMIC for changing the VDD_CPU voltag=
e to
> >>>>+  the specified voltage. The table must be in ascending order by the
> >>>>voltage.
> >>>
> >>>
> >>>Instead of listing the register values for each voltage in the DT,
> >>>can't you use regulator_list_voltage() to create this map?
> >>>
> >>
> >>I don't see a way to get the register values that way, unless we assume=
 that
> >>the mapping is linear and doesn't have holes.
> >
> >Hmm... I guess if you don't assume it's linear and continuous you'd
> >have to iterate over all 256 selectors.
> >
>=20
> I don't think we can assume that each selector maps to a concrete register
> value, though I'm not sure. include/linux/regulator/driver.h documents for
> @list_voltage "Selectors range from zero to one less
> regulator_desc.n_voltages." but maybe the consumer API could take differe=
nt
> values.

I don't think the regulator API makes any guarantees that the selector
corresponds to a register value. Adding Mark Brown, maybe he can help
figure out the best way to do this.

Thierry

--MmQIYbZiCoQ2kDro
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw5ceAAoJEN0jrNd/PrOhSIwP/i8ObzBFUR0bWFqC9Kwqs3aX
vu7z+L0oMXbkiHx2qcaAjhF7M8vVV3lAxwXQIDde9uMc/LevjN43YqhRnGgXZAvC
bSurdg1+RQRht3uPKA6IIVyz3O+mra4MrQgzRqfA2AY2NrixLqyBohLel2Eebf7Q
HjHqFhagTmFv7fL9iIZpec0/gkR2Ht7R3+NCLG7VBs+Xby5qvkdDJTaWHSpreSSK
KQ233hrtlrcAogqq/PTKR8bALJeP/Z56U9Q7VTBvQkRRczz9ihidfApz+xQiGv6B
NnmGpM/3zz/C+RHwQ47HjWB4yCS8tcv6br6mCsIykUrHnE6rSz7H4Z5uJSvRoo+a
ZNuKVkOoSiaaTzlx3wt2c/MdSX49ISrJZZqDUMFWOr9oEGPA/1U89cONa1AZSrkq
ev1fFF5UcnYU0uhmnIt36YunCLv1TFH9jBUVSjhEk0mGue2ZyPLvdmaHcccqc+gx
ADlah85xU44xcGOeQtJfAq8drL6a8JeTUtrNUzttLOaTEcV7tPt/3IUXiVKVGFvm
kY3HTCDEWbnu65NSYHLxzqPBkml/8B9rorL/83PP7qaVQ5njT6nnE/hHjYb7QKpM
464KI+3pq4EFNa79dja1H2FOeuwIBbT/mQp5DGVamQk+KqaIs2aB2a7HPK14GUNx
4XCGet3kN2duFTpuozy/
=suW1
-----END PGP SIGNATURE-----

--MmQIYbZiCoQ2kDro--
