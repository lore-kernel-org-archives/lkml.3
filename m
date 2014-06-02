Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbaFBMYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:24:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50811 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbaFBMYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:24:00 -0400
Date: Mon, 2 Jun 2014 13:23:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140602122332.GA31751@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
 <20140527192923.GC12304@sirena.org.uk>
 <CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
 <20140528173858.GG5099@sirena.org.uk>
 <CAKohpokk_sNQ7Be5F8NLa7pLrssPm9qPf-fDEUYkiurJ6Etrpg@mail.gmail.com>
 <20140602095112.GV5099@sirena.org.uk>
 <CAKohpom7XNFJ7dBzNVW0TX3gyxo4RJdJ4yriYLa_noforhyciw@mail.gmail.com>
 <20140602100201.GX5099@sirena.org.uk>
 <CAKohpomj5-tHPkBLMrgGpsDCaCxW-8hGMunMTmJgXGgEgTR=vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <CAKohpomj5-tHPkBLMrgGpsDCaCxW-8hGMunMTmJgXGgEgTR=vA@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.124
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulators: Add definition of
 regulator_set_voltage_time() for !CONFIG_REGULATOR
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 03:45:37PM +0530, Viresh Kumar wrote:
> On 2 June 2014 15:32, Mark Brown <broonie@kernel.org> wrote:
> > No, think about what you're changing here.  You're changing the stub -
> > the stub has a regulator_get() which always succeeeds.

> Now, why do we want to return -EINVAL from set_voltage here ? Similar
> routines in clk-API are returning 0 and even clk_get_rate() returns zero,
> unlike in regulators, as we return -EINVAL..

If the consumer tried to set a voltage presumably it cares if that
voltage was set - for example if your cpufreq driver tries to increase
the voltage of a core supply so that it can then raise the frequency the
user is going to be upset if the voltage was not actually raised and it
goes off and raises the clock rate causing the system to become unstable.

> Not sure which of these frameworks is doing the right thing.

I don't think the clock API should have clk_set_rate() report success if
it was ignored.

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjGzBAAoJELSic+t+oim9vwgQAIFcLSXcqaPUafgIIg3dW9Bl
Neq0lRwwMvUVuE0LLxknsuH0AsJVx9ogzZ7EiLh5xU7Ud3pvRSor4hDcdHL4dW1g
JRPIdGf34oYSbq/JpPfil7fE/fYHWtwVq38oeH322mRqiBF8dYu5WLbNWeOaeUdo
DqCHTbVdLUVLCUQ6cRfSmDSKdzXWx9CV1ZKVHIkPcALVKo1gy4iU27Ub1nkTjbnP
IXrysdEwxJA3+U3tvEveUvBbLU491GF3Kvl+Uv1My8z7UHZb7a8B+DwKjvjCaiuf
oxp3/WEaprTpqGU5dNjxbvF7ifbLNz3O/DVe8bxHMIoV8u3Q8VxLnuZSpk74AXgv
Xc7F24LzCesRDE0XqLmcHiC+D7Tz0xvFrakCbWSWkk18wjVPS5cYFy28jtywYoj+
ZYlwgerCUhCQNQEfExhBHAzjYlGUSwCUwWatQLWOlojftgTnLKRI6StTR5YENFW1
VoXE7YJXM3QAqt3M7cJE6kA0a3fGl4+gHYZxILizG4Y4I6PuVyilTfPaOOFbmF+s
BKq5BKdJbUoWHLs7K4Ekb1riEalQM0ul1Mx+a0Y/Z6YdNJE57hxuDA2WrYjxDTUQ
5ORu6uY0bRS8TfbZEUoPhP+3HpAgDpJkoAeDQEgkgCaCIum02hJcz8EDcqyBB/rU
F4iGxntM7fYcWQjeMAZ9
=Vv4j
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
