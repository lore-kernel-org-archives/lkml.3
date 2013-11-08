Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3KHIpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:45:13 -0500
Received: from top.free-electrons.com ([176.31.233.9]:55927 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221Ab3KHIpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:45:10 -0500
Date: Fri, 8 Nov 2013 09:40:56 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-kernel@vger.kernel.org
Subject: Re: [linux-sunxi] [PATCH 2/2] ARM: sun6i: Add SMP support for the
 Allwinner A31
Message-ID: <20131108084056.GB26440@lukather>
References: <1383471013-21695-1-git-send-email-maxime.ripard@free-electrons.com>
 <1383471013-21695-3-git-send-email-maxime.ripard@free-electrons.com>
 <1383583997.8826.123.camel@kazak.uk.xensource.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VZLKKa0PG5KXlQhV"
Content-Disposition: inline
In-Reply-To: <1383583997.8826.123.camel@kazak.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VZLKKa0PG5KXlQhV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ian,

On Mon, Nov 04, 2013 at 04:53:17PM +0000, Ian Campbell wrote:
> Not a comment on the patch, or even A31, but a question about how the
> SMP boot process works on sunxi generally...
>=20
> On Sun, 2013-11-03 at 10:30 +0100, Maxime Ripard wrote:
> > The A31 is a quad Cortex-A7. Add the logic to use the IPs used to
> > control the CPU configuration and the CPU power so that we can bring up
> > secondary CPUs at boot.
> > [...]
> > +	/* Set CPU boot address */
> > +	writel(virt_to_phys(sun6i_secondary_startup),
> > +	       cpucfg_membase + CPUCFG_PRIVATE0_REG);
>=20
> Does the secondary CPU jump straight here from the lowlevel firmware or
> does it go through the bootloader which reads the reg and does the jump?
> I can't see any reference to this reg in u-boot so I guess the former?

There's no reference of this either in the A31 datasheet (or at least,
none I could find), so I assume the former too.

> I'm trying to work out if we can make this work with the requirement
> which both Xen and KVM have to enter the kernel in NS-HYP mode.
>=20
> The way this works on e.g. vexpress is (roughly) that u-boot wakes up
> the secondary CPUs from the lowlevel firmware and places them into its
> own holding pen, which has the same wake up protocol as the firmware so
> the kernel can just use the same code. If u-boot never gets to run on
> secondary CPUs that isn't going to help much.=20
>=20
> My concern is that the sequence here appears to involve resetting the
> secondary CPU, which I figure will probably defeat that strategy by
> kicking the CPU back into the lowlevel firmware in the reset state,
> meaning it can't be done by a u-boot only change.

I think this is where we're headed for the A20, Marc was interested in
doing that, since we already have pretty much this in u-boot already,
however, this is not the case for the A31.

As far as I know, the Allwinner's bootloader that we currently use
isn't bringing up the secondary CPUs, and we don't have any port of
some sort of u-boot yet that we could work on.

So, I guess we don't really have much choice in that case, even though
eventually I'd like to have this for the A31 too.

> Hrm, what to do ... perhaps a DT driven selection between this mechanism
> and sev to kick a wfe loop reading the private register?

We can discuss this whenever we will actually have that choice to
make, but maybe a kernel parameter would be better?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--VZLKKa0PG5KXlQhV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSfKOYAAoJEBx+YmzsjxAgO6IQALSMyGyD3E/dFPDmGgypE2IY
kCvS5ZSB6hJmBAs+3oJWqdTZmKT/aQrWEQN55QGnyHqTCDoN2paSIVF797n+yTBj
2AcENi6nn6Qcz8nE6DxJze0KgWFlpNds9LQdXOP8kSE2U5e21zbHfYq1OBniIIPm
5nQ6HyyNRPHjV5WxVVlD7KUzn9gEHSP5lW8556rVbZ/oD4Ss73dnHa0KJNeKKPAF
8u4Ys5Iutit1AzhT+Q1AEXypzhdO5FLlj0uegiljt4XVRNhFLAxtwgWhRy7NR0t7
XIZ7qri9dZ764HDhUaCY7/nReq4PW69OwF9Lc6rMcuq9eunbW6fMVM5fB2vLQlT8
MNrK0Sd1h4EicvEgn+6JgJTZEsk8ER5VcKL1i1oewZofo44cE0RbKH4poPa4R2W0
9EPDlLpqBuk4XrqZRuDiNvtJEYkaEf6AwkYaBZLSM4bQp6leBa/sn+T0ddh0m8DL
sdW42Q2DQsXCtRs1fn1MIHpi4Gd4K4NMeKCfOI3dpOIv5IERfrWdur5ACx5MXi4a
rVWhv8edFJI1GoANRtO4t7CfB+yJFFDJK3SXFjBpPg27ARbtEmWy5/4rhnNmjhSg
4EIcNMkvC3Zf7cbp8uyu5PbA6Tj6YOsGLhfolhi128GGeKl2m+QwSMj0E8+XI58a
R1ot04QVtPWfm2CgkFGR
=pifl
-----END PGP SIGNATURE-----

--VZLKKa0PG5KXlQhV--
