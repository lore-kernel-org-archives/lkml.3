Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaKEJpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:45:24 -0500
Received: from down.free-electrons.com ([37.187.137.238]:40208 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751188AbaKEJpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:45:20 -0500
Date: Wed, 5 Nov 2014 10:41:46 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Chen-Yu Tsai <wens@csie.org>, Kishon Vijay Abraham I <kishon@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/6] clk: sunxi: Add support for sun9i a80 usb clocks and
 resets
Message-ID: <20141105094146.GB27686@lukather>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
 <1415074039-16590-2-git-send-email-wens@csie.org>
 <20141104181219.GJ4042@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <20141104181219.GJ4042@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Tue, Nov 04, 2014 at 06:12:19PM +0000, Russell King - ARM Linux wrote:
> On Tue, Nov 04, 2014 at 12:07:14PM +0800, Chen-Yu Tsai wrote:
> > +	spin_lock_irqsave(data->lock, flags);
> > +
> > +	reg =3D readl(data->reg);
> > +	writel(reg & ~BIT(id), data->reg);
> > +
> > +	spin_unlock_irqrestore(data->lock, flags);
>=20
> Don't we have generic support for atomic modification of register
> values?  Hmm, we have it for ARM only - atomic_io_modify() and
> atomic_io_modify_relaxed().
>=20
> I guess we should push for those to become cross-arch if we end up
> with generic drivers shared between other architectures.

IIRC, the atomic MMIO accessors are doing exactly that, but with a
global lock for all MMIO accesses, while here we protect a single
register.

I'm not really sure that sharing this spinlock across the whole system
is worth it and scales that well.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWfDaAAoJEBx+YmzsjxAgQNUP/2FABWqhwy2GbeG+uzD/AyYi
wjFgstJFnxaC9OdFFw47IDbFPFhDN7tZktb5zh5BKzRPao9EOSbXv1NBVSp2pqu1
5Q0nm12PXC6ADfb8rXXA7fUNHy+mWUq+Z0T9ppEKmbh67Q72BjKPhPsU2Wi97OlA
B5q7kpud5JgHkbuP/y27yxClA84OTvoDno9YGl0IbL2P3rXRRHXA52WgOjSQO7rP
rybqFpIYSbx9E6t0OqE8viYWPNyx8kuaUaBAR5PSQV5Aq27+tk/RtndgM7X7Wixp
i6kpIUEkmgiJpEQCz3MMmBYdEWff0EZxha5PphThgW3vAYsRYpXosgtL7dO0aFCR
9tAYIJelNqNSnPmTdPzV/ne4XrqN4en7ZigJKNqK5KJ6Oi+P7RVDNoNXS/p6T7x4
3+oT8D6IZBkLKefnjEO3htJRSs1DKk1JHTikslghjx+NMsMSPSYTQ+8Rk+q6MrP8
C5ON8yMEfExrChJac/7Li/OLZMbJRzJKs1csUNLyRDFqmgtvu5PcLs6jqIVRZOnN
9LDHb11OY+9hJGedLMOi+r0saha7+1LbCRue88+rXGZZZ3OVdjf/Gq1lmf1dF6fa
Nx3OBbHyEXWqmZYDTJ8dr0FQwnG4JnNEOL12tBT5vo8ZVoMJ+anKcFhDF/l7+Uld
ZtOVK+6MtoqKGyJWWSkl
=YVCF
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
