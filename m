Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaA3OFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:05:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36625 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224AbaA3OFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:05:00 -0500
Message-ID: <1391090693.4405.64.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v2 4/4] net: ethoc: implement ethtool operations
From: Ben Hutchings <ben@decadent.org.uk>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 30 Jan 2014 14:04:53 +0000
In-Reply-To: <CAMo8Bf+9A-yh-_EBmZeJqMhUKrHN5+BPtckFj_gnZ44tfnX__w@mail.gmail.com>
References: <1390975218-13863-1-git-send-email-jcmvbkbc@gmail.com>
	 <1390975218-13863-5-git-send-email-jcmvbkbc@gmail.com>
	 <1391047176.4405.43.camel@deadeye.wl.decadent.org.uk>
	 <CAMo8Bf+9A-yh-_EBmZeJqMhUKrHN5+BPtckFj_gnZ44tfnX__w@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jJskPsprv95CI/3w/6yk"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.239
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jJskPsprv95CI/3w/6yk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-01-30 at 07:04 +0400, Max Filippov wrote:
> On Thu, Jan 30, 2014 at 5:59 AM, Ben Hutchings <ben@decadent.org.uk> wrot=
e:
> > On Wed, 2014-01-29 at 10:00 +0400, Max Filippov wrote:
[...]
> >> +     priv->num_tx =3D rounddown_pow_of_two(ring->tx_pending);
> >
> > Range check?
>=20
> May there be requested more than ring->tx_max_pending that we
> indicated in the get_ringparam?

Yes, the ethtool core doesn't check that for you.

> >> +     priv->num_rx =3D priv->num_bd - priv->num_tx;
> >> +     if (priv->num_rx > ring->rx_pending)
> >> +             priv->num_rx =3D ring->rx_pending;
> >
> > So the RX ring may only ever be shrunk?!  Did you mean to compare with
> > priv->num_bd instead?
>=20
> First all non-TX descriptors are made RX, and if that's more than user
> requested I trim it.
[...]

OK, I get it.  But it would be clearer if you used min().

Ben.

--=20
Ben Hutchings
It is a miracle that curiosity survives formal education. - Albert Einstein

--=-jJskPsprv95CI/3w/6yk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUupcBee/yOyVhhEJAQrQExAAzI+bEEam774CRknGak2DLYipf8vMfpag
nM5rL60FAiL+STsg+gpX46FXB9UErAOuLDvxYFCuF4Jg/I0hJXq5bc0eh6DhRK6z
6965/A4MdOmX4mN4GbUyyCvFxHoPrIlVgL5a397EpCMZ8TpR2gDhq4NSklS9ka0l
UG5QWcjuj80QhaOLe8hDEflcyPn2+zqcF4Gr0NgsPalVt3RJycjCb9G5UJka1/4n
qE87bsdNVfGq9m/MbprUE2yTdJtEOFGKI/BVO2RBUVQwv+/KfrO3rQ1gkLhhPl4J
r/N05a6pNguBate51mG4MoO+SisV1HcLVlR/MXiK3AcUxwqzfYjlLZMbb3k3gOVZ
Ek22ZabXyZhkzE2E2O3qp70mTaTzJzR7lj/zLXSRd30cQUqNOEjNQa955hJVaTDU
8p3BlogGch2fbnm76rwBrWjW5FhA3wTllNFdxN15oecnDyjZ9iC7cKUZbR4/sgs4
wjz7gfPssCzrLDONbls2ziFpy2TLI08pfiyUQFyNGaAVCP7WGGTdCt6Mt6qjZOxt
FO+xHW1OOsGCk8NumhcJp6uwZPPu5OaV1euCvqWr6WZG/76/h8tQz4ZCQmdUG0QN
54tui5cuRien5zodryWJSMIcJa8Y2na+4KaMl6cT3L0BGU/Y1mF2uwyU0T32J6Kc
iloc/0mP4Sg=
=zcde
-----END PGP SIGNATURE-----

--=-jJskPsprv95CI/3w/6yk--
