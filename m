Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab3GZHdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:33:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47154 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3GZHdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:33:16 -0400
Message-ID: <51F2262F.1020203@ti.com>
Date: Fri, 26 Jul 2013 10:33:03 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] video: xilinxfb: Fix compilation warning
References: <b8701d73538d37495b41ef465440a6d5f3018870.1374759923.git.michal.simek@xilinx.com>
In-Reply-To: <b8701d73538d37495b41ef465440a6d5f3018870.1374759923.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="SKr076XwxEA5gGp0gIvKt3c95jPccDI96"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SKr076XwxEA5gGp0gIvKt3c95jPccDI96
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 25/07/13 16:45, Michal Simek wrote:
> regs_phys is phys_addr_t (u32 or u64).
> Lets use %pa printk format specifier.
>=20
> Fixes compilation warning introduced by:
> video: xilinxfb: Use drvdata->regs_phys instead of physaddr
> (sha1: c88fafef0135e1e1c3e23c3e32ccbeeabc587f81)
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> Changes in v3:
> - Fix commit message reported by Geert
>=20
> Changes in v2:
> - Use %pa instead of casting
>=20
> ppc44x_defconfig
> Fixes regressions in v3.11-rc2
>=20
> ---
>  drivers/video/xilinxfb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
> index f3d4a69..6629b29 100644
> --- a/drivers/video/xilinxfb.c
> +++ b/drivers/video/xilinxfb.c
> @@ -341,8 +341,8 @@ static int xilinxfb_assign(struct platform_device *=
pdev,
>=20
>  	if (drvdata->flags & BUS_ACCESS_FLAG) {
>  		/* Put a banner in the log (for DEBUG) */
> -		dev_dbg(dev, "regs: phys=3D%x, virt=3D%p\n", drvdata->regs_phys,
> -					drvdata->regs);
> +		dev_dbg(dev, "regs: phys=3D%pa, virt=3D%p\n",
> +			&drvdata->regs_phys, drvdata->regs);
>  	}
>  	/* Put a banner in the log (for DEBUG) */
>  	dev_dbg(dev, "fb: phys=3D%llx, virt=3D%p, size=3D%x\n",
> --
> 1.8.2.3
>=20

Thanks, I've applied this into my 3.12/fbdev branch.

 Tomi



--SKr076XwxEA5gGp0gIvKt3c95jPccDI96
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR8iYvAAoJEPo9qoy8lh71XSMP/0r7fsWbiFrlp8Ddf/VhiC5L
X5w881FBNVBYhbg03G+JdadOPix4KBkB2JcyDxPUmsONVu9vFc3jHw+pobms7GKD
T7uyNkbTAEjKnuwaAND3BtfHNSyhx+g/c6lGakx4rjC1Hzd3k8LSMIBcmpNsr2RE
EBRxkwxHWRJ813sVe8IgjfP5cLkUf1IelzdaWQK13lRNpKRFyTrJqX/RWkWEnzgh
ktcxgJR+draTbpzc48Ifeu4Kw4S6zmWiJqTGY8qLBw14xIxGVUWdlD2e+RyUqnCk
L67uiE3bQWyBywJWc9TSKzSrgmxYJvmygeu7MthKqqhs58wTadd0S0VP94D5G+7M
vsfWCz71mQUZABM+3nOD0w2e0+1wsJqBb9IyhPCJQY6CSw4B0V60q9wvIpERgIZp
Nvz+LsPxXHwyvF522fb2bYwWuUUuzjvUh8V02PX5D4BFrJU6wOSy+Q4Ph/uTNtP6
BQD4tmIMvciQY42WzE3gbFhyubQ/kq0LaiGRyxwT6dMpx9A2DtNRX1Sa2kGQ0MdM
tEArmYQi6T2c3QezjFz52vzyLI/h9XR0YFJUY+rXFEc2+laDUpOIcRJM3lVCS/dI
4eVS4vb3trgmYI9QxTr0Js0kRdPmNwysa8DcIdtGWmKH7HnICQKhJ416NzJSOrZF
uNAqGZGE6AAwLCaDvRdq
=gpQ8
-----END PGP SIGNATURE-----

--SKr076XwxEA5gGp0gIvKt3c95jPccDI96--
