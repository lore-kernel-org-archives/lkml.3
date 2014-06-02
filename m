Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaFBQUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:20:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51061 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaFBQUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:20:23 -0400
Date: Mon, 2 Jun 2014 16:20:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140602152014.GL31751@sirena.org.uk>
References: <20140527192923.GC12304@sirena.org.uk>
 <CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
 <20140528173858.GG5099@sirena.org.uk>
 <CAKohpokk_sNQ7Be5F8NLa7pLrssPm9qPf-fDEUYkiurJ6Etrpg@mail.gmail.com>
 <20140602095112.GV5099@sirena.org.uk>
 <CAKohpom7XNFJ7dBzNVW0TX3gyxo4RJdJ4yriYLa_noforhyciw@mail.gmail.com>
 <20140602100201.GX5099@sirena.org.uk>
 <CAKohpomj5-tHPkBLMrgGpsDCaCxW-8hGMunMTmJgXGgEgTR=vA@mail.gmail.com>
 <20140602122332.GA31751@sirena.org.uk>
 <CAKohpo=vPojhX_9u6Coa=2Kiu0jY9hCTg2B0WiWfJS8ZQxK4Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2EnvhqpWJq810sZn"
Content-Disposition: inline
In-Reply-To: <CAKohpo=vPojhX_9u6Coa=2Kiu0jY9hCTg2B0WiWfJS8ZQxK4Rg@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.151.120.177
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulators: Add definition of
 regulator_set_voltage_time() for !CONFIG_REGULATOR
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2EnvhqpWJq810sZn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 06:44:35PM +0530, Viresh Kumar wrote:
> On 2 June 2014 17:53, Mark Brown <broonie@kernel.org> wrote:

> > If the consumer tried to set a voltage presumably it cares if that
> > voltage was set - for example if your cpufreq driver tries to increase
> > the voltage of a core supply so that it can then raise the frequency the
> > user is going to be upset if the voltage was not actually raised and it
> > goes off and raises the clock rate causing the system to become unstable.

> If the driver continued despite getting regulator as NULL, it means that
> regulator isn't a MUST for it. For example a CPUFreq driver may work
> with or without a regulator.

No, NULL is a perfectly valid regulator - the *only* thing that a caller
should check for is IS_ERR().  You are missing the point of the stubs,
and indeed the fact that real physical supplies can have exactly the
same limitations as the dummy supplies do and therefore the presence of
a physical regulator should not in itself indcate anything about what
you can do with it.

> Now if the dummy calls return *error* for some cases then these driver
> will have to do
> if(xyz)
>     API-call()..

Consumers should be implementing error checking code regardless.  If we
don't need to implement any error checking there's rather a lot of the
kernel we can go and delete...

> And so dummy APIs like clk_set_rate(), clk_get_rate(),
> regulator_set_voltage() must return zero..

Please re-read and think about my CPUfreq example.  How do you expect
that to work sanely if we don't care if any of the operations worked?

> To get rid of this in drivers these dummy routines *must* behave as
> they passed, if the drivers really care about them then they must
> quit as soon as regulator_get() returned NULL.

> This is why we have such implementations in clk framework which are
> very well thought earlier.

> Does this make sense?

No, not at all and I don't think it applies to the clock API either -
it's got similar issues with real physical clocks not always supporting
all operations.  Consider for a moment what happens if we try to set and
then use a clock rate ona fixed clock.

--2EnvhqpWJq810sZn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjJYjAAoJELSic+t+oim9zUgP/RlBJfyJKfiN5sS1FF3WjZeI
gT0JcwqcNBHAUwdm3DNOlW8l9KwHeY16gTa5uK//asN+CcE9eb7s8/LV3Ex5aYAU
JG4IE22AWxRSKTxDR+gfQZKrr+Cyyhg4PnMBN3ulv+uRh5Q1shyC5BUpGSTjEg0r
9H/9sVBlBWh5kGGuHMA1GDgImFA8+UtyMuRYq5tqKKdFD1JgwA/erJXATKOsfMyP
exMqcMjj+i4995HEC89FKOwWMS/Pp2wtPlFYPes56e53gwkx9hEb55i82zRchCWZ
KoqrTZqGlvgzN3spU8U67Q2gfFZoIhb93Qlgm7dWpxes5ESDnsSt20sTjy8R+JaO
lUhakqlRyyBtB284xQVBR4Dkrsp1bZxhSWEMd9Zyv98xLFv8+82h4WDENoeRkKMA
V1qldJFrUQ93LNUeiWt7/iaYuL1v2b55ikf6eANU0QgEzaeJpFVlJo+/Z17rygzl
dxA07cviEttnuB+IM7esi9uFiol2c5Xk84pN73D27pBx8YufPTh8Rv2H+tzmsbQ7
eObJ5PzQYMGcsv9qkywTIFFsEQJKV0a4cVe25CICQtjVqnshhvN7cr2m6AoKRavq
OP5RzhDMBZ1erJ9x03VKyCmI0HHVpDdhfQsCQLpkzg9o1L2eEFF5gllsCD4grMUP
msFlfQ9gKX0UoEtGbE69
=TwzK
-----END PGP SIGNATURE-----

--2EnvhqpWJq810sZn--
