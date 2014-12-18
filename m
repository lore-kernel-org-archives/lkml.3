Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaLROWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:22:30 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35635 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaLROW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:22:29 -0500
Date: Thu, 18 Dec 2014 14:22:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Tim Harvey <tharvey@gateworks.com>
Cc: Fabio Estevam <festevam@gmail.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Silvio F <silvio.fricke@gmail.com>, Christian Hemp <c.hemp@phytec.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Iain Paton <ipaton0@gmail.com>, Anson.Huang@freescale.com,
        Shawn Guo <shawn.guo@linaro.org>
Message-ID: <20141218142205.GZ11764@sirena.org.uk>
References: <1414729631-11005-1-git-send-email-tharvey@gateworks.com>
 <1414729631-11005-5-git-send-email-tharvey@gateworks.com>
 <CAOMZO5DzEe91pTv+UkCbj0DzgVDOb9hjuakt9NmpTJnEk-j8UA@mail.gmail.com>
 <CAJ+vNU3PQYCE4tABUiqU+vGkGqBEqdVKz25W88-ByOQZxunVLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEBuHYBvvx8HzSGD"
Content-Disposition: inline
In-Reply-To: <CAJ+vNU3PQYCE4tABUiqU+vGkGqBEqdVKz25W88-ByOQZxunVLw@mail.gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] cpufreq: imx6q: add ldo-bypass support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lEBuHYBvvx8HzSGD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 18, 2014 at 06:11:15AM -0800, Tim Harvey wrote:
> On Wed, Dec 17, 2014 at 6:36 AM, Fabio Estevam <festevam@gmail.com> wrote:
> > On Fri, Oct 31, 2014 at 2:27 AM, Tim Harvey <tharvey@gateworks.com> wrote:
> >> When an external PMIC is used for VDD_SOC and VDD_ARM you can save power by
> >> bypassing the internal LDO's provided by the anantop regulator as long as
> >> you are running less than 1.2GHz. If running at 1.2GHz the IMX6 datasheets
> >> state that you must use the internal LDO's to reduce ripple on the suplies.
> >>
> >> A failure to bypass the LDO's when using an external PMIC will result in an
> >> extra voltage drop (~125mV) between VDD_ARM_IN and VDD_ARM and VDD_SOC_IN and
> >> VDD_SOC which violates the voltages specificed by the datasheets.

This description doesn't make much sense - there must of course always
be an external power source for the SoC and the discussion of bypassing
also suggests that it's not just a case of disconnecting the internal
LDOs.

> What is needed is to determine if the cpu vddsoc and vddarm regulators
> are both 'not' the same as the anatop provided regulators (then we
> bypass the anatop regulators) so I need to do such a check after all
> regulators are registered. Perhaps I need to have a late_init call (or
> some other init call that happens after all regulators are
> registered).

> Phillipp/Mark - what are your thoughts here? Do the regulator core
> functions regulator_is_same() [1] and regulator_is_bypass() [2] I
> propose make sense to determine if regulators are the same and in
> bypass mode and overcome the detection issues Phillipp discussed in a
> previous thread [3]?

Please provide a clear description of what's actually going on here.
What does the hardware actually look like and what is being configured?
You're telling me the solution you've decided on, not what the problem
that this is supposed to solve is.

--lEBuHYBvvx8HzSGD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUkuMMAAoJECTWi3JdVIfQjNoIAINV87viY6rXeDmIg0q4YpK1
GEvs8TDYaiRKSAyWo0pbSxYiLZQLx06dAhIFQ7fKtFdWYoPq/0sstVzHJLfZV2iS
PWEl7En84IlLSFVisosHsQ8dMBtc2s1+Rl041aAx3sy9yOnA6fm1qcd1J2xpAxHY
LMnMD9OU2yy0kt3HEM5Z8PIF1+d5XT11Co7ABDUXkVrKXuzVSagvXr5Ue/5YjVIl
lznL8wxfH3IKKdsRr8SqZsMkA2HHA2E7RgKkZIwjSZ9yVCfwOz4uLGFnJSjoaB48
XtHVRPTsRVIQz2b0eEZszXZ95DBv9AVTn0c8rS4ESnCF5fimNERS+kPSvTj/uNg=
=/S2R
-----END PGP SIGNATURE-----

--lEBuHYBvvx8HzSGD--
