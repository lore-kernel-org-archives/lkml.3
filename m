Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425AbaLLAYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 19:24:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56175 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933520AbaLLAYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:24:38 -0500
Date: Fri, 12 Dec 2014 00:24:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Alexandru Stan <amstan@chromium.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20141212002410.GB11764@sirena.org.uk>
References: <1418245085-9754-1-git-send-email-dianders@chromium.org>
 <20141210235347.GT11764@sirena.org.uk>
 <CAHNYxRy2t0OVj-+CqQFOfj0zWAGG0j8rmd8SxdNWgBMA2iAfXQ@mail.gmail.com>
 <20141211123106.GU11764@sirena.org.uk>
 <CAD=FV=U4RFYx9NXOACrXJZK2bKkosyYnmTZRHkXuaSz-FS9kNQ@mail.gmail.com>
 <20141211170934.GZ11764@sirena.org.uk>
 <CAD=FV=WBAuF0+BVMG9rp53Zt851Ou0kZ6xgTe9mjmgxyugWteg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZrqbukKJvfR9Lgmd"
Content-Disposition: inline
In-Reply-To: <CAD=FV=WBAuF0+BVMG9rp53Zt851Ou0kZ6xgTe9mjmgxyugWteg@mail.gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] regulator: core: Support trying to get close to a
 certain voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZrqbukKJvfR9Lgmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 11, 2014 at 11:55:55AM -0800, Doug Anderson wrote:
> On Thu, Dec 11, 2014 at 9:09 AM, Mark Brown <broonie@kernel.org> wrote:

> > Please also bear in mind the need to handle shared supplies in your
> > implementation.

> I'm being dense, can you give more details?  Do you want me to grab
> the mutex or do something smarter like track the voltage / tolerance
> requested by multiple clients and resolve them, or ...?

I mean the latter - what happens if more than one consumer is trying to
use the regulator?  This is IIRC why _set_voltage_tol() uses the cheap
and nasty implementation it does.  There's also the potential
performance considerations for the DVS type applications now I think
about it.

--ZrqbukKJvfR9Lgmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUijWqAAoJECTWi3JdVIfQ4s8H/ippCCXQNa8GHrDONciNqrE0
KXsEyrz3PxL0WXmJXabtdOM914wl+g+jBhntiv9JloBZz/0P1i8MIoBwf6C+VXnZ
BTSu7iXAudIxB20R62CcWlCsvVCo77+1p2heOg+Qxe0A9iODIMDwdKm7+b0/GcRH
ESk75sgWo3XUaQfh00Q0JOFYLc+q+H9RGEXDsRpAlxhel2NjBtkJ1Af8lAGt/cHh
jhlPJyxCCYtep/BfcFUrr7LbmEvVfHtSLjENBRZqJErHqCPYQYxrwXBUyOUWqPS0
EF5JjkITapWhld+ZNdeXlgvUrw8+zoAoNZvx91eBFhkqhAEqIhyF3w1uPoVLDS4=
=ontc
-----END PGP SIGNATURE-----

--ZrqbukKJvfR9Lgmd--
