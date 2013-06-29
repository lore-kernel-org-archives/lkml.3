Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3F2OWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 10:22:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46804 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab3F2OWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 10:22:49 -0400
Message-ID: <1372515760.12249.172.camel@fourier>
Subject: Re: [PATCH 095/105] ARM: 7762/1: kernel: fix arm_dt_init_cpu_maps()
 to skip non-cpu nodes
From: Kamal Mostafa <kamal@canonical.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Date: Sat, 29 Jun 2013 07:22:40 -0700
In-Reply-To: <20130628235307.GB15316@e102568-lin.cambridge.arm.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
	 <1372445527-24414-96-git-send-email-kamal@canonical.com>
	 <20130628235307.GB15316@e102568-lin.cambridge.arm.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-YUEWrxe+gtvtpBt85hcO"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YUEWrxe+gtvtpBt85hcO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-06-29 at 00:53 +0100, Lorenzo Pieralisi wrote:
> On Fri, Jun 28, 2013 at 07:51:57PM +0100, Kamal Mostafa wrote:
> > 3.8.13.4 -stable review patch.  If anyone has any objections, please le=
t me know.
>=20
> Owing to dependencies on other patches getting upstreamed but not
> necessarily backported to stable, waiting for a decision on how to solve
> dependencies to be made asap, please drop this patch from the queue since
> it can trigger regressions.
>=20
> Thanks and apologies,
> Lorenzo


Dropped from the 3.8.y queue.  Thanks Lorenzo.

 -Kamal


> >=20
> > ------------------
> >=20
> > From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> >=20
> > commit 1ba9bf0a9ae779c1a2b3eb64951e4161d9bad7a9 upstream.
> >=20
> > The introduction of the cpu-map topology node in the cpus node implies
> > that cpus node might have children that are not cpu nodes. The DT
> > parsing code needs updating otherwise it would check for cpu nodes
> > properties in nodes that are not required to contain them, resulting
> > in warnings that have no bearing on bindings defined in the dts source =
file.
> >=20
> > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Acked-by: Nicolas Pitre <nico@linaro.org>
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> > ---
> >  arch/arm/kernel/devtree.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
> > index 70f1bde..93fde23 100644
> > --- a/arch/arm/kernel/devtree.c
> > +++ b/arch/arm/kernel/devtree.c
> > @@ -92,6 +92,9 @@ void __init arm_dt_init_cpu_maps(void)
> >  	for_each_child_of_node(cpus, cpu) {
> >  		u32 hwid;
> > =20
> > +		if (of_node_cmp(cpu->type, "cpu"))
> > +			continue;
> > +
> >  		pr_debug(" * %s...\n", cpu->full_name);
> >  		/*
> >  		 * A device tree containing CPU nodes with missing "reg"
> > --=20
> > 1.8.1.2
> >=20
> >=20
>=20


--=-YUEWrxe+gtvtpBt85hcO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJRzu2wAAoJEHqwmdxYrXhZxWAP/2KEWjNJd2vfSPiD53odOkAR
RIhJJe7dG9GWayj7UOxBOaLg00OK2LBc5XwqbWgcoX2nCMeuQIm0W+2lOJ+y/uNf
SYrmVN1ZGUQVX9H6OeLPk+yvTfKlSk9N6Lyr1WD/BqL8jJMsGYgRviuz3kP5CEvV
RXFlt9FFgNaG4E8HU8YmIKaWzLs2AxvcolUhaGpVq8SKzbvrAexb+9EqDWJB6HNx
7SKauJo+LbdR/9e2k8vUlNSuhw2yuA8yddN/Ur2/T/Gvir0U2hrkdl7uzg1egnUW
VtlPcbRs9SoI63ioXabg+T3Ev+WTvsD5RdJWkLk6uyyt1EWoaXlIClD122YwpCXm
uXrpUjOr8vsRn0HldBMQMsQUr6/03YjwDb4KsM5snAoVke4rWg81MRMKHDDO/9zw
F+xc0r7zUMEC6pW/ORKJuoxu+gGFxELtTq7z14LnmQV004zQmNFOASg+aMu0h7GL
uQ3zRMTR31NV+yBu8Wfo2yLVEzexshqi/SdBwMYXsmvz0Ofuc6Ptac499+DVEjCH
ljbrKQxHrtWEmq2Bp1L86kHN4Iy83Acolg/C2ZfUDdZId12ohPtAGNXMeLcbmCdD
eIjGjrOw6tUPR85+aflz0cYXEHFGfw8trtf5VmM3tjUhlWDhSy5EFfF06cbeSLce
FCK8qEwFedfz9W11vhF2
=xr8H
-----END PGP SIGNATURE-----

--=-YUEWrxe+gtvtpBt85hcO--

