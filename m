Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3LQM32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:29:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48940 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3LQM30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:29:26 -0500
Date: Tue, 17 Dec 2013 12:29:23 +0000
From: Mark Brown <broonie@kernel.org>
To: "Anson.Huang@freescale.com" <Anson.Huang@freescale.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131217122923.GT3185@sirena.org.uk>
References: <1387228827-933-1-git-send-email-b20788@freescale.com>
 <20131216185753.GN3185@sirena.org.uk>
 <c9e35710598c4a66823e67fd4f81c0d7@BY2PR03MB315.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ICzQLVUlUjFtnNCj"
Content-Disposition: inline
In-Reply-To: <c9e35710598c4a66823e67fd4f81c0d7@BY2PR03MB315.namprd03.prod.outlook.com>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: anatop: add is_enabled interface
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ICzQLVUlUjFtnNCj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 02:38:56AM +0000, Anson.Huang@freescale.com wrote:

Please fix the line length you're using to word wrap, it should be less
than 80 columns to make your mails readable.

> >> +	if (!anatop_reg->control_reg)
> >> +		return -ENOTSUPP;

> >In what situation would this happen and why would the operation be provided in
> >those situations?

> [Anson] This condition check is to avoid the case that control_reg is not
> Initialized correctly in the probe function.

Why would that happen without the probe function failing - it would be
better to add the error checking there wouldn't it?

> 1. For cpufreq change, we need to scale VDDARM as well as VDDSOC/PU's voltage, each
> setpoint has different VDDARM, VDDSOC/PU voltage;
> 2. VDDARM and VDDSOC will be always on but VDDPU can be off in uboot due to the big leakage
> it has(as high as ~43mA on i.MX6Q), as it is only for GPU/VPU module, and we will have
> dynamic VDDPU power management available, so VDDPU LDO's status is changing according to GPU/VPU's
> behavior;
> 3. If VDDPU is off during cpufreq change, then there is no need to scaling VDDPU's voltage,
> so we will check whether VDDPU is enabled before scaling it in cpufreq driver, this is done
> in my other patch thread;

This sounds like you need to have some higher level synchronisation
between whatever is managing this supply and your cpufreq driver - if
you rely on reading back the current status from the hardware there will
always be races between reading the state and the other thing doing the
enable or disable.

--ICzQLVUlUjFtnNCj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsEOgAAoJELSic+t+oim9DykP/ivNrOVYO2ffh9Y3XkmzZWQz
YNLocptgPgRE8CEQEC8m7LXuy8JNThZDqFWwZYI1tLxExCKbuuEgCpn4/POP8BfD
dDUwNS7jkZalqVB85ROmsADsPz164245aJFLfhKb2EqZbE7P29bj/2t6Wr1PhU/q
XOhB5c/dtEYvdKplGCjBExTVcy0lnxTBPtw3PENNoZyF5tdjbwOVqz4eI8TmBOPz
8UfOyMq3B3ruNTPuXkH5S7jwrN+ylexmDFOtLfQWR9uSrcyVrFB08nxoDIBQiUG8
FiCZ/HWtLJywNrXE33MQ/l2033fcYY9mzjso0JeuuyiglmFQjzglNjX5I8YXbqFf
vzJE7nlMjAeM+6/1VsPVg9R1rvYTdNmhnvpFMWhP2WKsejbG9lkgknl1sH0bOJja
BoCRsqUcPpG/koLb2N/HzXE9PvFSi+lmfFHob/YO9TZuzbC/gGrbH0BMzuW+4xuJ
OVbEsoFmlYVMt6ivihxdkrJ4bLSdc4N9N2mdMjjKSIQjLLIvSAfWzpmxGHpJcbR3
ssIMQyS/9yZh9ER1Kl680cL1H2Eq7t/Xb2FPMCJw1YeRKbMvG7jAFB6Io35KoXFB
7Av3wWdtgTTcsI1jCpMV2oFaeteN6+eRue4tyL+BwwsX+l0mLOgKAPJPlTfkmA+H
z84T+l7Nuqaa6V8htXOo
=VMTp
-----END PGP SIGNATURE-----

--ICzQLVUlUjFtnNCj--
