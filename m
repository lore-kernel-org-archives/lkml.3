Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab3IPJwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 05:52:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54194 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab3IPJwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 05:52:03 -0400
Message-ID: <5236D4BD.9050707@ti.com>
Date: Mon, 16 Sep 2013 12:51:57 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, <monstr@monstr.eu>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 3/3] video: xilinxfb: Simplify error path
References: <7016a90750626ba866dddc6f85cfdd71943f6891.1378965270.git.michal.simek@xilinx.com> <940bbdfc5c67282ab461b9c82b55f18fc34c959d.1378965270.git.michal.simek@xilinx.com>
In-Reply-To: <940bbdfc5c67282ab461b9c82b55f18fc34c959d.1378965270.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="6P2vUu4kP6FDvu6DxrVB2dwQQfT5KEfoH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6P2vUu4kP6FDvu6DxrVB2dwQQfT5KEfoH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/09/13 08:54, Michal Simek wrote:

> @@ -394,16 +382,12 @@ static int xilinxfb_release(struct device *dev)
>  	/* Turn off the display */
>  	xilinx_fb_out32(drvdata, REG_CTRL, 0);
>=20
> -	/* Release the resources, as allocated based on interface */
> -	if (drvdata->flags & BUS_ACCESS_FLAG)
> -		devm_iounmap(dev, drvdata->regs);
>  #ifdef CONFIG_PPC_DCR
> -	else
> +	/* Release the resources, as allocated based on interface */
> +	if (!(drvdata->flags & BUS_ACCESS_FLAG))
>  		dcr_unmap(drvdata->dcr_host, drvdata->dcr_len);
>  #endif

I might be mistaken, and it's not strictly part of this series, but
shouldn't dcr_unmap be called somewhere else also, if the probe fails?

 Tomi



--6P2vUu4kP6FDvu6DxrVB2dwQQfT5KEfoH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSNtS9AAoJEPo9qoy8lh71O5UQAKPpph/pwJuzC8SNsMO+sHs0
DXrmUAlG5e3mzIEKta4WMweSBGxds0HTZ3T9X0quqqQE8rZa5gvV1S8H55+8O4At
WxiykPHhhRXyF4XDvYi2sTRMOn8nWjK58SOVaD8hXhMuLFFUiBgvXIEKjiyrSZ4J
5Etn9CnxXEcDRef7neO7jzu4dHcx6pqVoXs4syoPMhxSNcz0/mJJq9FdaLz4T/GT
dTxdVhg+dD1alzknRtmfgN4EoN5kIVwaZ39HztpbkEt0362QZrMAfO0gKn61O+95
pPzy0Yh+DZzt3VkA8eRXmJagk1dErnIxy0hwEJw6iu8Guf9PFVK1sPnBCDnhnxzI
LlF1SPyDAZMhaALeDq3sFAkSu82NQ8rh9Re9fAippcA2hvxw0DoLdCQ//+Fr/rmd
mxp2aF/AyzZQdv0BgrJVa9rCZABr8FTqG1n0Xxn0J36stM3QTO79BBovdZWoX0EF
8IQxygEn1wH8iuYfuwkjpDsr8qEDSBJi92zsLpMjzCuhFtqpQPXDcbdnMZ/ra6mx
h8soIeXoBgxaIa9I9LtUwjIsIU0Qc9/RrJB92LeeNhnOb7OVXqggkkIP1Y6uEDjq
v0yJINI8rzdrdvXASfQwcrPcB9WFn4YxLupblnPukfd52SMo95+pRd5Dhc7AmPCq
iPi4JXnfnY5Ho2RKSERF
=pssG
-----END PGP SIGNATURE-----

--6P2vUu4kP6FDvu6DxrVB2dwQQfT5KEfoH--
