Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109Ab3KJKFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 05:05:15 -0500
Received: from top.free-electrons.com ([176.31.233.9]:60194 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750939Ab3KJKFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 05:05:08 -0500
Date: Sun, 10 Nov 2013 11:03:12 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-kernel@vger.kernel.org
Subject: Re: [linux-sunxi] [PATCH 2/2] ARM: sun6i: Add SMP support for the
 Allwinner A31
Message-ID: <20131110100312.GI26440@lukather>
References: <1383471013-21695-1-git-send-email-maxime.ripard@free-electrons.com>
 <1383471013-21695-3-git-send-email-maxime.ripard@free-electrons.com>
 <1383583997.8826.123.camel@kazak.uk.xensource.com>
 <20131108084056.GB26440@lukather>
 <1383906355.3189.77.camel@kazak.uk.xensource.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hm39DdI+xc+0zcX9"
Content-Disposition: inline
In-Reply-To: <1383906355.3189.77.camel@kazak.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hm39DdI+xc+0zcX9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ian,

On Fri, Nov 08, 2013 at 10:25:55AM +0000, Ian Campbell wrote:
> On Fri, 2013-11-08 at 09:40 +0100, Maxime Ripard wrote:
> > > I'm trying to work out if we can make this work with the requirement
> > > which both Xen and KVM have to enter the kernel in NS-HYP mode.
> > >=20
> > > The way this works on e.g. vexpress is (roughly) that u-boot wakes up
> > > the secondary CPUs from the lowlevel firmware and places them into its
> > > own holding pen, which has the same wake up protocol as the firmware =
so
> > > the kernel can just use the same code. If u-boot never gets to run on
> > > secondary CPUs that isn't going to help much.=20
> > >=20
> > > My concern is that the sequence here appears to involve resetting the
> > > secondary CPU, which I figure will probably defeat that strategy by
> > > kicking the CPU back into the lowlevel firmware in the reset state,
> > > meaning it can't be done by a u-boot only change.
> >=20
> > I think this is where we're headed for the A20, Marc was interested in
> > doing that,
>=20
> Marc Zyngier is that?

Ah yes. I forgot to put it in CC...

> >  since we already have pretty much this in u-boot already,
> > however, this is not the case for the A31.
>=20
> > As far as I know, the Allwinner's bootloader that we currently use
> > isn't bringing up the secondary CPUs, and we don't have any port of
> > some sort of u-boot yet that we could work on.
>=20
> Ah, OK. I'd assumed that A20 and A31 (indeed, most sunxi platforms) were
> mostly equivalent as far as u-boot support went.

No. The A31 has no current support at all in u-boot(-sunxi, that is),
so the only bootloader we can use is Allwinner's one.

It's one my TODO list somewhere, but as usual, time is lacking :)

> > So, I guess we don't really have much choice in that case, even though
> > eventually I'd like to have this for the A31 too.
>=20
> Right, I suppose it makes sense to consider what we want to do on the
> A20 now and keep in mind that A31 may want to follow in the future.
>=20
> > > Hrm, what to do ... perhaps a DT driven selection between this mechan=
ism
> > > and sev to kick a wfe loop reading the private register?
> >=20
> > We can discuss this whenever we will actually have that choice to
> > make, but maybe a kernel parameter would be better?
>=20
> I don't think so -- u-boot would then have to munge the command line to
> say that it had/had not brought up secondaries. DTB seems more natural
> to me. e.g. on ARMv8 there is already a requirement to provide a per-CPU
> property describing the bringup protocol ("PSCI" and "spintable" are the
> options there).

Then I guess we can assume that we have to do all the CPU bring up
work if this property is missing?

> Anyway, once I get to the point of being able to do something I'll
> coordinate with Marc etc and figure out what to do. In the meantime I
> think having the kernel do the bringup (like this patch does) is
> sensible. It's very likely to be what we want to do in the absence of
> any instruction to the contrary (DTB or otherwise) in the future anyway.

Yep.

A part from the discussion on the approach, do you have any comments
on the patches themselves?

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--hm39DdI+xc+0zcX9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSf1nfAAoJEBx+YmzsjxAgEvQP/j6y0mrt0pqvpETg81EybaZM
mfHZKDdbMhfBlMGO2YSNWswmGHp/20wXgBjMElDQd08ZjOHh0O53PBNJlULK409r
C5+uCK+lmk3zOvrCGI5mmSfC6n+RQIXnIOuRDgqLHyh4rBznWQLYHk7/I3cL89j1
rkVv96s7sQ9XX1Zzuz87NZUihWwtFcA2BpFSL0jPJ7XUAwjfNjxuOCfoYkcbCzKV
e18R/Gt37nlRIeUxqH+A6bZGia3OcHNxb/nTF1rpfWRQpRd20ZTWbZnI4s9zSXrM
X6gj7TL2fGOSndo+had5MmY1QMiZiHZM1EuWEcnjEwRtldfnaA5Ajc/F54s4Rq1e
IXN4HXT6HBSba4YXyRWbgQJnn14EXfIgm0ATL6sCT9eUXA+ErE0pOYrUyhAJFLiT
XpqHpN1dbtA7RzNTYVUfUBKt/cV9jFsNO2slkuQXG6OVh53WqkPalS9KCXRposYb
YoC8i4qLCmhRiNX/Jhv0NswsDGywxDGYPt5ZY7wLun/TVTxX+KQXGAQd/Dvc4rvA
/9Lwss8JS9AhdboqM/1WguZvRNRFk5J7fQy7QREL9kAo/ulaWYcOEUsPY5R8yPTv
gNOOMBII6tERjmFJ4bRkVW5VQFm1gJbaDhtvTls0URhYXHeHhjwAWAZOpb1tXgUu
1t3930Pwy3PN6HbuWNx0
=84cF
-----END PGP SIGNATURE-----

--hm39DdI+xc+0zcX9--
