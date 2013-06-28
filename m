Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab3F1RDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 13:03:17 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:32994 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3F1RDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:03:16 -0400
Date: Fri, 28 Jun 2013 19:03:01 +0200
From: "maxime.ripard" <maxime.ripard@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: =?utf-8?B?5byg54yb?= <kevin@allwinnertech.com>,
        Siarhei Siamashka <siarhei.siamashka@gmail.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        Hans de Goede <hdegoede@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        =?utf-8?B?5a2Z5b2m6YKm?= <sunny@allwinnertech.com>,
        =?utf-8?B?5ZC05Lmm6ICV?= <shuge@allwinnertech.com>
Subject: Re: Re: [linux-sunxi] [PATCH 0/8] clocksource: sunxi: Timer fixes
 and cleanup
Message-ID: <20130628170301.GN4319@lukather>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
 <51CC0566.8010302@redhat.com>
 <20130627094307.GC8437@lukather>
 <51CC0BC3.5090309@redhat.com>
 <20130627165436.GB4319@lukather>
 <20130627232608.1174558b@i7>
 <2013062809433715678058@allwinnertech.com>
 <alpine.DEB.2.02.1306281559490.4013@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WoqaC9TUMqqIOlla"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306281559490.4013@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WoqaC9TUMqqIOlla
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Fri, Jun 28, 2013 at 04:02:23PM +0200, Thomas Gleixner wrote:
> On Fri, 28 Jun 2013, =E5=BC=A0=E7=8C=9B wrote:
> > > The A10 manual from http://free-electrons.com/~maxime/pub/datasheet/
> > > does not seem to contain any details about what bad things may happen
> > > if we try to read CNT64_LO_REG while latching is still in progress and
> > > CNT64_RL_EN bit in CNT64_CTRL_REG has not changed to zero yet.
> > > I can imagine the following possible scenarios:
> > >  1. We read either the old stale CNT64_LO_REG value or the new
> > >     correct value.
> > >  2. We read either the old stale CNT64_LO_REG value or the new
> > >     correct value, or some random garbage.
> > >  3. The processor may deadlock, eat your dog, or do some other
> > >     nasty thing.
> > >
> > > In the case of 1, we probably can get away without using any spinlock=
s?
> >=20
> > About the 64bits counter, the latch bit is needed because of the asynch=
ronous circuit.
> > The internal circuit of 64bits counter is working under 24Mhz clock, an=
d CNT_LO/HI
> > is read with APB clock. So the clock synchronize is needed. The functio=
n of the latch
> > is synchronous the 64bits counter from 24Mhz clock domain to APB clock =
domain.
> > So, if the latch is not completely, value of the CNT_LO/HI maybe a rand=
om value, because
> > some bits are latched, but others are not. So, the CNT_LO/HI should be =
read after
> > latch is completely.
> > The latch just takes 3 cycles of 24Mhz clock, the time is nearly 0.125 =
micro-second.
> >=20
>=20
> I really wonder why we're trying to use that timer. AFAICT the A10 has
> another six 32bit timers which do not have this restriction and the
> clocksoure/sched_clock implementation works nicely with 32 bits. So
> what's the point of using that 64 bit counter if it's horrible to
> access?

Yes, you're right. I actually wanted at first not to use a timer for
this since we had a counter to do just that.

But that's true that actually using a timer would make the code simpler
and presumably faster as well.

I'll change this in the v2.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--WoqaC9TUMqqIOlla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzcHFAAoJEBx+YmzsjxAgFRsP/jRU9Kcjh+edYCZxEAIojMAL
R1kVsy7WTvYETrv4+VSsSsX+DvNou+PGoRe136bnF34ujlxzjJV4wDB0U65p6PXw
nafA8PvWFz0dk4PWlirlifLY9EpW5Fyu/1dFXLPkmzLqnJjGVGw4wQrXlTgITVXe
ciAWhkxp3RCtJegfjAv3Qyk9z6UcF6wdChg/HOdYOYlOoIjC4ATE4KWNONZMr7e2
lEHruMQotchfF0Yu5KA3i3ZUDifcoLkKqJw3O5qWefeJq60Z6pozs63ImLDr2H7F
CP/WBN0ZOXwtxfY07tgDXCo8kJRGU/0LgI8Ys6Ias9JnEf477ih8CFpgAQWEgv4Y
4gaa1TcA/Yvjtbj5tX7dgRhUjnboCzZb9KgMjMYgr1V1q03LQkCW6dYHPA0JYci3
9e28A1iG52Zg2bqr1gW00XDEShLRZRdH6IccgR7KddXE4Re5TzVH2SBzo2fIJdhb
+vEqDLGOWSbUJRiDtyvo4NsRagcVDhNN3qDs10DDjbrupIOSfikMt+Z4KsATE663
Gqr2BU47DK2qWI2fHHNhoN7SeKoLxA5+6lr30X+jsTk23Z/tyg0FmdHJsDEeOz1h
7q1I9WAzHjGNMVg79UWuI08Ktb33iai8TE0jllC6FC0IbrgAooUgk5IIfjVcdSMe
31pJw3e8RWAj85TGkwNM
=YwQj
-----END PGP SIGNATURE-----

--WoqaC9TUMqqIOlla--
