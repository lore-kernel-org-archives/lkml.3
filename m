Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaCJMKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:10:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48618 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752090AbaCJMKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:10:03 -0400
Date: Mon, 10 Mar 2014 13:05:58 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "zhuzhenhua@allwinnertech.com" <zhuzhenhua@allwinnertech.com>
Subject: Re: [PATCH v3 6/7] DMA: sun6i: Add driver for the Allwinner A31 DMA
 controller
Message-ID: <20140310120558.GF2815@lukather>
References: <1393949884-892-1-git-send-email-maxime.ripard@free-electrons.com>
 <1393949884-892-7-git-send-email-maxime.ripard@free-electrons.com>
 <1394028474.28803.172.camel@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JcvBIhDvR6w3jUPA"
Content-Disposition: inline
In-Reply-To: <1394028474.28803.172.camel@smile.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JcvBIhDvR6w3jUPA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andriy,

On Wed, Mar 05, 2014 at 02:07:55PM +0000, Shevchenko, Andriy wrote:
> > +		return PTR_ERR(pll6);
> > +	}
> > +
> > +	ret =3D clk_set_parent(mux, pll6);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Couldn't reparent AHB1 on PLL6\n");
> > +		return ret;
> > +	}
> > +
> > +	devm_clk_put(&pdev->dev, mux);
> > +	devm_clk_put(&pdev->dev, pll6);
>=20
> Since you put those here, would it be better to use plain
> clk_get/clk_put ?

Actually, this allows to have no exit path for the case where one of
the calls between the first clk_get, and here. devm_clk_* makes error
handling much easier here, that's just all

I'll fix the other comments you had, and send a new version.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--JcvBIhDvR6w3jUPA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTHaqlAAoJEBx+YmzsjxAgUrsP/R3AjphaZbpaJGAQua0RghUQ
U2khP8K6Z6dHvkUumqAh43mnrDydDxbVzLqSdCkg9FGoq1jjp5rLPORutCtC/Ybz
l8eHUi2aiaL5shT48XlJ/hKLaicrl6ZSPG0uOEsHqZtaaSFc3bK6RWSRozLmhiWz
DyToIg0xh4xetWGWaw2pZKeGZdnuUSurfMh4Bk9ZoQunxtZn7o61vs6RZ0kpaoH2
QIPmufn+TMuuVzTQY7yyx0nwp1vGH9am6AZRr52SDqvHVfzcnXiJF6W1N+6rh7OP
3Ag+YnxYZKXe+2LLEzbaPh6JzqgmYfuChYJ9zuIgcJZyuoKw0YvG2XgDO/KTjguG
Q/ZPX+mOAHlfc5+eT4BaiJ1457wXZ95jpcN3mhnrAswIkzMKwcNKdBrHtAuCaEFv
AwPR1bNZP1KYCFxW6O3mQl9/UmQJhXITzvBwGmlZN31CebF4eZ9MmgpuNGS0GYeA
+aqAFhm224Wp35+phn5H+Tj42p37jEiN1nCkvXu2tlTjhWq6AnxF1xpyysnWRpAi
MofIDPnaEWsDFZ5fKOiBf5MURz1hjY9uIRpbSiDYIqHuR2T+ukGkLlBrSKkX0Df6
hVCfykbjtiX+vJ3AysnTCewla0H1MIDGS7o7sTaa1kYMINoVEwIFAOPWPZ5m+Jch
AZK/yREPcCqyDr6GVJ4v
=xrpl
-----END PGP SIGNATURE-----

--JcvBIhDvR6w3jUPA--
