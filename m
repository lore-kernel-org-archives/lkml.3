Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3F0Qyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:54:40 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56033 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3F0Qyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:54:39 -0400
Date: Thu, 27 Jun 2013 18:54:36 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-sunxi@googlegroups.com, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH 0/8] clocksource: sunxi: Timer fixes and
 cleanup
Message-ID: <20130627165436.GB4319@lukather>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
 <51CC0566.8010302@redhat.com>
 <20130627094307.GC8437@lukather>
 <51CC0BC3.5090309@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <51CC0BC3.5090309@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 27, 2013 at 11:54:11AM +0200, Hans de Goede wrote:
> Hi,
>=20
> On 06/27/2013 11:43 AM, Maxime Ripard wrote:
> >On Thu, Jun 27, 2013 at 11:27:02AM +0200, Hans de Goede wrote:
> >>Hi,
> >>
> >>On 06/26/2013 11:16 PM, Maxime Ripard wrote:
> >>>Hi everyone,
> >>>
> >>
> >><snip>
> >>
> >>>It also finally adds a clocksource from the free running counter found=
 in the
> >>>A10/A13 SoCs.
> >>
> >>Hmm, have you benchmarked this? There have been reports from linux-sunx=
i kernel
> >>users (xbmc project) that the waiting for the latch is quite slow. Note=
 we
> >>don't have anything better yet in the linux-sunxi kernel.
> >
> >No. I didn't.
> >
> >Do you have any pointers to these discussions?
> >
>=20
> The original discussion should be somewhere here:
> https://groups.google.com/forum/#!forum/linux-sunxi
>=20
> But I could not find it (it is probably hidden under
> an unlogical subject).

I searched a bit and it seems to be that discussion:
https://groups.google.com/d/msg/linux-sunxi/gaTDngPT7Is/oeLtWb1N1wIJ

> Looking at my own notes (a small TODO file), I've
> written down that the reporter reports:
>=20
>  -current clocksource can cause us to run with interrupts disabled for 17%
>   of the time, see "perf top" output
>=20
> This is with a workload which does a lot of gettimeofday
> calls.

Siarhei however notes that even higher-end SoCs like the exynos5 have
similar performances with that regard. So I'm not sure we can do
something about it, except what is suggested in the above mail, which
looks rather unsafe.

Anyway, like you said, we have no easy other solution, and we lacked
such support until now.

So why not merge this code for now, and try to optimise it later if we
find it's needed.

> I notice that unlike the sunxi-3.4 code you don't do any locking,
> so how do you stop 2 clocksource calls from racing (and thus
> getting a possible wrong value because of things not
> being properly latched) ?

Hmm, right. I'll add a spinlock.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzG5MAAoJEBx+YmzsjxAgJy0P/im+hVimsLdzPzQLWOSEVzVU
D9JRPSjvS4PE80SZC89HPHJhet454AiV9hyBJAoBhnH+VO7r3/5b+VJc0xcv4bON
oiP3Xi5jZ9dfO5DnOod2o5hEtU0xSRNCDRmlZd114NH7gmpiiUBVjJK3BgP1NCa8
52CTFlO+uAY0tPkbh0jWpnzADIW5tgGkTAJb6Nu+qY8/WhRTGnFdaGfcwf4WrdHV
BL5LJOYqMHMTnnLcFJbeT2fUuKEVQnzVQjZIVSagWoqyKKrjX1Gu6gR6ctGRdjwc
OoyXkpGIASG4m296a2iwttrzyM0GhMpHlIr5tuAmKJBe1MuR4NyNfFG5IjhTFr0P
LTjUYnuQu1V8zzvdjsikiIEo6V+rP9KK8Zn9QxLxAwH95xBR7jJdYZZoCJRQqQmz
qbvAKGEtUbIORfUzECoQrABUCy/mNG2LIX8BMbL05pCgTXuTDX2ccWk6i/5IkKy9
OnNqYbdrz5CXwrdB7UCOSEtvGPWt4wgF8t3ZOuYkvCagMC9t/5g8QBR4wo4Mu0nd
UO+9rNySH+5k8/60z97mwhPoISv04MdTGzZte4ApWQvJmoVhdgX/Ki/sSAR9VWgb
NjYHi+HS0htUk4GXGcLEz/UhggEMrEY7ZaM3LXeJt4nEDp0d6Ifv/ZWakFJOh9Td
OnI2hwh0NMDJDihk0lDe
=HYce
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
