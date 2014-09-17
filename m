Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaIQS2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:28:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59614 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbaIQS2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:28:31 -0400
Date: Wed, 17 Sep 2014 13:27:37 -0500
From: Felipe Balbi <balbi@ti.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>, <nm@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: prevent erronous parsing of children during rate
 change
Message-ID: <20140917182737.GF8140@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408628866-32351-1-git-send-email-t-kristo@ti.com>
 <20140903192203.11368.5520@quantum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1Y7d0dPL928TPQbc"
Content-Disposition: inline
In-Reply-To: <20140903192203.11368.5520@quantum>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1Y7d0dPL928TPQbc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Wed, Sep 03, 2014 at 12:22:03PM -0700, Mike Turquette wrote:
> Quoting Tero Kristo (2014-08-21 06:47:45)
> > In some cases, clocks can switch their parent with clk_set_rate, for
> > example clk_mux can do this in some cases. Current implementation of
> > clk_change_rate uses un-safe list iteration on the clock children, which
> > will cause wrong clocks to be parsed in case any of the clock children
> > change their parents during the change rate operation. Fixed by using
> > the safe list iterator instead.
> >=20
> > The problem was detected due to some divide by zero errors generated
> > by clock init on dra7-evm board, see discussion under
> > http://article.gmane.org/gmane.linux.ports.arm.kernel/349180 for detail=
s.
> >=20
> > Signed-off-by: Tero Kristo <t-kristo@ti.com>
> > To: Mike Turquette <mturquette@linaro.org>
> > Reported-by: Nishanth Menon <nm@ti.com>
>=20
> Applied to clk-fixes.

v3.17-rc5 and today's next still exhibit the same bug. Any chance we can
this fix into v3.17-final ?

--=20
balbi

--1Y7d0dPL928TPQbc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUGdKZAAoJEIaOsuA1yqREqOcQAKZGG5v2Dwc0K9lysU0ROfyJ
VxkFSS9AsOvh0diT+vWZAoLV6cdz/RiX81LzDZpOzmnInJlOidXUV8u7NjJsTIev
fN0rnVDy8ifDznOCnYX9ToUMC3SkTdFgWwTuY+JfI3kfcXcx+vSgj9c8RBwPzzjd
7LcJvfiR9H6HRpW/OtLyYaiGtlf9Si2p0/NTaUqYFVHxRHP3Hgp1y/M14QlvqPiq
2y5sJc0nAE27eiJFqpMaMFGOvnWJcBbUoF6wJLSSBazuIsO8AiChPU/IcIhgYmC1
iTUR5G915DChXgwEtHIB0WRX8U8yajuYWF2wnAolld4Ht6YwZwdbpvovwPsl4Kt2
39k2pwGi+7Dx5YXvfnc6RdrDogPwcGuerxLyIGdYISALsq6iK41y5engfloAHwbm
l1TSKZl04X9nNzJFY2aoLXwMjOdRWgy0Gjw4ZR+Ykk6ibWJBMSCA2lu3qaI3c+ze
N9NyBHEwa7Z/uTGP0PJrj50XRXCmH+NzIhZDKEmvKdxOvh/RMT/WtqPisSN2Tqbt
XVy4ffFMIBg+mjykP2bX3FuGOGp1zF/0t9wP8nOVGmyJ78GVsGziZw7idLq5OuAy
C+t6WKivJfPhNlkuAlxclnh1qNW2LK005N+dMBWOX+6gAWzViQc7gwrLz4v/sLP4
zKH528Mq112Kviy3YjDI
=OStr
-----END PGP SIGNATURE-----

--1Y7d0dPL928TPQbc--
