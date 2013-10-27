Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab3J0WCf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 18:02:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59389 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397Ab3J0WCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 18:02:33 -0400
Message-ID: <1382911333.2994.55.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
From: Ben Hutchings <ben@decadent.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
Date: Sun, 27 Oct 2013 22:02:13 +0000
In-Reply-To: <1382911111.30941.2.camel@joe-AO722>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
	 <1382910645.2994.45.camel@deadeye.wl.decadent.org.uk>
	 <1382911111.30941.2.camel@joe-AO722>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-X4deC6X0m98Gy3zpky34"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-X4deC6X0m98Gy3zpky34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-10-27 at 14:58 -0700, Joe Perches wrote:
> On Sun, 2013-10-27 at 21:50 +0000, Ben Hutchings wrote:
> > Physical addresses may be wider than virtual addresses (e.g. on i386
> > with PAE) and must not be formatted with %p.
>=20
> %pa works.  %pa also prefixes with 0x.

Only as long as pci_resource_start() happens to be an lvalue.  I'd
rather not introduce that assumption.

Ben.

> > diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/=
hw/cxgb4/device.c
> []
> > @@ -602,10 +602,10 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
> >  	     rdev->lldi.vr->qp.size,
> >  	     rdev->lldi.vr->cq.start,
> >  	     rdev->lldi.vr->cq.size);
> > -	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p qpshift %lu "
> > +	PDBG("udb len 0x%x udb base %llx db_reg %p gts_reg %p qpshift %lu "
> >  	     "qpmask 0x%x cqshift %lu cqmask 0x%x\n",
> >  	     (unsigned)pci_resource_len(rdev->lldi.pdev, 2),
> > -	     (void *)(unsigned long)pci_resource_start(rdev->lldi.pdev, 2),
> > +	     (u64)pci_resource_start(rdev->lldi.pdev, 2),
> >  	     rdev->lldi.db_reg,
> >  	     rdev->lldi.gts_reg,
> >  	     rdev->qpshift, rdev->qpmask,
> >=20
> >=20
>=20
>=20
>=20

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-X4deC6X0m98Gy3zpky34
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUm2NZee/yOyVhhEJAQoBPA/+LjoCC6UW1oO/UXV8if43fJnqvwJTYwiA
F33UTLvCRKJA+ogaKCFGZAjc14Art72RW61nUfHjQpM03JzOefSL2fHTGJwT5Oo3
pBK/tGdW3gB2wLj2p82DVdQe+sWsXye1K0MjF7LzzgvK402aWcFUqzXzmSOQaF/X
E9PdvMO4wxVJ+Bx3fIsym9CbaeLcAkf4xpfssh37eRDK04w+vCahA+o5rTs/NCLn
GKscOTBsCSIR5hWTpmLSUKWQTqVUJRIZquze9z0FOpDNwlF0rTwDJ+Bb8jHiJ1VQ
JuPBWAKi2+sr1P+XlzUXdvsZUUNZi4QGR+uy6i2pg+Dt0RAdjAvBkoHyte0JCinn
tTKxBUMZOwBz8fO0uJVAqMS6ZJnDRdx7dt3P4uUdXqfr4WC7td0bJklx5NqlZRt9
PyFnRWwcjTePNk4LOQpVF4kdFoaXsVtanrULDLy3b7HrA51k+hltvgR89FD+On+e
MkAk59lLrkrIXaJ43uP3VPjSUHjTTzu4fuOWsI6AJ8yQDAI7Xa2i/GgpUkxmTaBv
MW0qeATOOlv9NiIYxdAP4KzLZO+HXgwzMGvx4pMLZrFApL3ZSzkLHXLG1mpwTcEO
0oRYMi8h3YcY0R7ewFe6PZhBNg6Io4P7ysLn26EVhqEr2AvcXokuZOjr8QGNWnS1
R04bi5CqmMI=
=SRRF
-----END PGP SIGNATURE-----

--=-X4deC6X0m98Gy3zpky34--
