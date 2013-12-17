Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3LQNVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:21:23 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:48298 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3LQNVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:21:20 -0500
Date: Tue, 17 Dec 2013 14:19:53 +0100
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
Message-ID: <20131217131951.GA2329@ulmo.nvidia.com>
References: <1386925027-16288-1-git-send-email-Li.Xiubo@freescale.com>
 <1386925027-16288-2-git-send-email-Li.Xiubo@freescale.com>
 <20131217111020.GF13823@ulmo.nvidia.com>
 <20131217115136.GT4360@n2100.arm.linux.org.uk>
 <20131217122431.GA17210@ulmo.nvidia.com>
 <20131217125832.GU4360@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <20131217125832.GU4360@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2013 at 12:58:32PM +0000, Russell King - ARM Linux wrote:
> On Tue, Dec 17, 2013 at 01:24:33PM +0100, Thierry Reding wrote:
> > On Tue, Dec 17, 2013 at 11:51:36AM +0000, Russell King - ARM Linux wrot=
e:
> > > Same comments here - what memory operations is the wmb() trying to
> > > serialise?  Does this PWM driver somehow end up doing DMA?
> >=20
> > Not that I can see. But if my understanding is correct, not using the
> > barriers would allow the compiler and CPU to reorder accesses, and by
> > that cause the register accesses to potentially happen in the wrong
> > order.
>=20
> The compiler won't reorder them, but the CPU may if it meets certain
> criteria.  The architecture guarantees that accesses to device memory
> within a (minimum of) 1KB block will be ordered.
>=20
> The ARM ARM is slightly ambiguous in how this is applied - in one
> place it says that "Accesses must arrive at any particular memory-mapped
> peripheral or block of memory in program order" and another part it
> says "The size of a memory mapped peripheral, or a block of memory,
> is IMPLEMENTATION DEFINED, but is not smaller than 1KByte.  Note
> This implies that the maximum memory-mapped peripheral size for which
> the architecture guarantees order for all implementations is 1KB."  See
> page A3-148.

None of the ARM ARM versions that I have seem to have page A3-148. Which
version should I be looking at? Not that I'm in any way doubting what
you're saying, I'd just like to make sure to have the correct reference
to look at in the future.

> What this means (to me at least) is that on any SoC, the architecture
> guarantees that accesses _within_ a 1KB device memory block will always
> be ordered, but two accesses outside of a 1KB block _to the same device_
> is implementation defined whether it is ordered or not.

This means at least every ARM SoC would behave that way. Since this
driver doesn't have an explicit dependency on ARM I assume it could
eventually be used on a different architecture. Even more so since
there's Freescale in the name.

> The interesting point here though is that the "note" contradicts the
> first definition if you have (eg) AMBA Primecell peripherals which are
> generally 4KB in size, since if the architecture only guarantees 1KB,
> then accesses _may_ _not_ arrive at one primecell in program order.
> Hence, the note is a direct contradiction of the first definition.

Interesting indeed. Perhaps implementation defined in this case means
that an implementation would have to adjust the size of a memory mapped
peripheral or block of memory accordingly, depending on the largest
block within the SoC.

I suppose, though, that if the architecture doesn't give any guarantees
about it, we can't safely assume that the implementation will.

Thierry

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsE93AAoJEN0jrNd/PrOhCfQP/3cH75pm5Zwulhq3sHErpMrN
L3b/L2gbKa3SFJ/eHIcYKcykMI0Yj4HdsSsgTYPpZtNFiWUGz+9/lq4x8GQxCv3g
p7P58wswfifP+zngLIGo00wAtw8ut8ND4xMLfDAu5uBK7We0GAZJ6xEiWjjHiT+Z
SOKKxal/ZX11rHESNVmA1K3oQgsbDtjXC8p37AF/epxlEqxS6ynEv4cclnlitiw2
cwQlJeBCZVLZZX2ybt6FMvUkHerLIY3RdWfCfEH+1Bm4gz3i0rg2Il3ZaOl49FeM
PF7kcuuhQaNVSJHc2NXHj0AZ1d5UYA6P9aQ17pG1X8Llg9LZ85XzycV+yKBqQDg9
f49uqRPHs+EM8rnPoHzkmKZltWVanhzMS4v2Sjd2f0wk5XkzMGBppZ23baBQMtY+
NsG+N9yjVNYSVxjOO9XEO1bqOwGuzwi+Ym7DTlybJem9eq55sWnf8hy9wkJaqgnF
BnsNPvBdr1NmOhaIkunhrR3VdzzkJ2FMaLrNa0iMH+7gyiaCsVwXS5aIUTXPdnEp
Y1krm29vHTCs8QOo95wa7v46Osh6NZfmu7ZdZHWxMSltTUcCeegd4qGvbUCS8jle
Wj/FuHUBZK9RIMWcoehi9+ERvEp0ETfJ5W10Y95ncqslxEnt6oITlrdd8GpzHt/r
xb5qLiXZq08A96yyZMNz
=Kz+j
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
