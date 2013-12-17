Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3LQMqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:46:37 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:45955 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3LQMqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:46:33 -0500
Date: Tue, 17 Dec 2013 13:45:06 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Xiubo Li <Li.Xiubo@freescale.com>, mark.rutland@arm.com,
        s.hauer@pengutronix.de, galak@codeaurora.org, swarren@wwwdotorg.org,
        t.figa@samsung.com, grant.likely@linaro.org, matt.porter@linaro.org,
        rob@landley.net, ian.campbell@citrix.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Alison Wang <b18965@freescale.com>,
        Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv7 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20131217124505.GB17210@ulmo.nvidia.com>
References: <1386925027-16288-1-git-send-email-Li.Xiubo@freescale.com>
 <20131217111020.GF13823@ulmo.nvidia.com>
 <20131217115136.GT4360@n2100.arm.linux.org.uk>
 <5295539.cCkPY1PpyC@flatron>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <5295539.cCkPY1PpyC@flatron>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2013 at 01:00:10PM +0100, Tomasz Figa wrote:
> On Tuesday 17 of December 2013 11:51:36 Russell King - ARM Linux wrote:
> > On Tue, Dec 17, 2013 at 12:10:22PM +0100, Thierry Reding wrote:
> > > On Fri, Dec 13, 2013 at 04:57:04PM +0800, Xiubo Li wrote:
> > > > +static inline u32 fsl_pwm_readl(struct fsl_pwm_chip *fpc,
> > > > +		const void __iomem *addr)
> > > > +{
> > > > +	u32 val;
> > > > +
> > > > +	val =3D __raw_readl(addr);
> > > > +
> > > > +	if (likely(fpc->big_endian))
> > >=20
> > > The likely() probably isn't very useful in this case. But if you want=
 to
> > > keep it, it should at least be reversed, since little-endian is actua=
lly
> > > the default (you have to specify the big-endian property to activate =
the
> > > big endian mode).
> > >=20
> > > > +		val =3D be32_to_cpu(val);
> > > > +	else
> > > > +		val =3D le32_to_cpu(val);
> >=20
> > This will also cause sparse errors, because when sparse is enabled, the=
se
> > expect __le32 or __be32 arguments, not u32.
>=20
> My question is why can't you just create two sets of accessors, one big
> endian and one little endian, add two function pointers to your
> fsl_pwm_chip struct and let the driver set the to correct accessors in
> probe?

I guess that would be one possibility.

> This would eliminate the problem with types Russell mentioned and IMHO
> make the code cleaner.

I fail to see how that would eliminate the problem with the types. That
said I don't actually see sparse complaining about any type mismatches.
That's probably because the various macros implicitly cast to u32.

> > > > +	rmb();
> > >=20
> > > I'd prefer the rmb() to follow the __raw_readl() immediately to make =
the
> > > relationship more explicit.
> >=20
> > A better question to ask is: why is this barrier here?  What memory
> > ordering operations is it trying to serialise?
>=20
> I'd also add a question why __raw accessors are used here.

Because both readl() and writel() explicitly perform little endian
accesses.

Thierry

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsEdRAAoJEN0jrNd/PrOh0xoP/j0OLAvMHLjIxHq3NXCojZIq
lLrJ2v2mBb8BCLxoLMIIaMcczUcizuohtkIO2b9M2cQ6/rdcI1cqQPkKiTdwtWop
6jCCmJFQ8eEK/Vns3WNhfRQhZcuRvPc8zp6gv44L/Ffd3x/NX1DiUZ+P00vkUFWR
WK8B/lmufzPC3NLXw8K9heOoUdNz0FGD+g1O3k952LPeQYpvAKGE+zieP7tkRxNm
quFiDWJzInI0ci9X9c+rtSo64RGogY6+EMs6yNAD40zZiQ7z8ZxsXo7yIDD7EtZQ
JSF1B4X/8Ubo/F1m/BlaxPrc1AD1sIdH2GmNp1+vlpCK7RFkIcHIqpMmFBLN2Xme
ivkopOHrt8BGeBngFQTZx5+wYE3pUJLmVLxWFl4ZhfVBzflFihhmMQCHIbcwrd/h
9LE5pjZjb2El0a1uLJZGRHf9TTwONU/lUbGJONVqDPPjqItaqDOE6xz/zRDLsy4B
OZ/prE6MusMqm3I3VtV6iVPzKKldSc8i3BvsBzVBB3r6f1lZfkdRr5hjBgPqJKss
8hvp1Ck34dNIKF7ri7QoAK9tTCyt+tmehkz35Wo3yNf0U23fHgDGSjRpIRKJIxl1
anFq+zbCyp7zRkFg222sAUcxjo8B8yM04jxrKHQi+Su4Ba6ErxllFh/cu2ThcJAq
E9lg/nFoMKUSNOYEKZC4
=nALP
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
