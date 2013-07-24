Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab3GXJwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 05:52:09 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54136 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab3GXJwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 05:52:05 -0400
Date: Wed, 24 Jul 2013 11:51:45 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Axel Lin <axel.lin@ingics.com>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT] irqchip: sun4i: Remove wrong irq_ack callback
 implementation
Message-ID: <20130724095145.GK10389@lukather>
References: <1373121329.13289.2.camel@phoenix>
 <20130711161353.GV11243@lukather>
 <CAMuHMdWP6NtXxmesakPKmxAk1MS2eByEHALAnQQHf8MJcCfk0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EMQjp+MvU6EBGjHc"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWP6NtXxmesakPKmxAk1MS2eByEHALAnQQHf8MJcCfk0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EMQjp+MvU6EBGjHc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Fri, Jul 19, 2013 at 11:29:30AM +0200, Geert Uytterhoeven wrote:
> On Thu, Jul 11, 2013 at 6:13 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Sat, Jul 06, 2013 at 10:35:29PM +0800, Axel Lin wrote:
> >> According to the datasheet[1], the Interrupt IRQ Pending Registers are
> >> read-only. The implementation of sun4i_irq_ack() looks wrong because i=
t writes
> >> to these read-only registers.
> >
> > Right, but the datasheet also says that these registers are "clear"
> > register, which might indicate that it's actually R/W.
>=20
> I guess it means that the flags are cleared automatically on read?
> That's not so uncommon for interrupt pending registers.

My understanding in this case is that the pending register is just a
"copy" of the pending bits in the related hardware IP, so that clearing
it in the interrupt controller won't do much, since it will be re-set
just after the clear, while if you do clear the interrupt bit in the IP,
it will clear it automatically in the interrupt controller.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--EMQjp+MvU6EBGjHc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR76OxAAoJEBx+YmzsjxAgLwYP/jsfhqGxgyH0a6ii5U7Li6Fp
f4qbD8XWYc3S9P4ecns7MIWR69LhcbpMPc6rdqHi3ukhXu/FPUrEQP5BQmwqiB0H
HYnRjZwawGgDwT55ztRYSZAZrKY3DvOYtmvTreyZgg0TJNmy26cEFPnOyGn7IvgA
xyF4iM8GUvlrONswU6B/5tCQPLB2iN3DI6pFJ02MKQp+SaD0/aQjxiCTaOu8aSaP
Yg0+erc8Cb7phKBjvcYQgB0RVkdnPbUxNLm8MhSdRhK63TR/vyDplwIsJv80f3hY
qsnk1rv+7AH0vvTaZrycDiIJ1wbgLQKuvm8EBQ/Js/l8E/bKXDnzuZpgZk7XMhip
zmlReoAl5oqsi9EsKofelD//BQ+g0R0EwfXCN4Dhkp2NvKxtR19djNnWfljbYl21
YhO4v2jEQnkBoVE3+/l3aWa1c8zmN+2w35Ibs5FnLqKseipmiJPWiNhTeVpPaFOa
xcmkk/BHYwM5jt9x3djmhVUpH3o+ruGIQRH6UKRiSctMuR+0v83gsNN7RrnuEGQk
7jkHIu5qfEFvmxv8Zr0afZ1RWSDnflaFlhKd5TbtvnqsuSj4IzihAKDIH9KHOV55
r/mSOSxOFEpKx5yMzI+iTgj27dDTGmLBWewbyX43O9nPlfJtlD92PtCZWJqNPVYT
bpxy6rTK/lt9gQw71hlU
=+gt5
-----END PGP SIGNATURE-----

--EMQjp+MvU6EBGjHc--
