Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965996Ab3FTUCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 16:02:55 -0400
Received: from sauhun.de ([89.238.76.85]:38766 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965968Ab3FTUCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 16:02:53 -0400
Date: Thu, 20 Jun 2013 22:04:54 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH v8] i2c-designware: make SDA hold time configurable
Message-ID: <20130620200454.GE2961@katana>
References: <51BF77C2.70004@gmail.com>
 <1371541469-20623-1-git-send-email-christian.ruppert@abilis.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FEz7ebHBGB6b2e8X"
Content-Disposition: inline
In-Reply-To: <1371541469-20623-1-git-send-email-christian.ruppert@abilis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FEz7ebHBGB6b2e8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2013 at 09:44:29AM +0200, Christian Ruppert wrote:
> This patch makes the SDA hold time configurable through device tree.
>=20
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
> Signed-off-by: Pierrick Hascoet <pierrick.hascoet@abilis.com>

Okay, I am convinced of the property now...

> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/bu=
sses/i2c-designware-platdrv.c
> index 35b70a1..81362e5 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -34,6 +34,7 @@
>  #include <linux/sched.h>
>  #include <linux/err.h>
>  #include <linux/interrupt.h>
> +#include <linux/of.h>
>  #include <linux/of_i2c.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm.h>
> @@ -121,6 +122,15 @@ static int dw_i2c_probe(struct platform_device *pdev)
>  		return PTR_ERR(dev->clk);
>  	clk_prepare_enable(dev->clk);
> =20
> +	if (pdev->dev.of_node) {
> +		u32 ht;
> +		u32 ic_clk =3D dev->get_clk_rate_khz(dev);
> +
> +		of_property_read_u32(pdev->dev.of_node,
> +					"i2c-sda-hold-time-ns", &ht);
> +		dev->sda_holdO_time =3D ((u64)ic_clk * ht + 500000) / 1000000;

=2E.. but is this correct even if the property is not defined?

> +	}
> +

Thanks for all the input so far!


--FEz7ebHBGB6b2e8X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRw2BmAAoJEBQN5MwUoCm2J9oP/iejXcptCupmvxhKbsEKhyKv
SLgnaiIbiOrjhXNILTBNA5RALnISWVED/ONFa85kN4ERCRD9zDzyBykcpMiN5cFu
XqvVYrLOxp5IOqxG8M+KJlVlEpf08tcWPUVsIIMRy+g11okFVqmS6h/I3RWciq/X
1EoKu7BkMtsKOncBhjuloLOqDyl7PViZnEW44pDFzVPR9ZAQ6z8aOQPNeUqckpd3
GgX+ZiSdihNkkzH5g63oTgqKgd4v/fi7rTgB5uxavrv4IwPnrRiZLNVtPjf+5oG+
DpFNUgamNP9X5ZPd/Md94Q0ZXXjtzCa8QKD2QM6+zYodvCbguSXJdTgHkCwiGbe/
DAjgAcd0ccvcxW86k0MxY1q4KNWJUELNcI6Fg9IDP+cLqsNyrsc7o53Jng92QHOA
ehGjTZ37MsNoPyVFRIpPwI/Fglp0guufCZyZcE7XJjbi4add0hfezBpcPSx0AJC4
aMnfIM48MiMobqdPr9CDl7dsuEfslEg76cDijKd1Qp+KB1aTa+rBnf+bYhVpr3uN
/L0DE+oq6wyIOkTAQHrQ8nx+KcoVSgEpzMV6ibKky2/H4MvkC/PoF/q8DKHA3ybI
WKjIRSt6fM6+nYPxfuHuOoZTUuL2Ql6ZC9yPmkGfITYUX1+HskzjPdnVq/1fDAGe
1cneuCzaOS53a9f9ECEu
=1HG3
-----END PGP SIGNATURE-----

--FEz7ebHBGB6b2e8X--
