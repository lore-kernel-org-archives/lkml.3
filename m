Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbaKWCnO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 21:43:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45296 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752281AbaKWCnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 21:43:12 -0500
Message-ID: <1416710574.7215.32.camel@decadent.org.uk>
Subject: Re: [PATCH 1/2] 8139too: Allow setting MTU larger than 1500
From: Ben Hutchings <ben@decadent.org.uk>
To: Alban <albeu@free.fr>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benoit Taine <benoit.taine@lip6.fr>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 23 Nov 2014 02:42:54 +0000
In-Reply-To: <20141121195738.038d2cc2@tock>
References: <1415447316-12424-1-git-send-email-albeu@free.fr>
	 <1416530074.7215.11.camel@decadent.org.uk> <20141121145853.1be898de@tock>
	 <1416595911.7215.23.camel@decadent.org.uk> <20141121195738.038d2cc2@tock>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kWvSQY7xvaLVtK+j8fgv"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kWvSQY7xvaLVtK+j8fgv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-11-21 at 19:57 +0100, Alban wrote:
> On Fri, 21 Nov 2014 18:51:51 +0000
> Ben Hutchings <ben@decadent.org.uk> wrote:
>=20
> > On Fri, 2014-11-21 at 14:58 +0100, Alban wrote:
> > > On Fri, 21 Nov 2014 00:34:34 +0000
> > > Ben Hutchings <ben@decadent.org.uk> wrote:
> > >=20
> > > > On Sat, 2014-11-08 at 12:48 +0100, Alban Bedel wrote:
> > > > > Replace the default ndo_change_mtu callback with one that allow
> > > > > setting MTU that the driver can handle.
> > > > >=20
> > > > > Signed-off-by: Alban Bedel <albeu@free.fr>
> > > > > ---
> > > > >  drivers/net/ethernet/realtek/8139too.c | 13 ++++++++++++-
> > > > >  1 file changed, 12 insertions(+), 1 deletion(-)
> > > > >=20
> > > > > diff --git a/drivers/net/ethernet/realtek/8139too.c
> > > > > b/drivers/net/ethernet/realtek/8139too.c index 007b38c..8387de9
> > > > > 100644 --- a/drivers/net/ethernet/realtek/8139too.c
> > > > > +++ b/drivers/net/ethernet/realtek/8139too.c
> > > > > @@ -185,6 +185,9 @@ static int debug =3D -1;
> > > > >  /* max supported ethernet frame size -- must be at least
> > > > > (dev->mtu+14+4).*/ #define MAX_ETH_FRAME_SIZE	1536
> > > > > =20
> > > > > +/* max supported payload size */
> > > > > +#define MAX_ETH_DATA_SIZE	(MAX_ETH_FRAME_SIZE -
> > > > > ETH_HLEN - ETH_FCS_LEN)
> > > > [...]
> > > >=20
> > > > Does this maximum still allow for VLAN tags, or should it use
> > > > VLAN_ETH_HLEN instead of ETH_HLEN?
> > >=20
> > > That might well be as the VLAN code seems to assume that the
> > > physical device can handle frames of MTU + VLAN_HLEN bytes. I can
> > > fix it, but to me it seems like the VLAN code should be fixed to
> > > respect the physical device MTU.
> >=20
> > Drivers that support VLANs have to allow for at least one VLAN tag
> > when validating the MTU.  This is obviously broken for multiple
> > layers of VLAN tags, but those are the semantics we're stuck with.
>=20
> Ok, I see. Should a I send a fix patch or redo a new version of this
> patch?

As your previous patches have already been applied, you'll need to send
a fix patch (if the answer to my question was no).

Ben.

--=20
Ben Hutchings
Never put off till tomorrow what you can avoid all together.

--=-kWvSQY7xvaLVtK+j8fgv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVHFJtue/yOyVhhEJAQo1kQ/8CG9PCS/H5YxjnZa2pdf6MTT6yx7P4itM
ckWRQnJ8HFK9HdS9Z/lWJGVvl+07ByCFs1P1yF1IDjDfystGqEXUAs0591f0Qk6D
HobsFNuwk7iWGefcFi3aoAtuKzKIKxANK74/tWsYzm3u1L+rZWkEZa2eVHa3ORrV
lx1DG7MSRZ+0aRF8sglnXp1BERmsDdFqvALE0e8A8+7EJfvI+N3EahTIHro98luo
2eQtgazrrog7STZQTaxGQKUpIv9te08E5pLh7ZoT05eP9RpmDWbJyyG15NhHfgAu
1iWU8FX0OcMXWpVMM86KAwPeVuhs6gLw3uoSSug3+jAsJoop80LiV7MPO/+YoIrr
wO+8l2ieUt+lt/t/IKNjC7SzH4ETmfe9tkqSd15pP9G1OfRs484ZT+OE+3fOdzeI
B3BsjWwN+pGqPzyrsv+7FqqoOcy7R0wlRgS4Flj+dGGLOg175rblWKbZH9OwnKkU
1t9MjxMRuliPLW+Jed4y8qfS13BAWCNjLw1qlWuCxikCC++w1nyHnmK/ybD1He14
Ia7gu5z402N3ZoRW841luA/QTI7eyF3BVkqWAn53SNcWUNwc4D2FSgQVcmC1QOpc
HpdOzPGR/bFH4u/hugszyIq0WQpzLgRVld+L2sl0Sy7NAvBJNJOqSEOyPmHgq7zC
6WvicWkmdys=
=u9b3
-----END PGP SIGNATURE-----

--=-kWvSQY7xvaLVtK+j8fgv--
