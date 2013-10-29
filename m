Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3J2Iuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:50:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36045 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab3J2Iur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:50:47 -0400
Message-ID: <526F76D4.5090404@ti.com>
Date: Tue, 29 Oct 2013 10:50:28 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: linux-next: build failure after merge of the final tree (fbdev
 tree related)
References: <20131029012317.b9ba8173dee5bac1a5bd2404@canb.auug.org.au>
In-Reply-To: <20131029012317.b9ba8173dee5bac1a5bd2404@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="QehwGFLxiRbx444Pr0ffx2WnvrcgQ7G9T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--QehwGFLxiRbx444Pr0ffx2WnvrcgQ7G9T
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 28/10/13 16:23, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the final tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:
>=20
> drivers/video/xilinxfb.c: In function 'xilinxfb_of_probe':
> drivers/video/xilinxfb.c:431:30: error: 'op' undeclared (first use in t=
his function)
>=20
> Caused by commit 353846fb8bb7 ("video: xilinxfb: Use standard variable
> name convention") from the fbdev tree.
>=20
> I have applied the following fix patch for today:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 29 Oct 2013 01:18:22 +1100
> Subject: [PATCH] video: xilinxfb: Fix for "Use standard variable name c=
onvention"
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/video/xilinxfb.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
> index 9eedf9673b7f..6ff1a91e9dfd 100644
> --- a/drivers/video/xilinxfb.c
> +++ b/drivers/video/xilinxfb.c
> @@ -428,11 +428,11 @@ static int xilinxfb_of_probe(struct platform_devi=
ce *pdev)
>  #ifdef CONFIG_PPC_DCR
>  	else {
>  		int start;
> -		start =3D dcr_resource_start(op->dev.of_node, 0);
> -		drvdata->dcr_len =3D dcr_resource_len(op->dev.of_node, 0);
> -		drvdata->dcr_host =3D dcr_map(op->dev.of_node, start, drvdata->dcr_l=
en);
> +		start =3D dcr_resource_start(pdev->dev.of_node, 0);
> +		drvdata->dcr_len =3D dcr_resource_len(pdev->dev.of_node, 0);
> +		drvdata->dcr_host =3D dcr_map(pdev->dev.of_node, start, drvdata->dcr=
_len);
>  		if (!DCR_MAP_OK(drvdata->dcr_host)) {
> -			dev_err(&op->dev, "invalid DCR address\n");
> +			dev_err(&pdev->dev, "invalid DCR address\n");
>  			return -ENODEV;
>  		}
>  	}
>=20

Thanks, I have applied this to the fbdev tree.

 Tomi



--QehwGFLxiRbx444Pr0ffx2WnvrcgQ7G9T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSb3bUAAoJEPo9qoy8lh71ef4P/1l2B9oEZJ2swaRrUsDof+x4
opbHCrM4V9I5pYYeAJMqFcWMTDMXOevjTJd4ZsJxUNzniv59BZVeizNgZqtjoOH1
LhQiMZe4tq0/KTC6nNAMkz+ly2dZCniZp8WMYcbJCeNoMfDk9Iq1n1UTrQO6Mav4
LWjGYe8BfOKp1h6Wlio8XhxSSJC/8sNoEGAvUb5d7Qjemos7eFh9bP835wLMfWNl
VvGDrQzn2whDi7WhqZ65MbuIMcEK16sk4H1AqtXjmMp0brJQMFAPAfTI6Gy3Nebe
Zl9eTu917xI+rJUJEw2KQ5f3bIx7VmQSw/BdgmNUKEw8bbVrGDPwuALU3A6FogZG
YpOOO2z65qe6HAcA5bfxsY4myWpWokMfZV+7csFKLmmjdE3nr+HjzhHaeTQ5JbEQ
RMtE0LxDdRGgiOrcthwzUV09GMnp9FLaVF8Ux7bHZG0ccvDRiD+/UyIxund/rjmT
fDUyF0mgekzJc5uwORzMVj8AthjEeSzC8Xe+12AJI/yX+m+E6Tk5FD6EO9r3kZpm
VKHa2myiOurqWutVZ/EUP91ItEU2QkYLwQRLpMatnz+es093Pz563Q7xSr/dvfpK
3tIOahLSzVHwlrqRDWms+72hm729hKl9yeV4AlpdoErTs6fcWbRWjRP9eTydUHPe
k89yJF/Jcx20QRkkEUDx
=rzv3
-----END PGP SIGNATURE-----

--QehwGFLxiRbx444Pr0ffx2WnvrcgQ7G9T--
