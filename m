Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaCNT0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:26:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43379 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbaCNT0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:26:52 -0400
Date: Fri, 14 Mar 2014 19:25:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>, Liam Girdwood <lgirdwood@gmail.com>,
        Jenny TC <jenny.tc@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Message-ID: <20140314192524.GB366@sirena.org.uk>
References: <1392875640-29230-1-git-send-email-jenny.tc@intel.com>
 <1392875640-29230-3-git-send-email-jenny.tc@intel.com>
 <CACRpkdaU44iinj2iDNdYm62J+4jQbg+XJ=Zq4GmJryPeu7GfTQ@mail.gmail.com>
 <20140228100114.GA13189@amd.pavel.ucw.cz>
 <CACRpkdaZ2moqGWx2BpfEeKoW6doXg67TkJKY+mbg4hrFHDr16Q@mail.gmail.com>
 <20140307201039.GB27645@amd.pavel.ucw.cz>
 <CACRpkda_9UG70G-b3eGTccr22WC4eoAbj0g2QgX0DRSYVgvrxA@mail.gmail.com>
 <20140313091234.GC9494@amd.pavel.ucw.cz>
 <CACRpkda6VOStrazzMXXUFOQZsr1P0amVdyzLQ_wTHXmshsV2=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iNbuUyhyM/niA6/9"
Content-Disposition: inline
In-Reply-To: <CACRpkda6VOStrazzMXXUFOQZsr1P0amVdyzLQ_wTHXmshsV2=A@mail.gmail.com>
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iNbuUyhyM/niA6/9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 14, 2014 at 11:36:40AM +0100, Linus Walleij wrote:
> On Thu, Mar 13, 2014 at 10:12 AM, Pavel Machek <pavel@ucw.cz> wrote:

> > But... what would actually help: I believe we should introduce
> > milivolt_t, miliamp_t, milisec_t etc... types. Storing milivolts in
> > int, then having comment saying "milivolts" is just wrong.

> Hm! I bet the regulator subsystem maintainers have opinions
> on that.

The regulator subsystem is quite happily using unsigned ints here,
usually we're using hungarian style names to clarify the type where
that's useful (it tends to be closer to the usual naming conventions
when representing these things mathematically).  I'm not sure that
having a typedef is going to buy us terribly much unless we convert the
kernel to C++ where we can do more exciting stuff.

I would say that we are using microvolts rather than milivolts since it
does occasionally matter.

--iNbuUyhyM/niA6/9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTI1ehAAoJELSic+t+oim9qmoP/Ripi+BBz/3FzmqwZJUwMuBs
8OrQ2Yr9Yez0ZtV73nzfVnKK5q53InLjSUkfVdoA7xB1XJokWFAGel+cWNLCyZNs
vxW180APi1XhKKz7EmULfewe7hC7t8C3/tyzrfqZ5au0ngC7dCR9dZY+0dEKrT/0
TSarW5jk2Z4O2ETVhhq2TJ3mZHh/6fV1A0M1jzwEBtMHdzGMQnJIwXTy2QFUf0OD
fXkAqtspPG2eRGAbwGANbNZS8V8tgnAAwYutRVdjNSclS01vAJMgT6QxKcCVvLRB
PkqRHnQDLELaxSV88F95lURmQjFCuuU8COzK4xnNntrjHmbcUlBspKXRkNj+hAg4
0AoNH+FSx2JxWjKW0fO8ifzYGxMHfdBgMHlq+5zKfHDz9S9y7DpP9xVG6ieAxzrh
AvDqmvDBh4qvXenu5eVEQMn/JDtcKaIkQ1f6HXCU80lVjc8dco8oeybcvvauO3L2
XW3AhLDn1bXLFqbT2h5iUPIzo3mO5PFmTs01EgLQE3Qs/zb8SeIhttyl8p+ETlqw
dxpmYNAjEa0xl7NXpiXkTM53TLWE9tEu1fXu1CSAl9ZXz1FxO7A8RU/WsfZJs2L6
j+XAbYzVD9d1oiYA0Q5Q534RWyFeUOtgIBMe+9qinPklsCkWO5VAklsBts8EKAz5
IcRkV5+OeFigcoCs5pnk
=LQJB
-----END PGP SIGNATURE-----

--iNbuUyhyM/niA6/9--
