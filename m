Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067AbaKYNvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:51:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38135 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaKYNvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:51:09 -0500
Date: Tue, 25 Nov 2014 13:49:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141125134901.GF7712@sirena.org.uk>
References: <20141125131351.GC7712@sirena.org.uk>
 <547485CF.4050600@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jX1bM1D+Mt/z9sU5"
Content-Disposition: inline
In-Reply-To: <547485CF.4050600@metafoo.de>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] ASoC: Remove 'const' from the device_node pointers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jX1bM1D+Mt/z9sU5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 25, 2014 at 02:36:15PM +0100, Lars-Peter Clausen wrote:
> On 11/25/2014 02:13 PM, Mark Brown wrote:

> >So, we're not holding references here (we're just doing comparisons, the
> >references need to be owned before we get into the core)

> The core itself will only do the comparisons and it is the board drivers
> responsibility to get and put the references. Making the pointers non const
> allows the board driver to use them to put the reference once the card has
> been unregistered rather than having to keep a separate set of pointers

Wouldn't it be even better to have managed OF references and not need to
explicitly dereference at all?  Otherwise every time something uses
managed resources for the card or component we've got a (marginal
admittedly) reference management bug.

> around. This should probably be mentioned in the commit message though.

Yes, it really should - this is really what I'm getting at here since
I'm frequently having to push back on difficult to understand changes
here.

> >I'm not seeing anything here removing casts?

> This patch used to be part of a two part series where the second patch
> removed the casts. This patch as already been applied though.

We don't have warnings at the minute...

--jX1bM1D+Mt/z9sU5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdIjMAAoJECTWi3JdVIfQooAH/Aop0MSOEdoow/KSMHXH/wiV
r/7WjlgyyGp6JuVSemw2AlUOuAZFZQEwfh7DQo0oFDcrZXTu2xXgVvzyY9vg0/y/
r/HDfZNjmZbHjnd4Mciq12NQk94v4mrSvq5sb7XIKMLHvT8CPOLZoXPcQE1neFR7
/EeyMi6WOjHl2Z+FxIdTOe6i1WjnNmGoV4ebIy1TbiPtb7zK4o97SIdW1kFN+lPK
Lo6q8nZM0wRrbqh+uvCwpbFVDQgxEWLRSp4YOEAh/it9Fg+7jKWDzGcIrZ7iFBoa
e/3y5rrFQw8DVRN+p+7OafX8BDuY81ECYNXvsp7C4S1U7QFtGcaLH1q7SZcdbx4=
=fZFb
-----END PGP SIGNATURE-----

--jX1bM1D+Mt/z9sU5--
