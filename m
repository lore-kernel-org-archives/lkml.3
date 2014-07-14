Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaGNKWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:22:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36737 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaGNKW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:22:26 -0400
Date: Mon, 14 Jul 2014 11:22:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
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
Message-ID: <20140714102203.GD6800@sirena.org.uk>
References: <1405028569-14253-1-git-send-email-ttynkkynen@nvidia.com>
 <1405028569-14253-2-git-send-email-ttynkkynen@nvidia.com>
 <CAL1qeaFF0ZpUFovxTuLXrBPRg2Lbf-754Z=ztD5HFZPbfnDsAw@mail.gmail.com>
 <53C01558.3090607@nvidia.com>
 <CAL1qeaHETQ7kSGNjPiwi_9WNMtr9qZp0KwjZCCxY29+_N4AcuA@mail.gmail.com>
 <53C01D17.2050906@nvidia.com>
 <20140714083854.GO2081@ulmo>
 <20140714091233.GC6800@sirena.org.uk>
 <20140714092434.GA9755@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HWvPVVuAAfuRc6SZ"
Content-Disposition: inline
In-Reply-To: <20140714092434.GA9755@ulmo>
X-Cookie: Above all else -- sky.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/13] clk: tegra: Add binding for the Tegra124 DFLL
 clocksource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 14, 2014 at 11:24:35AM +0200, Thierry Reding wrote:
> On Mon, Jul 14, 2014 at 10:12:33AM +0100, Mark Brown wrote:

> > The selector value is opaque, it's entirely up to the driver to define
> > it.  If you could tell me what "this" is I might be able to advise on
> > how to do it.

> Tegra124 (and later, also some earlier variants) have this DFLL clock
> that can program a PMIC automatically depending on the CPU frequency.
> This DT binding did propose putting this into device tree as a table of
> <frequency value> pairs where the frequency corresponds to the CPU
> frequency and the value is the register value to be programmed into the
> PMIC by the DFLL hardware (there are two additional properties to define
> the slave address and the register offset).

> Andrew proposed that this table could instead be built by using
> regulator_list_voltage() instead. However, due to the fact that the DFLL
> hardware needs to know the immediate value to write into a register, the
> requirement would be for a 1:1 mapping between selector and register
> value. Given that the API needs to cover the general case I don't see
> how it could practically ensure this.

Well, if you're going to do that you've already created a private API
between the regulator driver and the device since you're assuming that
the device is controlled only by register writes to a single register
bitfield which isn't always the case.

As with all these things it would also be better to extend the regulator
API so that users like this can discover the register address and so on
too rather than having to replicate that information in the device tree.
No sense in having to specify this information multiple times.

--HWvPVVuAAfuRc6SZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw69IAAoJELSic+t+oim9vYsP/1rNXCyp6jnrPpqyXMbjGQ+Z
SQf3wtuArwhkqPZ0OB25wt249Va9HE5s/0Wgl/MzvU7fLgZLlSOTztpLJqlD9Yej
0u3S36G0PZSGhbtqtaFHNyRyr7JA40N+Ca889AK/RoEuCLce09imSvGRoqqtAnt9
Rm3uGvgqPQ5gU9DKO386wea1gmgt47rbydzu1E6sRhe87eAtnnMUqnldQZZ/LITW
S+rhR5W5rKXDrb7OEJ3NEtbofXIZ73OM9lKdlsr6wvXqo+jBu6MDgBBe4WCNYLWz
ZmwSBg2zXcH+e5z3mSKdL41+W/d/66EgdiMjX/BOFqmCXFk0pw196eQlYI2DrqjA
qRbce2y3pesVx0dv2pgWkWSUSKOK8zUGHdDr9ahcbMxMHpLj42X+0BIbLmP1vZw9
gk13yx1oKiQmpekmNV46X1LP825xV3OiywdGf2XOeMtq0tKtRs1CH0gifFMO0PVL
1aWINFAdCSwrNL8JCIK2IbU3ciFOgMPqU/rFlDWddizp4LJNv1BSRosBU4mfrB1r
6JKHX1PHzZlAhdamXNbvmj0Phha0iwI5GnEOB8U/+rfXOHpLZApC33QPwsSEx9oj
c0hhKrugQ2Xh1JGMMiFpTIAE+yeN+9J00hF7m8ZiQxtms7yKTGAfSjg3Ib3cjxUC
2hx4wLmeuCxdbz0lkoYz
=dVQS
-----END PGP SIGNATURE-----

--HWvPVVuAAfuRc6SZ--
