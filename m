Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3KYSw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 13:52:29 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:49031 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3KYSw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 13:52:27 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for automode
Date: Mon, 25 Nov 2013 19:52:22 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: Sebastian Reichel <sre@ring0.de>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <201311251510.00987@pali> <20131125151838.GD21526@amd.pavel.ucw.cz>
In-Reply-To: <20131125151838.GD21526@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1742409.h6PmHPnvMv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311251952.23194@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1742409.h6PmHPnvMv
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 25 November 2013 16:18:39 Pavel Machek wrote:
> On Mon 2013-11-25 15:10:00, Pali Roh=C3=A1r wrote:
> > On Monday 25 November 2013 15:01:27 Pavel Machek wrote:
> > > Where can I get dsme sources?
> > >=20
> > > 									Pavel
> >=20
> > dsme daemon: https://gitorious.org/community-ssu/dsme
> > dsme thermal plugin:
> > https://gitorious.org/rx51-bme-replacement/dsme-thermalobje
> > ct-surface
> >=20
> > dsme thermal plugin is responsible for checking temperature
> > of battery and send it to dsme damon. dsme daemon itself
> > checking temperature limits and do something (e.g reboot
> > device)
>=20
> Thanks for links!
>=20
> AFAICT.... dsme daemon does some kind of system management,
> not directly controlling charging, right? It does monitor
> system temperature.
>=20

Yes.

> Now.. Imagine phone left in car in charger (on sun). Likely
> temperature will reach high values, kernel is charging, dsme
> will reboot the system, but kernel will start charging again,
> dsme will reboot again, ...
>=20
> And it is not only high temperatures that are problem for
> li-ion charging; battery should not be fast charged below 5C
> and should not be charged below 0C. (Again, both are likely
> to happen if you leave your phone in car).
>=20
> AFAICT, we should simply disable charging below 5C or above
> 45C.
>=20
> 									Pavel

Similar patch (as this) can be added to check for temperature=20
from specified power supply driver (in timer reset thread). This=20
can be easy and will fix this problem.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1742409.h6PmHPnvMv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKTnGcACgkQi/DJPQPkQ1IXKACfSgKKhTWlMYtzZRHnh33u/Hst
CNMAniaXzXBwrIa+qQV0ZBRuDVKDHtrq
=KPEE
-----END PGP SIGNATURE-----

--nextPart1742409.h6PmHPnvMv--
