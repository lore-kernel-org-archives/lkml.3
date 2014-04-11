Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaDKSgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:36:31 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:48686 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbaDKSg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:36:29 -0400
Date: Fri, 11 Apr 2014 20:36:26 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Rob Herring <robherring2@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20140411183625.GB3673@mithrandir>
References: <20140410213808.GA5990@atomide.com>
 <20140411092028.GI16119@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
In-Reply-To: <20140411092028.GI16119@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 11, 2014 at 10:20:28AM +0100, Russell King - ARM Linux wrote:
> On Thu, Apr 10, 2014 at 02:38:09PM -0700, Tony Lindgren wrote:
> > Currently we get the following kind of errors if we try to use interrupt
> > phandles to irqchips that have not yet initialized:
> >=20
> > irq: no irq domain found for /ocp/pinmux@48002030 !
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 1 at drivers/of/platform.c:171 of_device_alloc+0x1=
44/0x184()
> > Modules linked in:
> > CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-00038-g42a9708 #1012
> > (show_stack+0x14/0x1c)
> > (dump_stack+0x6c/0xa0)
> > (warn_slowpath_common+0x64/0x84)
> > (warn_slowpath_null+0x1c/0x24)
> > (of_device_alloc+0x144/0x184)
> > (of_platform_device_create_pdata+0x44/0x9c)
> > (of_platform_bus_create+0xd0/0x170)
> > (of_platform_bus_create+0x12c/0x170)
> > (of_platform_populate+0x60/0x98)
> >=20
> > This is because we're wrongly trying to populate resources that are not=
 yet
> > available. It's perfectly valid to create irqchips dynamically, so let's
> > fix up the issue by populating the interrupt resources at the driver pr=
obe
> > time instead.
> >=20
> > Note that at least currently we cannot dynamically allocate the resourc=
es as bus
> > specific code may add legacy resources with platform_device_add_resourc=
es()
> > before the driver probe. At least omap_device_alloc() currently relies =
on
> > num_resources to determine if legacy resources should be added. Some of=
 these
> > will clear automatically when mach-omap2 boots with DT only, but there =
are
> > probably other places too where platform_device_add_resources() modifies
> > things before driver probe.
> >=20
> > This patch was discussed quite a bit earlier, but so far it seems we do=
n't
> > have any better options to fix the problem. For the earlier discussion,
> > please see:
> >=20
> > https://lkml.org/lkml/2013/11/22/520
> >=20
> > The addition of of_platform_probe() is based on patches posted earlier =
by
> > Thierry Reding <thierry.reding@gmail.com>.
> >=20
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
>=20
> So what happens if a device driver probe function:
>=20
> - creates a new platform device
> - copies the resources from the original to the new device
> - copies the of_node from the original to the new device
> - registers the new device
>=20
> Yes, it's broken (because it can result in the same driver being re-probed
> by the new device) but we *do* have stuff in the kernel tree which does
> this.

=46rom what I can tell the only clean solution would be to allow the OF
functions to properly propagate errors. My earlier attempt was exactly
that, but was deemed too invasive.

But that doesn't really solve the case you describe above either. So I
think the only good generic solution would be for all resources to be
resolved by the driver's .probe() function so that resources aren't
"cached" in the device node.

Thierry

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTSDYpAAoJEN0jrNd/PrOhpikP/RgSAM8vkG0NKabtmrGQiIWp
UmV/Ca8vDWyCd214RCKSbRQs2YRtMqd0EfX5HfOgzSbumTqwhgBrlFXlpdRRji5w
5sc/aDIHNw709P8MRD+P0jcfMtIWiWNGvNO4WkM19EYt0OFEVcrLmqb5O8KbePFR
VbHY69/inUNdNXhUvjFFW5IEeJmr4Iomown3gMrkIT6CGXm2Ide9juJ24rFecw8i
eN+IhkhMlc8ZrhyPJdWE4wOTUsg+kKXolvTwufbtr2NFST9yfw1hdIMxAXzonr3x
QFpd0Ip92uGd8pU2xtMfr0BUYFOck5k7EJ5d47Am+0k6aGXzhjeouRO+7Z7re/SP
oxXmZT9kFC6Dx5xjFtDCnHxqLKUl/tNPlQhH+b61RsUCCFcUJa1rue2o2u7Q0IvH
DmX+YjJ+QP5bWlFtL66EG7sYKNhPdQWitWJ7KkbIVpqEV89W0qeJUeaglmg0mO37
UEAffFp1qS0KP2w8fDamNbcfAhQcwQ0QeO9WUqRhz/Gn0LKHsVLnP7xPpkyfUJ1v
daTiLgEHXlA2jrZj2J4slMsZkQDEh09hObUQuiCg8EC1o6daJGzoE9o7rkK0LKvV
fWLbUGGbDqJv3pjTRtSSf6bUzoFxssRdGw+dFh54qfCuUwUr6+kSN/8b2dE8n+bH
e3ALCgc629+TsmZC/wgx
=a6q+
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
