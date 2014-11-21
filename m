Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbaKUAeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 19:34:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33395 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756132AbaKUAet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 19:34:49 -0500
Message-ID: <1416530074.7215.11.camel@decadent.org.uk>
Subject: Re: [PATCH 1/2] 8139too: Allow setting MTU larger than 1500
From: Ben Hutchings <ben@decadent.org.uk>
To: Alban Bedel <albeu@free.fr>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benoit Taine <benoit.taine@lip6.fr>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 21 Nov 2014 00:34:34 +0000
In-Reply-To: <1415447316-12424-1-git-send-email-albeu@free.fr>
References: <1415447316-12424-1-git-send-email-albeu@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-QM3yg4dxsEitY9RYt6qF"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QM3yg4dxsEitY9RYt6qF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2014-11-08 at 12:48 +0100, Alban Bedel wrote:
> Replace the default ndo_change_mtu callback with one that allow
> setting MTU that the driver can handle.
>=20
> Signed-off-by: Alban Bedel <albeu@free.fr>
> ---
>  drivers/net/ethernet/realtek/8139too.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/etherne=
t/realtek/8139too.c
> index 007b38c..8387de9 100644
> --- a/drivers/net/ethernet/realtek/8139too.c
> +++ b/drivers/net/ethernet/realtek/8139too.c
> @@ -185,6 +185,9 @@ static int debug =3D -1;
>  /* max supported ethernet frame size -- must be at least (dev->mtu+14+4)=
.*/
>  #define MAX_ETH_FRAME_SIZE	1536
> =20
> +/* max supported payload size */
> +#define MAX_ETH_DATA_SIZE	(MAX_ETH_FRAME_SIZE - ETH_HLEN - ETH_FCS_LEN)
[...]

Does this maximum still allow for VLAN tags, or should it use
VLAN_ETH_HLEN instead of ETH_HLEN?

Ben.

--=20
Ben Hutchings
Beware of bugs in the above code;
I have only proved it correct, not tried it. - Donald Knuth

--=-QM3yg4dxsEitY9RYt6qF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVG6IoOe/yOyVhhEJAQphNg//arOAUbFfHPlZAgz+up1cRvKDuU99FrGP
fPKdaHJ0UNCmnuW/VEUP5jUKWNIIOvOUQVOkrnOcEPhzsFMWpKOdXXX4RciRAeJw
ICaW03kIZpbRqTJpBdsMLywOWGtvpWJlLa4r58Mm0KtxoxeE1emKGJxnOgKfzqT8
LXSqHfpWA4RCP6Gtq1X+Ot3upDyy6lAvD2fr9xPK1Xh513uUCltHMLuOkUVPHLYP
G7viORLvXXB7KMtJaz3sSQ/2JUGzg9Y2SNo1uN5Av/oRc5ObkuKVWfmpE2Nu7TYp
b1BDMZnJP2oF2xOapz4MdYCsCjNoiKzM2zsdJzRRBfgZrioirnLcGeSNxxTMlU5H
reGXKOWiKNKVZ4sLG+ToD11ndxhKYz2eA+3nAFwUjohGLVQAoVrdIU+zbq22CpBC
AKg+gFwU/OVwO03sSPfqUgyt5v2oRzzW/gydYPAqWCYDI7K9rSKUlUfpPxqjZ2Ik
V5FJojY6unlYGNZGiNo07grDGS0tvmFt2tYFlSTK/DOoOCK6y0q3J68PtDZL3qTa
/1JaS7/qqv02QQHLi4kUnot5ZeLa+nAQO4carwhTiSDhhz50SRcKxSy+7+jTDciC
dOuePs/p5EXKzj2vp97N8xoBVY+ywJnZaF1FtopFx8KN3XuAxn2wKUM9dsp+67A4
83U9wddnMOI=
=s1bc
-----END PGP SIGNATURE-----

--=-QM3yg4dxsEitY9RYt6qF--
