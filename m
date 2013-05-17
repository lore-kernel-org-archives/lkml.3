Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab3EQMJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 08:09:50 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36077 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab3EQMJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 08:09:48 -0400
Message-ID: <51961E02.9020501@monstr.eu>
Date: Fri, 17 May 2013 14:09:38 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <joshc@eso.teric.us>,
        Mike Turquette <mturquette@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 1/5] tty: xuartps: Remove suspend/resume functions
References: <1368467199-8702-1-git-send-email-soren.brinkmann@xilinx.com> <1368467199-8702-2-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1368467199-8702-2-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2PCWAEBDEBAMGCOJONILT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2PCWAEBDEBAMGCOJONILT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Greg,

can you please add this patch to your tree?
It is unrelated to clk changes which Soren sent.

Thanks,
Michal

On 05/13/2013 07:46 PM, Soren Brinkmann wrote:
> Currently Zynq does not support suspend/resume.
> The driver callbacks are never used or tested, broken and using the old=

> PM interface.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: linux-serial@vger.kernel.org
> ---
>  drivers/tty/serial/xilinx_uartps.c | 30 ------------------------------=

>  1 file changed, 30 deletions(-)
>=20
> diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xi=
linx_uartps.c
> index 4e5c778..b5f655d 100644
> --- a/drivers/tty/serial/xilinx_uartps.c
> +++ b/drivers/tty/serial/xilinx_uartps.c
> @@ -1006,34 +1006,6 @@ static int xuartps_remove(struct platform_device=
 *pdev)
>  	return rc;
>  }
> =20
> -/**
> - * xuartps_suspend - suspend event
> - * @pdev: Pointer to the platform device structure
> - * @state: State of the device
> - *
> - * Returns 0
> - **/
> -static int xuartps_suspend(struct platform_device *pdev, pm_message_t =
state)
> -{
> -	/* Call the API provided in serial_core.c file which handles
> -	 * the suspend.
> -	 */
> -	uart_suspend_port(&xuartps_uart_driver, &xuartps_port[pdev->id]);
> -	return 0;
> -}
> -
> -/**
> - * xuartps_resume - Resume after a previous suspend
> - * @pdev: Pointer to the platform device structure
> - *
> - * Returns 0
> - **/
> -static int xuartps_resume(struct platform_device *pdev)
> -{
> -	uart_resume_port(&xuartps_uart_driver, &xuartps_port[pdev->id]);
> -	return 0;
> -}
> -
>  /* Match table for of_platform binding */
>  static struct of_device_id xuartps_of_match[] =3D {
>  	{ .compatible =3D "xlnx,xuartps", },
> @@ -1044,8 +1016,6 @@ MODULE_DEVICE_TABLE(of, xuartps_of_match);
>  static struct platform_driver xuartps_platform_driver =3D {
>  	.probe   =3D xuartps_probe,		/* Probe method */
>  	.remove  =3D xuartps_remove,		/* Detach method */
> -	.suspend =3D xuartps_suspend,		/* Suspend */
> -	.resume  =3D xuartps_resume,		/* Resume after a suspend */
>  	.driver  =3D {
>  		.owner =3D THIS_MODULE,
>  		.name =3D XUARTPS_NAME,		/* Driver name */
>=20


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2PCWAEBDEBAMGCOJONILT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGWHgIACgkQykllyylKDCF8DwCgm6sCltNDqIZorML3DDFvf7sS
hzkAnRfDYy2Lvon7tnPNDFhneKk9jO0W
=sjsH
-----END PGP SIGNATURE-----

------enig2PCWAEBDEBAMGCOJONILT--
