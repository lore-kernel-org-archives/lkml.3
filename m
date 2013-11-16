Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab3KPH2G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 02:28:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:2184 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab3KPH17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 02:27:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,712,1378882800"; 
   d="asc'?scan'208";a="434457059"
Date: Sat, 16 Nov 2013 12:01:47 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the dmaengine tree with the
 slave-dma tree
Message-ID: <20131116063147.GH8834@intel.com>
References: <20131115125604.a12f24a58bcbf91cc26cc20e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fOHHtNG4YXGJ0yqR"
Content-Disposition: inline
In-Reply-To: <20131115125604.a12f24a58bcbf91cc26cc20e@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fOHHtNG4YXGJ0yqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2013 at 12:56:04PM +1100, Stephen Rothwell wrote:
> Hi Dan,
>=20
> Today's linux-next merge of the dmaengine tree got a conflict in
> drivers/dma/dmatest.c between commit 19e9f99f273b ("dmaengine: dmatest:
> use DMA_COMPLETE for dma completion status") from the slave-dma tree and
> commit 872f05c6e9a3 ("dmatest: replace stored results mechanism, with
> uniform messages") from the dmaengine tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
Thanks, we are sending single PULL to linus so I am merging Dan's tree to m=
ine
so this should vanish

--
~Vinod
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc drivers/dma/dmatest.c
> index 59e287f56dfc,329b7cf02f8e..000000000000
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@@ -735,17 -633,17 +633,17 @@@ static int dmatest_func(void *data
>   			 * free it this time?" dancing.  For now, just
>   			 * leave it dangling.
>   			 */
> - 			thread_result_add(info, result, DMATEST_ET_TIMEOUT,
> - 					  total_tests, src_off, dst_off,
> - 					  len, 0);
> + 			dmaengine_unmap_put(um);
> + 			result("test timed out", total_tests, src_off, dst_off,
> + 			       len, 0);
>   			failed_tests++;
>   			continue;
>  -		} else if (status !=3D DMA_SUCCESS) {
>  +		} else if (status !=3D DMA_COMPLETE) {
> - 			enum dmatest_error_type type =3D (status =3D=3D DMA_ERROR) ?
> - 				DMATEST_ET_DMA_ERROR : DMATEST_ET_DMA_IN_PROGRESS;
> - 			thread_result_add(info, result, type,
> - 					  total_tests, src_off, dst_off,
> - 					  len, status);
> + 			dmaengine_unmap_put(um);
> + 			result(status =3D=3D DMA_ERROR ?
> + 			       "completion error status" :
> + 			       "completion busy status", total_tests, src_off,
> + 			       dst_off, len, ret);
>   			failed_tests++;
>   			continue;
>   		}



--=20

--fOHHtNG4YXGJ0yqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJShxFTAAoJEHwUBw8lI4NHgA8P/0bpjFfoTbF0et6lGPMiSbPN
HCJvqN9hWlvQi7Pa9M7tCAC9C9ORv5qnWw0S3I++9+GoejFJgB9A81x3yOnPenrx
7otuJr7lLZABCFf8NI2qa+sTF6bLd++95U9pzN0ZxZyCFGuCA5iv9QHJUweu1fv6
0yO+Y9U3NPK7SW4AkzOEtka4/GjhbYuBRbiXpZeFXlLNG2fA+GsmmiCTOIwFoSlB
x4GgZ+qaDpuYuYRP3Mq1fhUWDpThE5Rkh78pXYnzkoowM4O/B+c7bksxZbgtJfCz
13TnhtJSuOiFWPw+GZyBpPhbuD3+bsNmIfgvu3+nsBnORblVgGYsZGVlgNMAkGip
67G6z1sxQ+fyM/Gn6GFDyws1rvZwDU3k2EsZ44GBmLWcayfUgj3xyChBkYvS8Hhu
BjzI8SGEAwatS1s2wAR90MEcK0aYtROCChNiFP92p5X1pArc9OXwYrWvaw459dfX
5L+ZL6EQ9PFZW8u9H2Sz0xYDvpmGTif6lMmB29FhVww6RiFue2pEM+qNkTTCyuop
oV3/1XRnfX6/yaSDKoND8wdXB+G02t8i5sEZkab1ZjJGLccfb3ApjdTkroSOryPi
Ws6Kx9bFebF7H3NZF5/vT7vgqa0Bf+u9tjKBYDnYniC8oOlyDgDYap31K1AY/Bsu
PZI7dml3VJJSqne4h3IH
=Fb5f
-----END PGP SIGNATURE-----

--fOHHtNG4YXGJ0yqR--
