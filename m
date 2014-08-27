Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965295AbaH0VEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:04:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36679 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965201AbaH0VEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:04:08 -0400
Date: Wed, 27 Aug 2014 22:03:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140827210350.GD17528@sirena.org.uk>
References: <20140827183733.GN17528@sirena.org.uk>
 <53FE25EB.7060702@gmail.com>
 <20140827184705.GO17528@sirena.org.uk>
 <53FE2901.50508@gmail.com>
 <20140827191526.GS17528@sirena.org.uk>
 <53FE2F9E.80501@gmail.com>
 <20140827194411.GU17528@sirena.org.uk>
 <53FE387F.3030302@gmail.com>
 <20140827202554.GW17528@sirena.org.uk>
 <53FE4286.3050305@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2RIAITazYFwT/YFl"
Content-Disposition: inline
In-Reply-To: <53FE4286.3050305@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: max77802: set opmode to normal if off is
 read from hw
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2RIAITazYFwT/YFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 27, 2014 at 10:41:42PM +0200, Tomasz Figa wrote:
> On 27.08.2014 22:25, Mark Brown wrote:

> > Well, presumably the bootloader is going to run again even for a warm
> > reboot?

> This is strange, but apparently it's not the case for the hardware which
> this patch is supposed to fix or at least this is how I understood it.

Fun.  It's like everyone was setting out to define the most fragile
system they could, from the chip design up...  so many moving pieces
that have to line up.

> > It's not in general true that Linux should never change the mode (the
> > main case for toggling modes is usually going between an idle/suspend
> > state and active state)

> I believe this is yet another reason why we should have a way to specify
> opmodes in DT, now not only active but also suspend/idle opmodes.

> However on many PMICs this is a bit more complicated. There are opmodes
> such as

Well, quite.  Plus the more basic question of what a mode actually is
and how you talk about them generically.  It's not that there's no use
for this functionality, it's that it doesn't lend itself to defining
ABIs.

> > You're talking about the case
> > where the bootloader does set something but avoids doing so on warm
> > reboots only here.

> From Javier's description I understood this is the case for the board
> for which he develops.

No, the issue is that the bootloader isn't touching the regulator then
Linux turns it off, reboots and ends up thinking the default operating
mode is off which doesn't work terribly well when it tries to enable the
regulator.  The reading back from hardware is trying to implement the
standard Linux behaviour of not changing a setting without explicit
permission, this change is providing a fallback for the case where
that's giving us something obviously wrong.

> > Besides, even if we did have a way of specifying modes in DT (with all
> > the problems that brings) we still have to pick a default if that's not
> > used).

> Sure we do and we can define the binding to default to something (e.g.
> normal mode) if respective property is not present. Btw. the issue with
> opmode also affects other PMIC chips such as Samsung S5M ones.

That's then going against our purposely conservative implementation, and
would be especially bad if it overrode one of the hardware managed modes
on an otherwise unused regulator.

--2RIAITazYFwT/YFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/kezAAoJELSic+t+oim9LPsP/3BYo98aFAqI01X/ynGe22S1
ZFy/iFZi4TOzqhYQDIEHUwQsrf8v2OEKdDNHoadNrJU5B52S909diuGYMfI9KaGT
b7SwsHaVXJ/VJBjoj4+Dt5l0Q5MWSlEP07nvlN3YulH5r4Bg8FSkGNAxjW7boFG+
xSaEJuCLlsacGDAiQc/WA3RTTTtLAtojACYrupUNsD1UQRK56nlwN1JEJdlimEi0
lJC9yqwVQuaJgoDdh/Tr0C3afTnNXmOa9JkmG6zKgHxm+ZvR3jqb7PrkbqC1mdip
QriL4z7O6+BCYWLQbpJ70FlmbSKQx48sUTZ7pB7SoVc+mC1ekX4ohI9dITBmVHli
sMShbRS5XwCkQS8fYxGmKT+Lil2vf9h01AZvicwpz+lO/UPsXWbMghtGyxFH4DnS
VFpRaatx/nvxcJ3QBKD2T+Xb8t1EqCbzj7ZqSWA6UL5A5Phjts/PeAjFXgvuoR4s
u0AFzMAX53TdIPDv3vvjoBZAzDHnQpqlmoL2mgPcOlE//3Z7s1397ZrKZIKi+WuN
F68HQ1/X+VgyvCNpRoc0NDMPWUqwwmIxw4mAhKGgmNYUxS9PQV0khaKCQrhMisCG
L25SId4lB6pBuZsLcUmt6CO2sNO4q5/U9FEVACnTPEhats5dsQlhqy91oStWVb1N
YekNSkItnuyZbljsvREG
=dCU2
-----END PGP SIGNATURE-----

--2RIAITazYFwT/YFl--
