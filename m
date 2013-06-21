Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3FUJwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:52:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33236 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3FUJwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:52:21 -0400
Date: Fri, 21 Jun 2013 10:51:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, viresh.kumar@linaro.org,
        cpufreq@vger.kernel.org
Message-ID: <20130621095157.GK27646@sirena.org.uk>
References: <1371669474-24473-1-git-send-email-nm@ti.com>
 <20130619223828.GK1403@sirena.org.uk>
 <20130620124542.GA28320@kahuna>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rex5+51txc1ort/q"
Content-Disposition: inline
In-Reply-To: <20130620124542.GA28320@kahuna>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: core: allow consumers to request to
 closes step voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Rex5+51txc1ort/q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 20, 2013 at 07:45:42AM -0500, Nishanth Menon wrote:
> On 23:38-20130619, Mark Brown wrote:

> > If the consumer can tolerate a different voltage why not just request
> > the range that can be tolerated?  Your problem here is specifying an
> > exact voltage.

> I think you mean using regulator_get_linear_step

No, I don't.  Why would that make sense?  It limits the regulators that
can be used and the properties of the regulator have no impact on what
the SoC can support.

> > Or as I keep telling you guys the consumer can just do that directly
> > using the existing API; the whole point in specifying the voltage as a
> > range is to allow the consumer to cope with arbatrary regulators by
> > giving a range of voltages that it can accept.

> I agree. The intent of this series was to start a conversation to see if
> we can make it simpler.

It's already very simple.  The consumer driver just needs to supply the
list of voltages which it can accept, that's all.

> For a generic driver which needs to handle platforms which
> have tolerance, they'd use regulator_set_voltage_tol. But the
> implementation would allow for uV - tol to uV + tol as range, which in
> the case I mentioned(min voltage =uV) wont work.

So just write it as an explicit voltage range then.  For example many
devices can tolerate any supply up to the maximum rated supply at any
frequency so just specify that as the upper limit.

> If the consumer wants to be aware of linear step regulator, they'd have to do:
> step_uV = regulator_get_linear_step(...);
> regulator_set_voltage(uV, uV + step_uV);

No, the consumer really doesn't want to be aware of linear step
regulators.  Why would it care that there even are linear steps?  If
the consumer is doing this based on the properties of the regulator
rather than on the properties of the consumer this indicates that the
consumer has a problem  If the consumer is doing this based on the
properties of the regulator rather than on the properties of the
consumer this indicates that the consumer has a problem

--Rex5+51txc1ort/q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRxCI6AAoJELSic+t+oim94LwQAJoSWUIgRGCguURLSihJjo65
LfaivAKChPqS9DeI1OPpup1VLoR0o3k/LUginTLUXHqmnhJ1kb/953TSHyt+oPOs
sg1ET/COunTa3EgI7tOMI76NfpCVh7/DLKyBXQyjtkxPifrz5YyC6u7sK5O3vvxt
HtVqXDCYfdCG/RyF6bzejtsKTQVR7D8SB6EZv3TrDzyj4UYnq+HR6aXE9nyrqzry
TBrK30vO5XAEYUNeYMRWvCDWQXGaVhtXo3c908mSIhGvJynIC8UPXDaFwzstx5xB
BEDFh2L63EHlZZEOgDAuoc0Z2diBoZOJmFLWyQvsIwX4PIHLOeCpC9sDfjie26nr
DRufSs0csvmdAQGsOh0xgb8f5dXcUvMlNq2JGhTvrNvZwZ0XuWzF2CrtAkzzHa3U
KMLZIzFPN7ITY5b80tH+FVbvO//zzJZ2KJHU5CR1NCIRDTaaqcjsOCbQmN++VA5O
o6UNQv0LV1ZhHvkvh1SE2X3c3YLoWKoG2foRLhOYwoheFCEGKSPCRotd5/ym+THe
L/EFFQ0Uag42KUMzsV4GAQramDfVy5qvC0CL1DQI7ag54DfayF8+ucxT9Bg8a9Su
kwrkEXRrRTmTcmYMUMlw28Eg46OWurAdYrrHNeStto6V0cK/wyKKY9nZbH9cDqN2
cx0D+Oy6BItg9otxzriN
=wQIN
-----END PGP SIGNATURE-----

--Rex5+51txc1ort/q--
