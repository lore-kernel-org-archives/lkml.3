Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933858AbaKMSf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:35:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47139 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933673AbaKMSfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:35:25 -0500
Message-ID: <1415903703.3398.115.camel@decadent.org.uk>
Subject: Re: [PATCH 3.17 023/319] drivers/net: Disable UFO through virtio
From: Ben Hutchings <ben@decadent.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 13 Nov 2014 18:35:03 +0000
In-Reply-To: <5464EF03.9020002@suse.cz>
References: <20141112010952.553519040@linuxfoundation.org>
		 <20141112010956.540146480@linuxfoundation.org>
	 <1415826239.3398.113.camel@decadent.org.uk> <5464EF03.9020002@suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-f+H4smH/1MqRe8+26kWX"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f+H4smH/1MqRe8+26kWX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-11-13 at 18:48 +0100, Jiri Slaby wrote:
> On 11/12/2014, 10:03 PM, Ben Hutchings wrote:
> > On Wed, 2014-11-12 at 10:12 +0900, Greg Kroah-Hartman wrote:
> >> 3.17-stable review patch.  If anyone has any objections, please
> >> let me know.
> >>=20
> >> ------------------
> >>=20
> >> From: Ben Hutchings <ben@decadent.org.uk>
> >>=20
> >> [ Upstream commit 3d0ad09412ffe00c9afa201d01effdb6023d09b4 ]
> >>=20
> >> IPv6 does not allow fragmentation by routers, so there is no=20
> >> fragmentation ID in the fixed header.  UFO for IPv6 requires the
> >> ID to be passed separately, but there is no provision for this in
> >> the virtio net protocol.
> >>=20
> >> Until recently our software implementation of UFO/IPv6 generated
> >> a new ID, but this was a bug.  Now we will use ID=3D0 for any
> >> UFO/IPv6 packet passed through a tap, which is even worse.
> >>=20
> >> Unfortunately there is no distinction between UFO/IPv4 and v6=20
> >> features, so disable UFO on taps and virtio_net completely until
> >> we have a proper solution.
> > [...]
> >=20
> > Please drop this patch for 3.14 and 3.17.  It causes problems for=20
> > migration of VMs and we're probably going to revert part of this.
> > The following patch ("drivers/net, ipv6: Select IPv6 fragment
> > idents for virtio UFO packets") might no longer apply, in which
> > case you can drop that as well until we have this sorted out
> > upstream.
>=20
> The same holds for 3.12, I suppose?

Right.

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-f+H4smH/1MqRe8+26kWX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVGT54ue/yOyVhhEJAQrRtQ//a7i4KzBv+m3iy0e6wXl+cdMvzxymTsWz
IeyHkYAMYFr0GJUDt5IQgOIXc+Wat8cHh2c+Ovc8/q0OI5Hlqb8d7ya6h8UsMtD/
ONAnzjOIwFfJZftLvnf72vgWKOaxRsLZpWKgdSvsz14+vLlhrzRFECkbtZmvg8JB
jNWRux+ABgwJZEU/mZiroqTAukYFBI+7g5zC9ouuTgpy+UGiaMjrf8LHKcYHyDPq
VnrYz8ZNbv9/q1K9C6PTyC+BxQFHP/nNYhWnq9qUBDA+j3WjwoMrdmXrSrtaY7Vn
pPPicHE0iUj90TaODhG2DP98vB/TdBQNK4IHnRM+FoX4THNG9vzQaO/ABnJvqiLb
G0lyIwlznMLwdAOTb2xSp4muj+QcqGhBPJ6SVKCiX4esNqeP0PKu7aKqVeAu1oHe
N/uTd2/mDJj4YXpWg+OEdaQRYTjKdakohwOZANSDtEJ9ELC8mcR5VYBLmUkm18Yi
lrJm05YX5iR7puglspDtkJ1ZKyUui8z0LD9Rok+qaxsj/NhbEz6h6qlov00TjWpc
IVLF+k3RzpVwUx2mkgiYFjg189HNt+PMzOZpcRQ+FsP2me/3kpmz1sZ5EXAzioTP
Iaw3qR7r29qk2OqR9DMdklIJCn89yowqmwPEI/FqyEdcAuOGBJAy+LX+nBKBwFnS
zjJtxCRyoBs=
=59UY
-----END PGP SIGNATURE-----

--=-f+H4smH/1MqRe8+26kWX--
