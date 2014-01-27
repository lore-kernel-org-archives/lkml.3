Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaA0OuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:50:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55861 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753712AbaA0OuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:50:11 -0500
Message-ID: <1390834190.2735.143.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 1/3] net: via-rhine: switch to generic DMA functions
From: Ben Hutchings <ben@decadent.org.uk>
To: Alexey Charkov <alchark@gmail.com>
Cc: netdev@vger.kernel.org, linux@prisktech.co.nz, devicetree@vger.kernel.org,
        rl@hellgate.ch, linux-kernel@vger.kernel.org
Date: Mon, 27 Jan 2014 14:49:50 +0000
In-Reply-To: <1390823503-24087-2-git-send-email-alchark@gmail.com>
References: <1385227995-3956-1-git-send-email-alchark@gmail.com>
	 <1390823503-24087-1-git-send-email-alchark@gmail.com>
	 <1390823503-24087-2-git-send-email-alchark@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-WR/bumXEMf/ietEL7HTD"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.239
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WR/bumXEMf/ietEL7HTD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-01-27 at 15:51 +0400, Alexey Charkov wrote:
> Remove legacy PCI DMA wrappers and instead use generic DMA functions
> directly in preparation for OF bus binding
>=20
> Signed-off-by: Alexey Charkov <alchark@gmail.com>
> Signed-off-by: Roger Luethi <rl@hellgate.ch>
> ---
>  drivers/net/ethernet/via/via-rhine.c | 56 +++++++++++++++++++-----------=
------
>  1 file changed, 29 insertions(+), 27 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/=
via/via-rhine.c
> index ef312bc..fee8732 100644
> --- a/drivers/net/ethernet/via/via-rhine.c
> +++ b/drivers/net/ethernet/via/via-rhine.c
> @@ -919,10 +919,10 @@ static int rhine_init_one(struct pci_dev *pdev, con=
st struct pci_device_id *ent)
>  		goto err_out;
> =20
>  	/* this should always be supported */
> -	rc =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> +	rc =3D dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
>  	if (rc) {
>  		dev_err(&pdev->dev,
> -			"32-bit PCI DMA addresses not supported by the card!?\n");
> +			"32-bit DMA addresses not supported by the card!?\n");
>  		goto err_out;
>  	}
> =20
> @@ -1094,20 +1094,22 @@ static int alloc_ring(struct net_device* dev)
>  	void *ring;
>  	dma_addr_t ring_dma;
> =20
> -	ring =3D pci_alloc_consistent(rp->pdev,
> +	ring =3D dma_alloc_coherent(&rp->pdev->dev,
>  				    RX_RING_SIZE * sizeof(struct rx_desc) +
>  				    TX_RING_SIZE * sizeof(struct tx_desc),
> -				    &ring_dma);
> +				    &ring_dma,
> +					GFP_ATOMIC);
[...]

Indentation is messed up here (and in several other function calls
you're changing).  You should align the function arguments so each line
begins in the column after the opening parenthesis.

Ben.

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-WR/bumXEMf/ietEL7HTD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUuZyDue/yOyVhhEJAQrTYA/9Gpn0fWkilBWjm0iA0Iqjdx/JJJjCW2e8
q80ByLz/X7KfW/LuLyMZzDzXMA4dxK8LtGiIsNdBV8PiddtZBSePnXpSex1lvQvR
61usSDcL+mWVvpPQoVmoENfl+NOn3EZh8FWSzv5+abJwvnuS+rRRdVtbLhOAJ6yO
e9KXai3Y1kYbjC02Tl5R6IL0rNCn6dqtCWwZU0ATtSc9Fv1jg7W6LYnyF5+lXwx+
3orNHnhwTAJq6xCdzfvRLyKn43KoMvdiFyz/mSL+Oap3FELQwIajgf65egcXhSc6
hrKKT4Wf96axGmfvETobk2i00fMJhVMeK21K3CtNtB3ndIg2WVYqfDb6d1kmH7Yu
uBCWqepQWW/yqrtfUM69lGsbDSVb1ZK9qBP+Aq+yYqPyaKixyj0QhzgvZPNQ8t4c
6TMKCon5/Xv+G1qA0NpsEVz0nSH66Cej8G8edISQqijKJXInlYZcHf8xxE6ns2fg
ahakVqWOVwhqPXE22JvcVCBTIcRMCtnMdX2SBzg8OTDRM4+hlVeXlo/Un/FNB6ya
kyMf4GYrVKrhgT4+E1+q7GX1yPoapvlJMgFEA3aI6SgjQQbU8ETEAI+g30fu1YMX
ZDFmUdGahDHxwxAT54HprjUckDo/SgpMs2gy6XcFtOnjdKjx3s88TFb3j24NMe3z
4PFIjzOlR80=
=vFFp
-----END PGP SIGNATURE-----

--=-WR/bumXEMf/ietEL7HTD--
