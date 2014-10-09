Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaJIRtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:49:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42861 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaJIRtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:49:13 -0400
Date: Thu, 9 Oct 2014 18:48:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141009174848.GW4609@sirena.org.uk>
References: <20141008195112.GI4609@sirena.org.uk>
 <54369B59.8000509@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zOAt2Xc0AZny4u/m"
Content-Disposition: inline
In-Reply-To: <54369B59.8000509@collabora.co.uk>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/5] ARM: dts: Add initial regulator mode on exynos Peach
 boards
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zOAt2Xc0AZny4u/m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 09, 2014 at 04:27:37PM +0200, Javier Martinez Canillas wrote:

> I see, I thought that an operating mode could be anything that alter the
> regulator behavior either during runtime or when the system is suspended.
> But under your definition, it is true that most max77802 regulators have

It's not just me, it's the code and all the users and documentation...

> only two modes: ON and OFF (and some of them have a third Low Power mode).

...but let's be clear, only "on" (normal) and low power are modes here.
Like I keep saying please think things through - if modes also include
enable control why would they be treated separately in the API?

> I think though that a generic way to configure this enable control feature
> is needed. Maybe adding a new pair of .{get,set}_suspend_control function
> pointers to struct regulator_ops and an .initial_suspend_ctrl field to the
> struct regulation_constraints?

> That way the core could parse a generic DT property and call the function
> handlers but each driver can document in their own DT bindings what their
> control values are and how those affects the regulators during suspend?

That maps poorly onto a lot of devices which have control schemes which
are more complex than this, for example placing regulators into groups
which are then controlled en masse or with internal sequencing options.
There's also the general taste thing with an API that basically just
consists of passing a random value through - there's a lack of
generality there, it wouldn't be possible to write a generic user of the
API which is a bit of a warning sign.

If you just care about the specific "this pin controls enable in sleep
state" I'd suggest making an interface that very specifically does that.

--zOAt2Xc0AZny4u/m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNsp/AAoJECTWi3JdVIfQsgwH/jd8peCeTLpQHtU3tSZElzrP
XbMlQgSzUEK0If+zbYk1XNEBT46MmRoKn9Zem222UUu76p9eXvPROlnPtQs7+z7I
jwnV0v1/209mxQhB9YsGUQO4WU1OPQb4nI30P0vQwaEFGVGpdV4R+JM7OLTl6J0d
Bgw70d1BdbIoDVbTpkgQItuchYJgY7jm1r2G737+0pEfWOxJm+bzDOXxqNBYL6E5
YQ8IQazxgJQxixr4Ij39luAqn75d7SxUyHdWi6ptJkWBFWNM5tvsxPgGAV6mXFdk
Qik6/uS5/xCSFyFL2pQl1i1fwagpPNXSbt5AvsX9nwbjJk4xP46zdZkY0rnQBQk=
=GylY
-----END PGP SIGNATURE-----

--zOAt2Xc0AZny4u/m--
