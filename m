Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab3F2GsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 02:48:19 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:34948 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab3F2GsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 02:48:18 -0400
Date: Sat, 29 Jun 2013 08:48:15 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Emilio Lopez <emilio@elopez.com.ar>,
        kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCHv2 4/8] clocksource: sun4i: Fix the next event code
Message-ID: <20130629064815.GA2593@lukather>
References: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com>
 <1372449386-1334-5-git-send-email-maxime.ripard@free-electrons.com>
 <alpine.DEB.2.02.1306282204220.4013@ionos.tec.linutronix.de>
 <20130628210853.GB2756@lukather>
 <alpine.DEB.2.02.1306282322480.4013@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306282322480.4013@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2013 at 11:27:25PM +0200, Thomas Gleixner wrote:
> On Fri, 28 Jun 2013, Maxime Ripard wrote:
> > On Fri, Jun 28, 2013 at 10:13:08PM +0200, Thomas Gleixner wrote:
> > > On Fri, 28 Jun 2013, Maxime Ripard wrote:
> > > > @@ -61,9 +62,14 @@ static void sun4i_clkevt_mode(enum clock_event_m=
ode mode,
> > > >  static int sun4i_clkevt_next_event(unsigned long evt,
> > > >  				   struct clock_event_device *unused)
> > > >  {
> > > > -	u32 u =3D readl(timer_base + TIMER_CTL_REG(0));
> > > > -	writel(evt, timer_base + TIMER_CNTVAL_REG(0));
> > > > -	writel(u | TIMER_CTL_ENABLE | TIMER_CTL_AUTORELOAD,
> > > > +	u32 val =3D readl(timer_base + TIMER_CTL_REG(0));
> > > > +	writel(val & ~TIMER_CTL_ENABLE, timer_base + TIMER_CTL_REG(0));
> > > > +	udelay(1);
> > >=20
> > > That udelay() is more than suspicious. Is there really no other way to
> > > deal with that hardware?
> > >=20
> > > If no, you really need to put a proper explanation for that into the =
code.
> >=20
> > The datasheet states that you have to wait for two ticks of the timer
> > clock source (in that case, 24MHz, which makes it around 80-85ns) before
> > you can actually enable it back.
> >=20
> > I didn't came up with a better solution.
>=20
> 80-85ns is definitely way less than 1us.
>=20
> Why not reading the counter register and wait for 2 or 3 cycles to
> elapse instead of wasting a full microsecond evertime ?

Yes, but then we fall back to the discussion we had in the v1 about the
latch needed to read the counter, which would already take more time
than what we have to wait for.

Maybe we can use the second timer that we use for the clocksource
though: it's always running, already set up, work at the same rate and
we will only read it, so we won't change its monotonic nature.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzoMvAAoJEBx+YmzsjxAgdIEP/RWXulISbfds5WRvf796Wk+Q
x1WJM1gymJDjiLpyyavj12PwuO18OQG5oSgzOEEwamxlWZcLqmGlu8ulqiaxzKqp
aM5pjJX/RL7Dtp+avCaE1KBvnGWPEqC4HrgtQwViWIRN0S8sAqN4K/Svjgd0X6i0
eEnqjAQERm04xnSgMXjEkxoHAWRKfE33txFY78Yz1OQq6z/6xzIdpd+F7ZX1qWnG
i0NlO229Rwt3F7mGNZNg9ySDiXTNQpxQu/432qkxsLdHXXwfo45jcBsuxRs/kk71
EC311Wm3E8RGq5UyV1XgeLcTe4ghDVCEyXushSN9aR7Hh58O/7iM4odI5CNjI/mR
h7uB+SRW+ThC8BjkySpNSUQ12isiy1Br308e3RZNKdEENQKvfVechS00NlkrC4Od
i5Go0CT6BNzCmsKUP4KTJRoPiPEGCdlIpi8ewg0bwPXnz04FLeWaJhRDuup6oMdp
gjJwS2l3pF6wSLgpYEfwll+7osQYtlC9c0R6TX4vsSI2Mg9bpayQb1HCrLFi579N
ns6QGKKW1LuP2HqTXweyG/Y7yi9Fhq7dUoPlcLRHYY/TdKAevOo1FmLnU4zk4dVu
/Xp0rBuhYMdQV4tB2yiz8K+BGf3yGZteVqGAI82ozu3qzSVynqW+WxLLRkKPs/W0
zaijkj0tLB4qZxbF3OZx
=PFNa
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
