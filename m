Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbaIQNpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:45:06 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39314 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbaIQNpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:45:03 -0400
Message-ID: <5419905A.6030701@monstr.eu>
Date: Wed, 17 Sep 2014 15:44:58 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] serial: cadence: Add generic earlycon support
References: <58f2c9cf267e64f5d7566920844fb2db251e77d2.1410345777.git.michal.simek@xilinx.com>
In-Reply-To: <58f2c9cf267e64f5d7566920844fb2db251e77d2.1410345777.git.michal.simek@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Uf5a96rq6F5SP4cWlaUipMVShO9Jg8TQ6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Uf5a96rq6F5SP4cWlaUipMVShO9Jg8TQ6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On 09/10/2014 12:43 PM, Michal Simek wrote:
> Add earlycon support for the cadence serial port.
> This is based on recent patches:
> "tty/serial: pl011: add generic earlycon support"
> (sha1: 0d3c673e7881e691991b2a4745bd4f149603baa2)
> "tty/serial: add arm/arm64 semihosting earlycon"
> (sha1: d50d7269ebcb438afa346cdffce0f4e2a1b9e831)
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>=20
>  Documentation/kernel-parameters.txt |  6 ++++++
>  drivers/tty/serial/Kconfig          |  1 +
>  drivers/tty/serial/xilinx_uartps.c  | 19 +++++++++++++++++++
>  3 files changed, 26 insertions(+)
>=20
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel=
-parameters.txt
> index a8eb6afce6a4..97055dc43167 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -921,6 +921,12 @@ bytes respectively. Such letter suffixes can also =
be entirely omitted.
>=20
>  	earlycon=3D	[KNL] Output early console device and options.
>=20
> +		cdns,<addr>
> +			Start an early, polled-mode console on a cadence serial
> +			port at the specified address. The cadence serial port
> +			must already be setup and configured. Options are not
> +			yet supported.
> +
>  		uart[8250],io,<addr>[,options]
>  		uart[8250],mmio,<addr>[,options]
>  		uart[8250],mmio32,<addr>[,options]
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index b4d61e6bf28c..72fd2b6e2241 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -1411,6 +1411,7 @@ config SERIAL_XILINX_PS_UART_CONSOLE
>  	bool "Cadence UART console support"
>  	depends on SERIAL_XILINX_PS_UART=3Dy
>  	select SERIAL_CORE_CONSOLE
> +	select SERIAL_EARLYCON
>  	help
>  	  Enable a Cadence UART port to be the system console.
>=20
> diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xi=
linx_uartps.c
> index 01951d27cc03..675f3fe068f6 100644
> --- a/drivers/tty/serial/xilinx_uartps.c
> +++ b/drivers/tty/serial/xilinx_uartps.c
> @@ -1051,6 +1051,25 @@ static void cdns_uart_console_putchar(struct uar=
t_port *port, int ch)
>  	cdns_uart_writel(ch, CDNS_UART_FIFO_OFFSET);
>  }
>=20
> +static void cdns_early_write(struct console *con, const char *s, unsig=
ned n)
> +{
> +	struct earlycon_device *dev =3D con->data;
> +
> +	uart_console_write(&dev->port, s, n, cdns_uart_console_putchar);
> +}
> +
> +static int __init cdns_early_console_setup(struct earlycon_device *dev=
ice,
> +					   const char *opt)
> +{
> +	if (!device->port.membase)
> +		return -ENODEV;
> +
> +	device->con->write =3D cdns_early_write;
> +
> +	return 0;
> +}
> +EARLYCON_DECLARE(cdns, cdns_early_console_setup);
> +
>  /**
>   * cdns_uart_console_write - perform write operation
>   * @co: Console handle
> --
> 1.8.2.3
>=20

Any problem with this patch?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--Uf5a96rq6F5SP4cWlaUipMVShO9Jg8TQ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQZkFoACgkQykllyylKDCHkPgCfZzCnTIgttAVcwrJ4XaahGWHR
ACgAnjav9NOj0zfW+pUsQQC4G6iYtr54
=KFyU
-----END PGP SIGNATURE-----

--Uf5a96rq6F5SP4cWlaUipMVShO9Jg8TQ6--
