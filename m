Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3LPVVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:21:23 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34414 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3LPVVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:21:21 -0500
Date: Mon, 16 Dec 2013 15:20:01 -0600
From: Felipe Balbi <balbi@ti.com>
To: Matt Porter <mporter@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v6 5/9] usb: gadget: s3c-hsotg: use generic
 phy_init()/phy_exit() support
Message-ID: <20131216212001.GD12896@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386953483-21631-1-git-send-email-mporter@linaro.org>
 <1386953483-21631-6-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UoPmpPX/dBe4BELn"
Content-Disposition: inline
In-Reply-To: <1386953483-21631-6-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UoPmpPX/dBe4BELn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2013 at 11:51:19AM -0500, Matt Porter wrote:
> If a generic phy is present, call phy_init()/phy_exit(). This supports
> generic phys that must be soft reset before power on.
>=20
> Signed-off-by: Matt Porter <mporter@linaro.org>
> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/gadget/s3c-hsotg.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsot=
g.c
> index 7c5d8bd..e9683c2 100644
> --- a/drivers/usb/gadget/s3c-hsotg.c
> +++ b/drivers/usb/gadget/s3c-hsotg.c
> @@ -3621,6 +3621,9 @@ static int s3c_hsotg_probe(struct platform_device *=
pdev)
>  		goto err_supplies;
>  	}
> =20
> +	if (hsotg->phy)
> +		phy_init(hsotg->phy);

doesn't build. you need to include <linux/phy/phy.h>

--=20
balbi

--UoPmpPX/dBe4BELn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSr26BAAoJEIaOsuA1yqRESYkP/1LrfZ2asiCFbfXVAgCu7uxS
oGGJ8193TNJ1DForZ4MrtiJiWQd3HGP+qjs1oUwrKepEwVVJtWuibkXvw5yyELXy
blDmS/sXmdI7WC84b2gkLlTJ2FpOiYF2wYpanh/Nla0OJptIFfosPlhA3pVwCa6l
UdVBd0p4/fmj5w9Yr9ZwYEbLC87HGNrx8kksanT9yKwi2NMOC6t+Z1MQ2ZDc/UdP
TBbe5FdS33c3HbpXI/F/c8pjLYBqzKCm/lR1qHNGJcQGd4kpe1vMsIUA/oz95g4v
S5SKOoTVmC05qWyal/r5Lg5pgbMTIrnA2HgKYrHq8PmcTLOQtAX/sR7iz4Q/pE4E
xqnyEE8Y9zMjieA40ZVq6c7Su0f2sdCFBEGNmEWfoi/ajKE2baVTq9PRqidXhVnz
4F2o491FtBhdJACkw6OdCC27G8KCXqtVGpNqAfYlfFgSMIeuBsSuEyTE/vRonFC9
eDtq8FrSaI/bhrFw+enoeQeaZuzCR0Xn9KORkXC8wzghRnuiTuFgKC2Sr1Ql0hwU
iLDrOCI4fmWdZXjy8j1ySdWSD9kN2uGO5QBviinPPv171fJ9t+16TIf6F+MVI380
57V+aOCRX9RlTxDZypQU73bV6HqWxMav1Jil5epzmA1qSAo610GhO80OErDmAKzq
3ZvpJG8fNTWwL8lDyotX
=6Zsf
-----END PGP SIGNATURE-----

--UoPmpPX/dBe4BELn--
