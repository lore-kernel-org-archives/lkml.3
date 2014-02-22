Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaBVAem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 19:34:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55443 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752884AbaBVAek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 19:34:40 -0500
Message-ID: <1393029274.15717.68.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH net-next 01/35] bnx2: Use pci_enable_msix_range()
 instead of pci_enable_msix()
From: Ben Hutchings <ben@decadent.org.uk>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michael Chan <mchan@broadcom.com>,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Date: Sat, 22 Feb 2014 00:34:34 +0000
In-Reply-To: <c8d230441b63d4c30818a55b0e6ca0f376572b87.1392717502.git.agordeev@redhat.com>
References: <cover.1392717502.git.agordeev@redhat.com>
	 <c8d230441b63d4c30818a55b0e6ca0f376572b87.1392717502.git.agordeev@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ouW7V1uOL9k6SuEjyz9D"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:9cab:bfa3:762:9b62
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ouW7V1uOL9k6SuEjyz9D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-02-18 at 11:07 +0100, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.
>=20
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Michael Chan <mchan@broadcom.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/net/ethernet/broadcom/bnx2.c |   15 ++++-----------
>  1 files changed, 4 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/=
broadcom/bnx2.c
> index cda25ac..ca6b362 100644
> --- a/drivers/net/ethernet/broadcom/bnx2.c
> +++ b/drivers/net/ethernet/broadcom/bnx2.c
> @@ -6206,7 +6206,7 @@ bnx2_free_irq(struct bnx2 *bp)
>  static void
>  bnx2_enable_msix(struct bnx2 *bp, int msix_vecs)
>  {
> -	int i, total_vecs, rc;
> +	int i, total_vecs;
>  	struct msix_entry msix_ent[BNX2_MAX_MSIX_VEC];
>  	struct net_device *dev =3D bp->dev;
>  	const int len =3D sizeof(bp->irq_tbl[0].name);
> @@ -6229,16 +6229,9 @@ bnx2_enable_msix(struct bnx2 *bp, int msix_vecs)
>  #ifdef BCM_CNIC
>  	total_vecs++;
>  #endif
> -	rc =3D -ENOSPC;
> -	while (total_vecs >=3D BNX2_MIN_MSIX_VEC) {
> -		rc =3D pci_enable_msix(bp->pdev, msix_ent, total_vecs);
> -		if (rc <=3D 0)
> -			break;
> -		if (rc > 0)
> -			total_vecs =3D rc;
> -	}
> -
> -	if (rc !=3D 0)
> +	total_vecs =3D pci_enable_msix_range(bp->pdev, msix_ent,
> +					   BNX2_MIN_MSIX_VEC, total_vecs);
> +	if (total_vecs < 0)
>  		return;

This would be better without the assignment to total_vecs.

Ben.

>  	msix_vecs =3D total_vecs;

--=20
Ben Hutchings
I haven't lost my mind; it's backed up on tape somewhere.

--=-ouW7V1uOL9k6SuEjyz9D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUwfwmue/yOyVhhEJAQocdw//X1LEsjyKsKVrebL4qRJxlDZEnMC6nqY7
otPZnC0/s/PAXP+K8KuOUjMvH8sV+WvS71QsaFymcyd+QIoZicqUSvUwNVOfiXhd
M2gKchsi76AvFXh+yfCK5X8S45Nm6m3SsZcfxWvXtORZ6F7NmZtrk22Uo0paNDvI
8TdTaE2MrXavx8ckTVp22OYhZiutocEu793Gpz3xtdvtP0+p7Dg+n9CcmqZlxcbf
rVOTDgca8n8YGAH/nd82kdGqydmdLq2vW6LJ3CkzNvq5bCLjvoKsoAaynCpB1i+P
JTSIKSR1kp/lotBRxYQiluv1PCGGK2HTpS7qG2sVL+ouiork7wILJaGioAlkv24k
QC/P4+oVHqH75rY4lSfRDgPEAr7UL4NIKY1LNszhmEbgXJEg/NDbs3RK1VO9/Qrr
ZS8dAywEH7mV/0zMwexZVIIpTrvpPLfCFGEMJ+KsvVw9Yu8i3SsE15nhv/9RLCFr
7NPk34uJvCfSJFX9rSjMKWdRxeFaLkbF+IBYnplZ263mj/xKWCKfNakBz3Im3NU2
cCeEXItzcHeh2164m+TSLO3APIkQlZ/M/m5BQMyT1SIP4H/4dsfyMmUPQWv9XTBw
Wm/KTqA9wzrWjmDKyVjPRdvQdsaQ2QQGBr26eg9On8hZLjxz51nIZgkDBP9fv+bc
+ZMqKJNjFAs=
=fo/3
-----END PGP SIGNATURE-----

--=-ouW7V1uOL9k6SuEjyz9D--
