Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaFBMQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:16:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50804 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaFBMQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:16:43 -0400
Date: Mon, 2 Jun 2014 13:15:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Message-ID: <20140602121538.GL22111@sirena.org.uk>
References: <1400691239-21987-1-git-send-email-l.stach@pengutronix.de>
 <20140601113834.GG5099@sirena.org.uk>
 <1401704829.4655.13.camel@weser.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KMh3oH5xaVDeKy7N"
Content-Disposition: inline
In-Reply-To: <1401704829.4655.13.camel@weser.hi.pengutronix.de>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.124
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: allow non-exact matches in
 regulator_set_voltage_time()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KMh3oH5xaVDeKy7N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 12:27:09PM +0200, Lucas Stach wrote:
> Am Sonntag, den 01.06.2014, 12:38 +0100 schrieb Mark Brown:
> > On Wed, May 21, 2014 at 06:53:59PM +0200, Lucas Stach wrote:

> > At least the code in cpufreq-cpu0 looks a bit confused here.  The use of
> > min_uV and max_uV is a bit unclear but probably correct however for some
> > reason it appears that what it's doing is stepping through each single
> > step transition between two adjacent frequencies, getting the transition
> > latency for that and then summing those.  Given that it needs a single
> > number I'd expect it to instead be getting the minimum and maximum
> > voltages and then working out the highest latency for transitioning
> > between those, what it's doing at the minute will be overestimating any
> > fixed component of transition latency (from the time taken to issue
> > commands to the device for example).

> Note the add is not within any loop, so what cpufreq-cpu0 currently does
> is getting the lowest and highest voltage and using the transition time
> between those two. It's just adding this to a fixed delay used to
> represent other delays like PLL relock.

Ugh, that IS_ERR() and for loop really aren't helping legibility here.
It'd be better for it to go through and check the voltage on every
frequency, probably it won't make much difference but it'd be more
robust.

> > Incidentally the clock API ought to have a similar thing - at the minute
> > the driver just has a fixed number stuffed into it from DT but it really
> > ought to be able to ask the clock API in the same way as it asks the
> > regulator API.

> Right, this should be easily fixable by calling clk_round_rate() on te
> OPP defined frequencies.

No, you're missing the point.  The clock API ought to be providing a way
of querying the latency.

> > Your code won't actually do quite what cpufreq-cpu0 is doing since it
> > uses set_voltage_tol() which will ask for a range around the voltage
> > it's trying to set so the query in cpufreq-cpu0 will come out as
> > something different to what the driver actually ends up doing when it
> > does transitions.  We should probably add functions to query what the
> > actual voltage selected for a given set_voltage() and set_voltage_tol()
> > will be then let that be fed into requesting the transition times.

> Hm, this sounds a lot like clk_round_rate() for the regulator API which
> sounds like a sensible addition. One problem I see here is that the
> result is not really a static value, but rather depends on the
> consumers. If we call into the regulator API early to ask about the
> voltage we will get when asking for a range, the result may well be
> different than the real value after other consumers have registered
> themselves with a different min_uV.

Sure, but this stuff is never going to work absolutely reliably in the
presence of multiple consumers anyway and you're most likely going to be
getting a worst case number which is what you want.  If you're doing an
absolute delay you'd need to query what the actual transition was and
delay at that point.

--KMh3oH5xaVDeKy7N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjGrhAAoJELSic+t+oim9pXsP/2z/6LSgMJgQN5QEM7qG2ibo
QKDtmeFS3xnGH583VBXBvob5hMV+I8Ibg8adJ+sDp5P+s7XL4yrsYDUFlAiEup2w
hR5fxyEQW6BRIEH+/S7TV9QPD05owuXNzT1v0A/2siCV2R2GXsEpzP+Txxu7klYT
emwu8OqG0pH9KglMS4cpum6AxGeeecga7ZKz78kXtV5hvpwll/W8SXGntDrG05S0
yTmu4sMwked277mx7TTpKzt1BLOIGgOpSxC3HEzo0myq66WA6gCeAtwoJRIUhOVz
BfblF+k+BylhaGpzDsGRg5igr9w0I7/p+GkGjzquCbGtYm5vjDE0aVWGhDjml20x
UpDsIcHq7FICNFFsUDxpYztfkJeWK0kiXU379neNbvBayh43XqI7wkZAqdQzJ9vA
wnaokEMZsKvHdLMtUsBL2SujEBrmlbjJaCYWfFFPWqeu8+h6bquL3aM+wommy4/D
WuD7gqpHDVeb75MpP42M7npqyIkybZCOdH8IzOxt4CRHKg5ASbN16+FmO9TEI24m
XBOtQlukCiv0vIByOS146RBaiSSCyKM5sLaZB1YVdUl3MajcsgQ++WtfdIk/xFul
z/J4BUKhgiNBQsaLXWBp4DoEZ04V6J3y3jdO9nnqtHN+LwV6dsPnqS84sF/H1tke
wwcSIipYc49yI8wM6izu
=qA5T
-----END PGP SIGNATURE-----

--KMh3oH5xaVDeKy7N--
