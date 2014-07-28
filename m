Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaG1Q3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:29:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38029 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaG1Q3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:29:06 -0400
Message-ID: <53D67A46.3060202@pengutronix.de>
Date: Mon, 28 Jul 2014 18:28:54 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] can: flexcan: add vf610 support for FlexCAN
References: <cover.1405428166.git.stefan@agner.ch> <ff2ea1726b13dc2ffa3519ce9244f3633cf1420d.1405428166.git.stefan@agner.ch> <53C5398F.2000005@pengutronix.de> <1b8a8ca03b4a160027a79b722f697e25@agner.ch> <601adb6fe47279c115c1cc607365a00e@agner.ch> <53D25C9D.5080803@pengutronix.de> <e88108c655e2c16dc9cf6c4194547e73@agner.ch>
In-Reply-To: <e88108c655e2c16dc9cf6c4194547e73@agner.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="kjR5hcMBOvJh7uMJHS293nKT2CfkwMwDF"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kjR5hcMBOvJh7uMJHS293nKT2CfkwMwDF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/28/2014 06:20 PM, Stefan Agner wrote:
>>> Ping. Anything open/to do from my side?
>>
>> Please keep the printing of esr and ctrl in the interrupt handler, add=
 a
>> #define DEBUG in the driver, but do not change anything else. Then:
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index 1c31a5d..fe8b81c 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -19,6 +19,7 @@
>   *
>   */
> =20
> +#define DEBUG

keep

>  #include <linux/netdevice.h>
>  #include <linux/can.h>
>  #include <linux/can/dev.h>
> @@ -743,6 +744,9 @@ static irqreturn_t flexcan_irq(int irq, void
> *dev_id)
> =20
>         reg_iflag1 =3D flexcan_read(&regs->iflag1);
>         reg_esr =3D flexcan_read(&regs->esr);
> +
> +       printk("flexcan_irq, esr=3D%08x\n", reg_esr);
> +       printk("flexcan_irq, ctrl=3D%08x\n", flexcan_read(&regs->ctrl))=
;

keep

>         /* ACK all bus error and state change IRQ sources */
>         if (reg_esr & FLEXCAN_ESR_ALL_INT)
>                 flexcan_write(reg_esr & FLEXCAN_ESR_ALL_INT,
> &regs->esr);
> @@ -885,8 +889,8 @@ static int flexcan_chip_start(struct net_device
> *dev)
>          */
>         reg_ctrl =3D flexcan_read(&regs->ctrl);
>         reg_ctrl &=3D ~FLEXCAN_CTRL_TSYN;
> -       reg_ctrl |=3D FLEXCAN_CTRL_BOFF_REC | FLEXCAN_CTRL_LBUF |
> -               FLEXCAN_CTRL_ERR_STATE;
> +       reg_ctrl |=3D FLEXCAN_CTRL_BOFF_REC | FLEXCAN_CTRL_LBUF;// |
> +               //FLEXCAN_CTRL_ERR_STATE;
>         /*
>          * enable the "error interrupt" (FLEXCAN_CTRL_ERR_MSK),
>          * on most Flexcan cores, too. Otherwise we don't get
>=20
> I'm not sure whether you really want to keep the FLEXCAN_CTRL_ERR_STATE=

> commented out...

No, please remove this change and redo the test.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--kjR5hcMBOvJh7uMJHS293nKT2CfkwMwDF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlPWekYACgkQjTAFq1RaXHORHQCeJ66SexKyx/sf93Tw7S36duFU
2eQAoI4XSdVZz4DzKhhEJcAQzex/i8xA
=gkZx
-----END PGP SIGNATURE-----

--kjR5hcMBOvJh7uMJHS293nKT2CfkwMwDF--
