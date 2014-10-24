Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaJXTWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:22:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42294 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbaJXTV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:21:59 -0400
Date: Fri, 24 Oct 2014 14:21:11 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Johan Hovold <johan@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: remove redundant irq disable at halt and restart
Message-ID: <20141024192111.GC11455@saruman>
Reply-To: <balbi@ti.com>
References: <1414177592-14547-1-git-send-email-johan@kernel.org>
 <20141024191627.GA11455@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
Content-Disposition: inline
In-Reply-To: <20141024191627.GA11455@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 02:16:27PM -0500, Felipe Balbi wrote:
> On Fri, Oct 24, 2014 at 09:06:32PM +0200, Johan Hovold wrote:
> > Remove redundant local_irq_disable() at machine halt and restart.
> >=20
> > Since commit 44424c34049f ("ARM: 7803/1: Fix deadlock scenario with
> > smp_send_stop()") interrupts are disabled before stopping secondary
> > CPUs.
>=20
> Assuming this is correct, you should have:
>=20
> Fixes: 44424c3 (ARM: 7803/1: Fix deadlock scenario with smp_send_stop())
> Cc: <stable@vger.kernel.org> # v3.12+
>=20
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> >  arch/arm/kernel/process.c | 2 --
> >  1 file changed, 2 deletions(-)
> >=20
> > diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> > index a35f6ebbd2c2..5663ab57cf07 100644
> > --- a/arch/arm/kernel/process.c
> > +++ b/arch/arm/kernel/process.c
> > @@ -195,7 +195,6 @@ void machine_halt(void)
> >  	local_irq_disable();
> >  	smp_send_stop();
> > =20
> > -	local_irq_disable();
> >  	while (1);
> >  }
> > =20
> > @@ -237,7 +236,6 @@ void machine_restart(char *cmd)
> > =20
> >  	/* Whoops - the platform was unable to reboot. Tell the user! */
> >  	printk("Reboot failed -- System halted\n");
> > -	local_irq_disable();
>=20
> ... but wouldn't this reintroduce the the buck which that commit fixed ?

s/buck/bug :-) my fingers have a mind of their own, aparently.

--=20
balbi

--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSqanAAoJEIaOsuA1yqREsQMP/2MxzFoXmSLaIAYF0HOZMuka
wu2PqxmW2YpaOOZtmE9v7Bkj4zsMj+9daYK5wGbH6h696Q1AO3Hi7qzm8PYYucvP
pKv1oVOuZ0hZ7HQ1i3jmFIOkLyA9N+ix4iGeWh9gmP608oUfiwvZoNhsbg4mrRTS
G2f04XqFBxPD+4vydrpnsnZEgHR9KdGwKwlh0cHxKAqf90njbEM5lpgbMwx0oyM3
5LvXJKGn/MKHrc/TOG7SKKSCkurzxAQP/oEPhnwEaWJkApq5ImKosEnd7FMWn7XU
0LncDoz/qyzv6QosUJbkvDXhdw07ftV36mmJKhJgU+nxSuF32vBiqn2tGD/107DP
CkTDN8ofq8B3Rq6HMJlUsNQ0e4mS5k7Up99X9lIQL+kvFnBFg5BV51fG8aMMBOmL
DggcxdpOq5PJUy47NS+jqjQf/XzZNyAYIoBZtdV6hmjkv4OzsOaGZqvSjqm+uh14
bcNu3e/HaSveoTqa5c2TdzeVOWGeL40ruOP6Sh5vmz+AbRNHdyetvw3obCgYJLvU
fNfa0TGb5qFMDr09uQwtIK+xdxVZl+CZXdqg8KHXrp4SZwN3Gy1Tgsve0RdaZyT5
0yk0yrz4Ut6W9FCrhgEFZ6DoB4ItsnOpxlT6aivlWqYrFjIsc2ZB2kGAYSw5bvIh
suQIK7rI/I7StZ6Dwlbc
=NS3E
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
