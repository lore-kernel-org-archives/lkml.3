Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965081AbaGPPBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:01:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40377 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591AbaGPPBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:01:03 -0400
Date: Wed, 16 Jul 2014 16:00:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        John Stultz <john.stultz@linaro.org>
Message-ID: <20140716150010.GA4951@sirena.org.uk>
References: <alpine.DEB.2.10.1407161151450.24854@nanos>
 <53C6633D.9080905@ladisch.de>
 <20140716123727.GA19379@twins.programming.kicks-ass.net>
 <53C68943.2060003@ladisch.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <53C68943.2060003@ladisch.de>
X-Cookie: Help fight continental drift.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: firewire: CLOCK_MONOTONIC_RAW exposure
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 16, 2014 at 04:16:35PM +0200, Clemens Ladisch wrote:
> Peter Zijlstra wrote:
> > On Wed, Jul 16, 2014 at 01:34:21PM +0200, Clemens Ladisch wrote:

> >> The purpose is to get a stable clock, i.e., to avoid clock rate changes
> >> caused by NTP corrections.

> > That's maybe half an answer; what do you need that for?

> According to the original report, "for applications which need to
> synchronise with external timebases such as broadcast TV applications".
> Such external clocks are not synchronous with any available clocksource,
> so proper resampling requires that the (relative) rate of the two clocks
> (sender and playback device) is measured accurately.

> (I don't have numbers for the errors caused by NTP adjustments.  Daniel?)

Right, the goal is to get a clock which is guaranteed to never have any
adjustments that might cause discontinuities or rate changes applied to
it.  My understanding is that the users are already doing their own rate
matching and it's much more important to them to get a stable clock than
it is to get a clock at a specific nominal rate, and given the set top
box applications I expect they also need this from very soon after boot.

For ALSA the behaviour is optional and users can always opt to use the
NTP corrected monotonic clock if they prefer.

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxpN3AAoJELSic+t+oim90o0P+gLvGG2vArbCQ6gAQp7/jwxK
9XeI/2fQhFIyRYn2in1i+RfRNJeeGjfzhk+Pv48S/ev5xx3CUIDjE6FFnPnR/hcU
q33O6Xc51t9TRyGoXo2eNtQJzCFuqoZquvb4kTUIDQQjQJpBqwRaPAYwF1YcSsfZ
JgbdtxZtfh3ziLOgTYq2gPDa1hy8efx/zUg+QtrDsoiu1C5DWH4DxVsihbBpcPAG
0yDqjLMZnr6bm2//L0M7Y2bReSQWCq5d4Kr/d1XFnxXOied2AUDwa40uo9aumFP+
8XeZ+JOm+IgLcQ1KBHLEeTuuAZk90ShlR2scQTt3YLL3/uejPMbukGJnJNCP9tqn
8YhY+mPDmSnDKulYjETN4f36PKQYI6M/JkdAyHdr0zDed6XXZLH1Rqnaug7StGFD
NUEY5aM+rFiNWzcDx8qCt4c/+RVZuUrvqyfG94vG3kLJ6gQ0nxT12OVIeTqBArkY
mzG1GneVZCKzgzmJVhcor4UiK/N3VXIvjJOzwM9asMYFbsSqUbTaSAaFS8j2Knlz
UDjvaJH8UNNqOXM0L6/0OwL/eDbz9IMbolFmVXYrD7ppjCsDHi1NuLaknl40Hr6i
MKibMfmsoORkzQ9a8DdA06En9/QxPm3j3ChF/IQ4vC+U2sHmTX4n88Lm6piE0p3G
8TAt0RFund9mfCbtig6C
=h6MZ
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
