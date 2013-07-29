Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab3G2MY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:24:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55983 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3G2MYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:24:23 -0400
Date: Mon, 29 Jul 2013 15:23:44 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/6] usb: phy: msm: Move mach depndend code to
 platform data
Message-ID: <20130729122344.GH24801@radagast>
Reply-To: <balbi@ti.com>
References: <1375081464-14206-1-git-send-email-iivanov@mm-sol.com>
 <1375081464-14206-2-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l06SQqiZYCi8rTKz"
Content-Disposition: inline
In-Reply-To: <1375081464-14206-2-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--l06SQqiZYCi8rTKz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 29, 2013 at 10:04:19AM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> This patch fix compilation error and is an intermediate step
> before the addition of DeviceTree support for newer targets.
> Fix suggested here: https://lkml.org/lkml/2013/6/19/381
>=20
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Cc: Bryan Huntsman <bryanh@codeaurora.org>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  arch/arm/mach-msm/board-msm7x30.c |   35 +++++++++++++++++++++++
>  arch/arm/mach-msm/board-qsd8x50.c |   35 +++++++++++++++++++++++

I need acks for these.

>  drivers/usb/phy/phy-msm-usb.c     |   55 ++++++++++---------------------=
------
>  include/linux/usb/msm_hsusb.h     |    3 ++
>  4 files changed, 87 insertions(+), 41 deletions(-)
>=20
> diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-=
msm7x30.c
> index db3d8c0..6b35953 100644
> --- a/arch/arm/mach-msm/board-msm7x30.c
> +++ b/arch/arm/mach-msm/board-msm7x30.c
> @@ -31,6 +31,7 @@
>  #include <asm/setup.h>
> =20
>  #include <mach/board.h>
> +#include <mach/clk.h>
>  #include <mach/msm_iomap.h>
>  #include <mach/dma.h>
> =20
> @@ -61,10 +62,44 @@ static int hsusb_phy_init_seq[] =3D {
>  	-1
>  };
> =20
> +static int hsusb_link_clk_reset(struct clk *link_clk, bool assert)

looks like you should be using the reset controller framework ?
(drivers/reset)

--=20
balbi

--l06SQqiZYCi8rTKz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9l7QAAoJEIaOsuA1yqREoaYQAIRYjbRt7nIiOvekSi29x+0s
vjEBt1JlLX3UjLYLCQP9uDcVtd4un1BU8b7IXDw3HGO3R34Pcipi13XfnrofZLfA
GrhutU+6XgyfC/fUM2uxXsZiEHMOTdc0OQGJMqTFcczYlFigHIoFC0cCFUYkz6iV
kZSp7DGBqBfjtRnEw/1107zhERGgvOwffVG+vyQmkxrNEncFBxoXxtlNVuXvhgFO
mxkDnR475HpwprUGo/l6VnL2Phbvio7yNvA7O1gx9mQRuyFonhnYby4iu/LQU5Js
S8DDz0j1FL8oKlTJMXqfeXkz2YguNechgZphmyitWUm/1+qZEduoLv939/QrhLTe
WwpfNareQ6S3Lo+F1SrDGVbfsBeg9E+xVMfx6G1iWFGnAC0zZunJivRKGRRdaLZB
6Gj70+o7Ko8tlGSiJqSNmIcPZRr0/37SqgArk4ttXIL+T5At2NCRsWpcqviJulln
L/+4rW79R0ltqnlmYNN2qEza19cZMq3pxr4iuTFAILSNMqpTbeFwKiHNKwMcLii5
wFPtsG3qpQTW7SvIVObf8dCeD8wXzpv8eOBbUs6c4jLcFkoHs2q9eat4iN4cOOcl
RS5m5CI0GqhYOhNJsJKrXG151ZcEr9LuRaZ5ginpdiBDfwaaYZD17CPeZ7gUPQ3z
r46d3CQlRe4Uh4bMc4nI
=1Mzm
-----END PGP SIGNATURE-----

--l06SQqiZYCi8rTKz--
