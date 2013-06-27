Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab3F0JgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:36:01 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54077 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3F0JgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:36:00 -0400
Date: Thu, 27 Jun 2013 11:35:58 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, kevin@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/8] clocksource: sun4i: Add clocksource and sched clock
 drivers
Message-ID: <20130627093558.GB8437@lukather>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
 <1372281421-2099-3-git-send-email-maxime.ripard@free-electrons.com>
 <20130627060234.GD4824@tarshish>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
In-Reply-To: <20130627060234.GD4824@tarshish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Baruch,

On Thu, Jun 27, 2013 at 09:02:34AM +0300, Baruch Siach wrote:
> Hi Maxime,
>=20
> On Wed, Jun 26, 2013 at 11:16:55PM +0200, Maxime Ripard wrote:
> > The A10 and the A13 has a 64 bits free running counter that we can use
> > as a clocksource and a sched clock, that were both not used yet on these
> > platforms.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  drivers/clocksource/sun4i_timer.c | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> >=20
> > diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/su=
n4i_timer.c
> > index bdf34d9..1d2eaa0 100644
> > --- a/drivers/clocksource/sun4i_timer.c
> > +++ b/drivers/clocksource/sun4i_timer.c
> > @@ -23,6 +23,8 @@
> >  #include <linux/of_address.h>
> >  #include <linux/of_irq.h>
> > =20
> > +#include <asm/sched_clock.h>
>=20
> In the tip.git tree (and -next) this header is moved to <linux/sched_cloc=
k.h>=20
> in  38ff87f77a (sched_clock: Make ARM's sched_clock generic for all=20
> architectures).

Ah, good to know. Thanks!

> > +
> >  #define TIMER_IRQ_EN_REG	0x00
> >  #define TIMER_IRQ_EN(val)		BIT(val)
> >  #define TIMER_IRQ_ST_REG	0x04
> > @@ -34,6 +36,11 @@
> >  #define TIMER_CNTVAL_REG(val)	(0x10 * val + 0x18)
> > =20
> >  #define TIMER_SCAL		16
> > +#define TIMER_CNT64_CTL_REG	0xa0
> > +#define TIMER_CNT64_CTL_CLR		BIT(0)
> > +#define TIMER_CNT64_CTL_RL		BIT(1)
> > +#define TIMER_CNT64_LOW_REG	0xa4
> > +#define TIMER_CNT64_HIGH_REG	0xa8
> > =20
> >  static void __iomem *timer_base;
> > =20
> > @@ -96,6 +103,20 @@ static struct irqaction sun4i_timer_irq =3D {
> >  	.dev_id =3D &sun4i_clockevent,
> >  };
> > =20
> > +static u32 sun4i_timer_sched_read(void)
>=20
> You commit message mentions "64 bits free running counter", but this one =
only=20
> returns 32 bit.

Yeah, the callback setup by setup_sched_clock is supposed to be
returning a u32, and clocksource_mmio_init only accepts up to 32 bits as
well, so I'm only using the lower 32bits of this 64 bits counter.

I'll amend the commit log to state this.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzAd+AAoJEBx+YmzsjxAgBroP/3O3tOGNVS/o+AWA1vgmJdKj
kdc64BXIqE4HUOlkaHy37AeOCF/1o4sY55Y9dC3wk+qbEKOLvt5QSVvAcECb95ws
KUC3ad3suFAwkSB0PZKykUyhNONQyoJLKxYBC0z7DT3gykFSK00SrcouATskUoMN
kFSsmkf/GsNm+WMuQpA7XpU2nk9SVN4B5cfRHTqnoxcxCRvLTn3Jfp8b7xiNqKPl
loipXWxLe5YZLf0mQOq3bNfTxn3fs0/MDto+R+6XAeAFvmoS6vg2gK41viXWLyts
1VIHNiIdd91XrjUSPLP1OI8lbfGNg7XgVTVJaYBEbYicBj/NrBiyJqtDOcE0CR16
ml10HnrF+Ln+g6mnmhayuvqsgdYEBm6vQB9slCI/0yLttrx481KmCHqDtcXW0Lfg
H7eLNeFvwyyD4ar1kEYwGk77gWrznbesW2aIgV6ktlt+1ovZzfaIlxTSz5XXDjq5
gMkjQVrMnKtisj8q81sj8a/foou0Qb63Ro9jWXQwviLmLfIk0ejaqYR1oNZ1Z66s
jOBIAFttpOdzCxc7WpSzutoqGRfw/f2wxEqpNPAtPBILPy6ZNCwvHIkCtGF3SlWt
wh0G2LenUOPzRSqTBd4Rm3LL7OEfxlwH/yzjEP2qgaLgjoWGnZAPQubIwtwZ5gMu
VA0nIZZdZI1pMi+4rR/k
=uviE
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
