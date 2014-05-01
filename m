Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaEAB2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 21:28:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53398 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaEAB2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 21:28:45 -0400
Date: Wed, 30 Apr 2014 18:28:25 -0700
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Inderpal Singh <inderpal.s@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Pawel Moll <pawel.moll@arm.com>
Message-ID: <20140501012825.GI3245@sirena.org.uk>
References: <1398749704-10196-1-git-send-email-inderpal.s@samsung.com>
 <CAD=FV=Vo+GLTt7fh4639XFsJfSUTN0ARBsOy+O24gtB_87MgLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ev7mvGV+3JQuI2Eo"
Content-Disposition: inline
In-Reply-To: <CAD=FV=Vo+GLTt7fh4639XFsJfSUTN0ARBsOy+O24gtB_87MgLw@mail.gmail.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: virtual: Introduce a new virtual locker
 regulator type
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ev7mvGV+3JQuI2Eo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 30, 2014 at 11:56:08AM -0700, Doug Anderson wrote:

> I cornered Rob and Mark Rutland a little bit about this at ELC today
> (sorry!).  Neither of them was a huge ran of adding a pseudo device.
> Rob suggested that Mark Brown might be the best person to give
> direction here.  Mark Brown: any thoughts?

I glanced at this briefly and couldn't really understand what it was
supposed to do from a quick glance but I do tend to agree that it's too
complex and confusing.  Quite what the virtual regulator is supposed to
represent or how it is used is distinctly non-obvious.

> Potentially we could also make this type of thing a core regulator property:

Yes, that seems like the obvious solution if it's in the core.  Someone
would need to write the code of course.

> Another option is to add no device tree code at all and add code to
> the devfreq / cpufreq drivers used on this device.  In order to do
> this cleanly I think we'd need to extend the regulator core's
> notification scheme to introduce a new event:
> REGULATOR_EVENT_VOLTAGE_CHANGING that's called _before_ a voltage
> change happened.

That only works if it's the same thing scaling both voltages.  That
might be true most of the time but is it true all of the time?  If it is
then that's great.

--ev7mvGV+3JQuI2Eo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYaM2AAoJELSic+t+oim9dNUP/Ry/HZGAKdpX7qg73Q6Mlbf9
NOoaGS1RJN+c4Ulw3nHBfC2de0obF+4tzehFJ6OzcUivZG6gViKbtXBIsRJtWftR
Hh9Jck+eSzunLBC+2Xp7J14C6+6/Sc3pl7VqeKsv+Uq5o1+vdpt9qOl9KZU0RxKm
dQLowKZ67/bPOiRAbOnu4yv2pdtJACcX8L5tnGegBfvJjEXzHQJWfEsR9x9AlJ97
3glCwYPELQBqCQAdXlZG8FdMgPPnOd1piR+YBbzjdSfKclmK7TwUR/NTtO6LvWEz
8k9QJHs7iZf9gxuW/Xy4JuuiFAw04MCnCgOUmj+D8Q/VDFgXmlP+agOeoQisa+Tt
6XW5GTuS4+AtaaSM6ttbsHyTZDSEhQrrtssWGv4flrd7NucygcFyo0upKqyqywlL
NwW3jD5hrcaYvKspT+M0GP3r6VBxstIoT5GHkO3YznTelt1bUET0qd6p8sB3ie4/
zejiY6YEZrZFj0AstQhqa+vULQesi1Eyb7TWE/fh52gKeCc2Ike8Tfa2pX3KE1ik
6qmx2NmPKHg/MNgHY6713sTgVlR3wXrB8JUVE9QvkV5ZwT+wm2Nniz5h7UHV7TuS
jLHVgMY2jHxKPhksegwX5QejTxIU7b6uLi0TXpIqC6gyfI0+u4v7KVNAkxxB3vC5
tnYLLeeIMwQ1K/YSHaIG
=d4rc
-----END PGP SIGNATURE-----

--ev7mvGV+3JQuI2Eo--
