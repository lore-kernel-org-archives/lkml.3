Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaKLVEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:04:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41982 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbaKLVEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:04:13 -0500
Message-ID: <1415826239.3398.113.camel@decadent.org.uk>
Subject: Re: [PATCH 3.17 023/319] drivers/net: Disable UFO through virtio
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 12 Nov 2014 21:03:59 +0000
In-Reply-To: <20141112010956.540146480@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
	 <20141112010956.540146480@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fyS2077tLNguS60BQNW/"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fyS2077tLNguS60BQNW/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-11-12 at 10:12 +0900, Greg Kroah-Hartman wrote:
> 3.17-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Ben Hutchings <ben@decadent.org.uk>
>=20
> [ Upstream commit 3d0ad09412ffe00c9afa201d01effdb6023d09b4 ]
>=20
> IPv6 does not allow fragmentation by routers, so there is no
> fragmentation ID in the fixed header.  UFO for IPv6 requires the ID to
> be passed separately, but there is no provision for this in the virtio
> net protocol.
>=20
> Until recently our software implementation of UFO/IPv6 generated a new
> ID, but this was a bug.  Now we will use ID=3D0 for any UFO/IPv6 packet
> passed through a tap, which is even worse.
>=20
> Unfortunately there is no distinction between UFO/IPv4 and v6
> features, so disable UFO on taps and virtio_net completely until we
> have a proper solution.
[...]

Please drop this patch for 3.14 and 3.17.  It causes problems for
migration of VMs and we're probably going to revert part of this.  The
following patch ("drivers/net, ipv6: Select IPv6 fragment idents for
virtio UFO packets") might no longer apply, in which case you can drop
that as well until we have this sorted out upstream.

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppne=
r

--=-fyS2077tLNguS60BQNW/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVGPLRee/yOyVhhEJAQoD9hAAwsvLNMTBiCuL85qOB1e2QaozgvRGD/eM
kJDnaTwgmOX0kTqIWimDN0ombPpsTYx3BkalWlAlQnqpbSsIaDokG43J/DRxG1T6
gwIeYzF/BnuLhPIJt5Zcrao9PJHFngg4+3vyqlS8dgUg3DpA/aGkmGI2Iu1fov/n
e26YaIkLuDuSgvzj7RoFthj/JsNA5w27xTJm8c+K4PW30WZyt6/m2PRm1lZ+Nhyk
IQe2XM9BQ26DL3SqoJ+W6yiIJFoQHZVesMsBgdmAsZpEo8X58aIFWm/wDtS7yVNt
PikqhkW63wLQjd5x+vMgWdrhSszMpLqCO2sJA/7n1LS0HT3na+5CRhiNm/QIGrp1
DRmy0CbaNhMRqmOKeJcGR4TGRJ6MoE2x0LeGUzAnbNUBmpjEbY4dNZAfkp1L0LkE
+kOd/YaErkpiBJE11w3yYx9CBLk8b/nhYN28VKF6bMdZpdvgzAkMskZUmA7QRIrN
nyXqVW/P8BavVQH12cRUL5YmL4nnjFu9L+npVHgFwytpvgz+jzO7yW+EVji6ZuwF
OMDm2/k1qZZlnbZvNlUOXph3hHQtqvBpvE/fXa1oUU38TpIJ6S69RNDt0bLxW80g
y0tCA1NmO6PmDasMPgqdGjl/bdGqPCgp+X6sBditdtaoW4HQF8e4SWYN7pZlcFMi
/zPKa4wcKwE=
=62zn
-----END PGP SIGNATURE-----

--=-fyS2077tLNguS60BQNW/--
