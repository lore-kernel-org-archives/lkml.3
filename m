Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaACC7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:59:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:39826 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaACC7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:59:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,595,1384329600"; 
   d="asc'?scan'208";a="461006281"
Date: Thu, 2 Jan 2014 21:40:38 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [RFC PATCHv3 02/11] iommu/omap: Use get_vm_area directly
Message-ID: <20140103024038.GD1913@gchen.bj.intel.com>
Mail-Followup-To: Laura Abbott <lauraa@codeaurora.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kyungmin Park <kmpark@infradead.org>, Dave Hansen <dave@sr71.net>,
	linux-mm@kvack.org, Joerg Roedel <joro@8bytes.org>,
	linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
 <1388699609-18214-3-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ycz6tD7Th1CMF4v7"
Content-Disposition: inline
In-Reply-To: <1388699609-18214-3-git-send-email-lauraa@codeaurora.org>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ycz6tD7Th1CMF4v7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 02, 2014 at 01:53:20PM -0800, Laura Abbott wrote:
> diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
> index d147259..6280d50 100644
> --- a/drivers/iommu/omap-iovmm.c
> +++ b/drivers/iommu/omap-iovmm.c
> @@ -214,7 +214,7 @@ static void *vmap_sg(const struct sg_table *sgt)
>  	if (!total)
>  		return ERR_PTR(-EINVAL);
> =20
> -	new =3D __get_vm_area(total, VM_IOREMAP, VMALLOC_START, VMALLOC_END);
> +	new =3D get_vm_area(total, VM_IOREMAP);
This driver is a module but get_vm_area is not exported. You need to add
one extra EXPORT_SYMBOL_GPL(get_vm_area).


--Ycz6tD7Th1CMF4v7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSxiMmAAoJEI01n1+kOSLH9xgP/AhHieQaiUiJ0LAI2it3pQQx
dQiXOhvWANMFORGLj00UXRvQQlxs1jorUp4jxxUePWbqT+ZQvOVGIJZwmF3W0Vp3
bPLWbVCcYM1x0AtEqFTC0MRieBCdwK3MOhLN3eVvurWyXyPJD73wVmOGEqpXkLoG
cMMvfnf/w/V6fdTi3ryAwBn2E8aIrdLuU3FwooDSSl5PztLHXUSlkpqNrn5FnNBD
JNil5+clc619Nw1W3IYoCkOYrFQoxVjLgRlS9MfhyKMP+wt/iJmu+t6kI+OYJouV
OJRqjeu8syC8V+nZNkL/StzqthKTdCJbXJRy/GFFCePwzvacuEPmdAtQ3Dhyixvx
EAVzj4DbL2xEiz+v8iFisu6vz7i12VoKoTqSlb/Bz6VCKpQQ34lzU+axjsPOgZrU
4bDMlNdtGDPjASbjHxtSRfL+U6cJuDmH86zXenjzosBTD5MRnhOw80bagbejl30b
E65cHCCGstx2O9D691QHCnoVY6Xubqmq5HhWXS8Exl+72FiAUaN5pcTtTjsYcn1q
dyjPNfOTVhDMC/5mAMisiqxghMasXnMMUpDltc5s2mw5I5EnRQRSdfJzhJ75rxQW
y3R9ibRlO4DMnb+eeXknulaw1P3psQ1KW39CA9nh8rHHLdZ10OaAGs97VwlWkiQw
rUW2+MyROALPhKwm8NAy
=ud7f
-----END PGP SIGNATURE-----

--Ycz6tD7Th1CMF4v7--
