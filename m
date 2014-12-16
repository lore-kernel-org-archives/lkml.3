Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750986AbaLPNN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 08:13:59 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33276 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaLPNN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 08:13:58 -0500
Date: Tue, 16 Dec 2014 13:13:24 +0000
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
Message-ID: <20141216131324.GS11764@sirena.org.uk>
References: <20141210235347.GT11764@sirena.org.uk>
 <CAHNYxRy2t0OVj-+CqQFOfj0zWAGG0j8rmd8SxdNWgBMA2iAfXQ@mail.gmail.com>
 <20141211123106.GU11764@sirena.org.uk>
 <CAD=FV=U4RFYx9NXOACrXJZK2bKkosyYnmTZRHkXuaSz-FS9kNQ@mail.gmail.com>
 <20141211170934.GZ11764@sirena.org.uk>
 <CAD=FV=WBAuF0+BVMG9rp53Zt851Ou0kZ6xgTe9mjmgxyugWteg@mail.gmail.com>
 <20141212002410.GB11764@sirena.org.uk>
 <CAD=FV=W1r2MXNHXTRiO1pBPWurvgqq+dSoOPgpSJ_zAbpU7T4Q@mail.gmail.com>
 <20141212125951.GE11764@sirena.org.uk>
 <CAD=FV=UfKAduhzs5-EJFZDgv-kv=rzMzuzT5N97ogdno66PqYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hSgrh6VlWhhGqruz"
Content-Disposition: inline
In-Reply-To: <CAD=FV=UfKAduhzs5-EJFZDgv-kv=rzMzuzT5N97ogdno66PqYw@mail.gmail.com>
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


--hSgrh6VlWhhGqruz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 15, 2014 at 02:11:02PM -0800, Doug Anderson wrote:
> On Fri, Dec 12, 2014 at 4:59 AM, Mark Brown <broonie@kernel.org> wrote:

> > Perhaps doing something based on the various factorings out of the
> > voltage mapping would do the trick, add a new op for getting to the
> > closest voltage?

> I'd really rather add a new op because I think it would mean that all
> the old regulators that don't implement the op would be slow all of a
> sudden.  :(

Assuming there's a not missing there...  I don't think it's quite that
bad, most regulators do use one of the standard mapping functions and
for those that are likely to matter for performance there's usually a
calculation rather than a lookup table.  That said...

> I looked at trying to refactor everything, but I think the answer is
> that I should drop my patch and consider the existing
> regulator_set_voltage_tol() experience good enough.  While I could go
> through and try to make regulator_set_voltage_tol() better:

...I do agree that the current situation is probably adequate though,
the optimisation would be nice but it's mainly going to benefit corner
cases.

--hSgrh6VlWhhGqruz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUkC/0AAoJECTWi3JdVIfQHakH/2WNWECPyjwBDYR61+U6arFY
JZQOsj8tR0u5Pt/ngC5VorBWhc3mg+Ehn8CKCBwu/TXhrxhPTXjgKzqut60TtD3e
n2PaMMUDPEROSuBgBzrHnL5M3gsK7KfynETuKlum4SzuOWZxhKY45SFCjzQSAMuz
bUdntlPj2bFhaIvtHb59FtA1XnYhBL1Kw5ZQJezoorHwO5kgM+BYzRslz9/J3eX3
b+M9R2HWNjyKNBKrWJIAyKvxdxIgsvI/7yjC04hvIRzKzsnqNsIXqzTUPT9N5jIM
EF16FQcIMpvCl/nGSyrwAMnRsiN31V9g9cv3VrS/F/lUD9XUo01L1kpZvof5Fpg=
=fCiR
-----END PGP SIGNATURE-----

--hSgrh6VlWhhGqruz--
