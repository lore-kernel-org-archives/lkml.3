Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab3D2XS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 19:18:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57740 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3D2XS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 19:18:58 -0400
Date: Tue, 30 Apr 2013 09:18:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the xen-arm
 tree
Message-Id: <20130430091845.27d8de4935bd33ddb4a3e8c0@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.02.1304291049060.5398@kaball.uk.xensource.com>
References: <20130429175426.9423279609437a2d746cbb7b@canb.auug.org.au>
	<20130429082511.GA539@arm.com>
	<alpine.DEB.2.02.1304291049060.5398@kaball.uk.xensource.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__30_Apr_2013_09_18_45_+1000_MpV.1NXfvb6Qhh+W"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Apr_2013_09_18_45_+1000_MpV.1NXfvb6Qhh+W
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefano,

On Mon, 29 Apr 2013 10:50:22 +0100 Stefano Stabellini <stefano.stabellini@e=
u.citrix.com> wrote:
>
> On Mon, 29 Apr 2013, Catalin Marinas wrote:
> >=20
> > On Mon, Apr 29, 2013 at 08:54:26AM +0100, Stephen Rothwell wrote:
> > > Today's linux-next merge of the arm-soc tree got a conflict in
> > > arch/arm/mach-virt/platsmp.c between commit fe4bff02886b ("arm: intro=
duce
> > > psci_smp_ops") from the xen-arm tree and commit c0114709ed85 ("irqchi=
p:
> > > gic: Perform the gic_secondary_init() call via CPU notifier") from the
> > > arm-soc tree.
> > >=20
> > > The former renamed the file (and contents) so I applied the following
> > > patch and can carry the fix as necessary (no action is required).
> > >=20
> > > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > > Date: Mon, 29 Apr 2013 17:52:27 +1000
> > > Subject: [PATCH] arm: fix for Perform the gic_secondary_init() call v=
ia CPU
> > >  notifier
> > >=20
> > > due to code movement.
> > >=20
> > > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > > ---
> > >  arch/arm/kernel/psci_smp.c | 7 -------
> > >  1 file changed, 7 deletions(-)
> > >=20
> > > diff --git a/arch/arm/kernel/psci_smp.c b/arch/arm/kernel/psci_smp.c
> > > index 6ef139d..cd9acc7 100644
> > > --- a/arch/arm/kernel/psci_smp.c
> > > +++ b/arch/arm/kernel/psci_smp.c
> > > @@ -14,7 +14,6 @@
> > >   */
> > > =20
> > >  #include <linux/init.h>
> > > -#include <linux/irqchip/arm-gic.h>
> > >  #include <linux/smp.h>
> > >  #include <linux/of.h>
> > > =20
> > > @@ -55,11 +54,6 @@ static int __cpuinit psci_boot_secondary(unsigned =
int cpu,
> > >  	return -ENODEV;
> > >  }
> > > =20
> > > -static void __cpuinit psci_secondary_init(unsigned int cpu)
> > > -{
> > > -	gic_secondary_init(0);
> > > -}
> > > -
> > >  #ifdef CONFIG_HOTPLUG_CPU
> > >  void __ref psci_cpu_die(unsigned int cpu)
> > >  {
> > > @@ -84,7 +78,6 @@ bool __init psci_smp_available(void)
> > >  }
> > > =20
> > >  struct smp_operations __initdata psci_smp_ops =3D {
> > > -	.smp_secondary_init	=3D psci_secondary_init,
> > >  	.smp_boot_secondary	=3D psci_boot_secondary,
> > >  	.cpu_die		=3D psci_cpu_die,
> > >  };
> >=20
> > The fix looks fine. Thanks.
>=20
> Indeed, thanks! I'll add to it to the tree.

You should not apply that to your tree as you don't have the rest of the
change from the arm-soc tree.  It needs to be applied to the merge of the
two trees i.e. when Linus merges the last of the two trees.

This is why I wrote "no action is required".

And you committed it to your tree without your Signed-off-by ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__30_Apr_2013_09_18_45_+1000_MpV.1NXfvb6Qhh+W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRfv/VAAoJEECxmPOUX5FE7nMP/2XYZml1f96FdGpVj6d0zJqF
Pv0GaoXA6w/xJT7ejSXXc4b/IiwiqG5A2reFVYDYm8E34rAPuZIQGulGt97m8Z0A
Jf2ORr6+kaZ0TgPDs7Xf1lWGh/w+S8I2sINEnXNOdceN5xDldqka/C0MieopQ+ix
1c/QdFqFUu0eNJg/iOw/ddD4ta0HvZ6CINdcgouLz0oZDaJuc3aWsZi7gIlk1tra
9Gb62K5dmzuVIqx+qsyeFhVLlARzRcynmiGuSbr/6V7sQcT0Pazb0RE5ZMnkgXGM
v+kCa1lq0NzSDPxS51PXFbQEHDPL5nDfBv9xfJdJvZ3lYV6eqRwjhhCP4WHVTixj
JLtN6h7aE6P/J/74Klv/X8IgSizAgfRkkxQrC+acdQG164ybIVc8H/YD/h8S7N6f
0TOSJJUtdzT/wVVaAMPa8kHoEFOE8zztxhOmESgmj0dhwVa3838kXehSbblInDqJ
oB1BDIG9EbBSqyWWzCDyR69eBFMS1CKrpiAlT30ez+eqPAfFqfP0dRx6NDjDmW7T
O7eiDOmfW1ehGB5HtIXCLkkEDdOKV49dpm2IKI5PXopPOaf0rXIa1QI64nSWuOkx
yFhsgW8fdY34Ktcz4/9yoSCbPzTftiXHHxxtv9nJt2iun56Wy+m93XmTtLLlPulz
j3IyN+xecK1duo/mI4Xu
=6T87
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Apr_2013_09_18_45_+1000_MpV.1NXfvb6Qhh+W--
