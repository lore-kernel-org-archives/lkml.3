Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3LQM0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:26:04 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:43996 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3LQM0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:26:00 -0500
Date: Tue, 17 Dec 2013 13:24:33 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, mark.rutland@arm.com,
        s.hauer@pengutronix.de, galak@codeaurora.org, swarren@wwwdotorg.org,
        t.figa@samsung.com, grant.likely@linaro.org, matt.porter@linaro.org,
        rob@landley.net, tomasz.figa@gmail.com, ian.campbell@citrix.com,
        pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Alison Wang <b18965@freescale.com>,
        Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv7 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20131217122431.GA17210@ulmo.nvidia.com>
References: <1386925027-16288-1-git-send-email-Li.Xiubo@freescale.com>
 <1386925027-16288-2-git-send-email-Li.Xiubo@freescale.com>
 <20131217111020.GF13823@ulmo.nvidia.com>
 <20131217115136.GT4360@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20131217115136.GT4360@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2013 at 11:51:36AM +0000, Russell King - ARM Linux wrote:
> On Tue, Dec 17, 2013 at 12:10:22PM +0100, Thierry Reding wrote:
> > On Fri, Dec 13, 2013 at 04:57:04PM +0800, Xiubo Li wrote:
> > > +static inline u32 fsl_pwm_readl(struct fsl_pwm_chip *fpc,
> > > +		const void __iomem *addr)
> > > +{
> > > +	u32 val;
> > > +
> > > +	val =3D __raw_readl(addr);
> > > +
> > > +	if (likely(fpc->big_endian))
> >=20
> > The likely() probably isn't very useful in this case. But if you want to
> > keep it, it should at least be reversed, since little-endian is actually
> > the default (you have to specify the big-endian property to activate the
> > big endian mode).
> >=20
> > > +		val =3D be32_to_cpu(val);
> > > +	else
> > > +		val =3D le32_to_cpu(val);
>=20
> This will also cause sparse errors, because when sparse is enabled, these
> expect __le32 or __be32 arguments, not u32.
>=20
> > > +	rmb();
> >=20
> > I'd prefer the rmb() to follow the __raw_readl() immediately to make the
> > relationship more explicit.
>=20
> A better question to ask is: why is this barrier here?  What memory
> ordering operations is it trying to serialise?

I suppose that this was done so that the accesses would essentially
remain the same as those performed by readl() and writel().

> > > +static inline void fsl_pwm_writel(struct fsl_pwm_chip *fpc,
> > > +		u32 val, void __iomem *addr)
> > > +{
> > > +	wmb();
> > > +	if (likely(fpc->big_endian))
> > > +		val =3D cpu_to_be32(val);
> > > +	else
> > > +		val =3D cpu_to_le32(val);
> > > +
> > > +	__raw_writel(val, addr);
> >=20
> > Same here. wmb() should precede __raw_writel() immediately.
>=20
> Same comments here - what memory operations is the wmb() trying to
> serialise?  Does this PWM driver somehow end up doing DMA?

Not that I can see. But if my understanding is correct, not using the
barriers would allow the compiler and CPU to reorder accesses, and by
that cause the register accesses to potentially happen in the wrong
order.

Thierry

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsEJ/AAoJEN0jrNd/PrOh6QEQAJb58rcRQgVI2UQHM6qCZSBy
bByBcbU1zixwi6nwpaTt8rUtw9RaqNEf847ri0nn0my2o99dG7TSJN77eEEN8gAL
A/4nftKABUEtKHnu2aWiqPn/8rpLbp9m/p6KCgbc/X+6grlk9jPYa3uIQS1nKzSh
+20bMgMHsgH/Isuy5wTQyC/uUzEcHakpQXB2y1KyzjAJ8KjwYBx+g8UWr4Tfv76t
sP5oQ0QOe65lQIMrTVygnq40gV3OBVIPG47UHUOu24TSP8pBZyTGcQaawLwaWaRU
XQdfLqPzqOhChA2fb+vKOdFugYeS9BCrPiIb1OtkS2pIuz4FxUx1QWR5t97YiL+K
PV29hLTmJSOTQPFa7k0zBOs7YfFO/uhSGhxJ0TNGji+F9P6IIpQ4O5qNz7WazZZO
Jg9evXMvntpF9/GhecUK5U+l6RqEui4L/fu51oGS9VtCLQciKDP7hKkljayeR3wO
rYTE43MnICdJNcDbh5XxPDVLutUzs+PGcYCcv/8tzeoNglwY5yyvf1I1F4tw3zVq
azqjBxnlikEgINFr66ifbkQ2693x+GrIIXUs1sLLLSspCMYzSuQrxVuP06YM5N9O
eZV3B1EmAJNrP/6Z9KCmxFxR6nvWohIYSld3PG+8c1dWlEaAKJuuX8LflZmyFV5c
qxlvXDnfWDg3wTt7E8V2
=nk4r
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
