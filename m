Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaE0T3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:29:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44684 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbaE0T3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:29:47 -0400
Date: Tue, 27 May 2014 20:29:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        arvind.chauhan@arm.com, edubezval@gmail.com, pavel@ucw.cz,
        lgirdwood@gmail.com
Message-ID: <20140527192923.GC12304@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wJgPvdDu+gj56kJ8"
Content-Disposition: inline
In-Reply-To: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulators: Add definition of
 regulator_set_voltage_time() for !CONFIG_REGULATOR
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wJgPvdDu+gj56kJ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 27, 2014 at 05:37:29PM +0530, Viresh Kumar wrote:

> Liam/Broonie: Please see if this can go through Rafael as 2nd patch is dependent
> on it.

Is that likely to happen before the merge window?

> +static inline int regulator_set_voltage_time(struct regulator *regulator,
> +					     int old_uV, int new_uV)
> +{
> +	return 0;
> +}
> +

Hrm, I'd have expected this to return -EINVAL when stubbed.  I'd also
have expected regulator_set_voltage() to return -EINVAL mind you.  I
*suppose* that something that doesn't actually depend on regulator like
cpufreq might not care if the voltage really did change (I bet this was
added for cpufreq) but it's not awesome.

--wJgPvdDu+gj56kJ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThOeQAAoJELSic+t+oim9FCEP/1CuJKOmQKwxTvltj3Ypv7SZ
cU1Rnf9gfnttYRAopHz9JRumLV3ynyWON7pLk4rliDWwf0Z/TMVnWt4vAiUINW/6
/tplfmTwSiYi2iwZdbA2osXaWSKD0BuCIIqRuLdtRqVz/MShaWcmlnEOW0aUqMp+
qn9DUdqbyJpXTIJOQKW1qZSGPmQ07c9opRKXY4bMiNKAIfnt804yqiENSj2RxrVf
BGx2RsCER1pTuqYN0FoVC+qjrPIg9jRhtGJ0N5KxrnHb6LaP/3F55rnNAA9sZeFp
RBRnVpkCWD8aK9ie+JI2JtkmNLpCcj5VWxmZZw1L52qQ83VRejN+NWhSv7T/ic3d
3JkvWdhS7cCPKOD0qLIP7lKadLOVSeTYow7UbchcPSslSWf3eAYYBj1C/Ag+qyNi
U9R6uLE+0Dptyj83yuG8Gzt6hFTNWKRhMwrN7D2CIYUv2BJlrRx5ov2VjK7fWO7A
1Az+2mBwC5vHzH6A7tDJRh2stJZU+z+82CDfOw2ynGpRv/iPBT635fjxA9r/uz2G
qups7vqohRmqY1U8UBvv8CtK6uJrlBL5kaCdKuEgmkVESYNnVU28e3Ocp6MpE5o8
5xES7aBgf8ZvbW9VVAM5LH8m7n+W6de62zMJ6+oGYkkYZAq+LFUpfi+WNjsnaaHX
Vpoum2tXB+r8+IdfRJR+
=fEEO
-----END PGP SIGNATURE-----

--wJgPvdDu+gj56kJ8--
