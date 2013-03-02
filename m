Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab3CBXAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 18:00:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50471 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052Ab3CBXAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 18:00:50 -0500
Message-ID: <1362265235.3768.156.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2] iommu/amd: Initialize device table after dma_ops
From: Ben Hutchings <ben@decadent.org.uk>
To: shuah.khan@hp.com
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, shuahkhan@gmail.com
Date: Sat, 02 Mar 2013 23:00:35 +0000
In-Reply-To: <1362087590.2822.44.camel@lorien2>
References: <1362087590.2822.44.camel@lorien2>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-6Ww+n+gsyuTIs+av3CJA"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6Ww+n+gsyuTIs+av3CJA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-02-28 at 14:39 -0700, Shuah Khan wrote:
> When dma_ops are initialized the unity mappings are created. The
> init_device_table_dma() function makes sure DMA from all devices is
> blocked by default. This opens a short window in time where DMA to
> unity mapped regions is blocked by the IOMMU. Make sure this does not
> happen by initializing the device table after dma_ops.
>=20
> Back-port upstream commit: f528d980c17b8714aedc918ba86e058af914d66b
> Tested on 3.2.38
>=20
> Signed-off-by: Joerg Roedel <joro@8bytes.org>
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> CC: stable@vger.kernel.org 3.2

I'm not convinced about this backport, because the order of
initialisation already changed a lot after 3.2 and before the upstream
commit.  So I'm going to wait for Joerg to confirm that this makes sense
before adding it to the patch queue.

Ben.

> ---
>  drivers/iommu/amd_iommu_init.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_ini=
t.c
> index 62a4d5c..b7d1cdd 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -1396,6 +1396,7 @@ static struct syscore_ops amd_iommu_syscore_ops =3D=
 {
>   */
>  static int __init amd_iommu_init(void)
>  {
> +	struct amd_iommu *iommu;
>  	int i, ret =3D 0;
> =20
>  	/*
> @@ -1444,9 +1445,6 @@ static int __init amd_iommu_init(void)
>  	if (amd_iommu_pd_alloc_bitmap =3D=3D NULL)
>  		goto free;
> =20
> -	/* init the device table */
> -	init_device_table();
> -
>  	/*
>  	 * let all alias entries point to itself
>  	 */
> @@ -1496,6 +1494,12 @@ static int __init amd_iommu_init(void)
>  	if (ret)
>  		goto free_disable;
> =20
> +	/* init the device table */
> +	init_device_table();
> +
> +	for_each_iommu(iommu)
> +		iommu_flush_all_caches(iommu);
> +
>  	amd_iommu_init_api();
> =20
>  	amd_iommu_init_notifier();

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-6Ww+n+gsyuTIs+av3CJA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTKEk+e/yOyVhhEJAQpiuxAAwQDAhgIShizYkFh8ZTD5HR2nY7WzAZGK
H8ugbP3XWKHbBQ6pjAfZ9Fctg/HFt5bYuj2ydolSeFWGoxkD9HoPf2vCREYWkHhw
aczPaxS+g/nLUxwV58Irdr003ESXez5kxLqgwl4X7MMg34jaiLDUwRGGRHdie3Bg
S60VjUDv6ofsVAZrtj05ROuR1pTIk7sSS2FLrdcsXKBvB+bb1FG8KxqxgAQiU1uY
Bmm/Lx7UdMsJVyroEvbH5WJ1uOHURs9sPgpHkc/G3M7QulfCGaGgeF0ABJbyM/G3
lUcZ/7gE8NXnjPw2uRIBgkBhU0l/LnfvpITVY4NcXVtXfsOGpZnqB+MfSpRJM5jw
RXEbg0Lgb1Nob9As2uwB0maEdwwUwwTlcBE6gZI6ZzVmA6+k+mBbXhFDR+PCvMtC
dKT4peNeTJN6p1YAZTn0bpbTTkTjeILWcRyXnRxb3UPPfCV+Wf4RrxmcJcOPTeKp
NGH4/uQSO7QDbnOYEYc3FROIbsXEORpLFWYA7f9MFw/IoXcU1DV+6aYuPMv03Ufh
s0ypDVijA/1jez8kqUWZu8RfLfZyXkok60xLrdd4Z1rcYtAgjmtvJ/xu/952kiay
zBn2Dp9TNf7WBjZKV6fC8BbSDWrzEi0cgwjBmcxJ5iAAaFobiGRT3dp45U9WZDwE
jU+YR6yfzhM=
=Dl8V
-----END PGP SIGNATURE-----

--=-6Ww+n+gsyuTIs+av3CJA--
