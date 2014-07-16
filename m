Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934527AbaGPPQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:16:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55985 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934419AbaGPPQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:16:46 -0400
Date: Wed, 16 Jul 2014 10:16:04 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 4/5] tty: serial: 8250 core: add runtime pm
Message-ID: <20140716151604.GG1365@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de>
 <1405521903-5877-5-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Zw+/jwnNHcBRYYu"
Content-Disposition: inline
In-Reply-To: <1405521903-5877-5-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/Zw+/jwnNHcBRYYu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 16, 2014 at 04:45:02PM +0200, Sebastian Andrzej Siewior wrote:
> @@ -1280,6 +1285,7 @@ static void serial8250_stop_tx(struct uart_port *po=
rt)
>  	struct uart_8250_port *up =3D
>  		container_of(port, struct uart_8250_port, port);
> =20
> +	pm_runtime_get_sync(port->dev);
>  	__stop_tx(up);
> =20
>  	/*
> @@ -1289,6 +1295,8 @@ static void serial8250_stop_tx(struct uart_port *po=
rt)
>  		up->acr |=3D UART_ACR_TXDIS;
>  		serial_icr_write(up, UART_ACR, up->acr);
>  	}
> +	pm_runtime_mark_last_busy(port->dev);
> +	pm_runtime_put_autosuspend(port->dev);
>  }
> =20
>  static void serial8250_start_tx(struct uart_port *port)
> @@ -1296,8 +1304,9 @@ static void serial8250_start_tx(struct uart_port *p=
ort)
>  	struct uart_8250_port *up =3D
>  		container_of(port, struct uart_8250_port, port);
> =20
> +	pm_runtime_get_sync(port->dev);
>  	if (up->dma && !serial8250_tx_dma(up)) {
> -		return;
> +		goto out;
>  	} else if (!(up->ier & UART_IER_THRI)) {
>  		up->ier |=3D UART_IER_THRI;
>  		serial_port_out(port, UART_IER, up->ier);
> @@ -1318,6 +1327,9 @@ static void serial8250_start_tx(struct uart_port *p=
ort)
>  		up->acr &=3D ~UART_ACR_TXDIS;
>  		serial_icr_write(up, UART_ACR, up->acr);
>  	}
> +out:
> +	pm_runtime_mark_last_busy(port->dev);
> +	pm_runtime_put_autosuspend(port->dev);

I wonder if you should get_sync() on start_tx() and only
put_autosuspend() at stop_tx(). I guess the outcome would be largely the
same, no ?

well, other than in probe and other functions which need to make sure
clocks are on, but it seems unnecessary to enable/disable in every
function.

--=20
balbi

--/Zw+/jwnNHcBRYYu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxpc0AAoJEIaOsuA1yqREf6EP/RarlB1fjSzBBmlZ0sdMbB5E
aSv+G7oGrWL0XV+9cbaw4Gf3lkv21agRLup+v4CSmpKWGawEsjrQKKfT/+GuZUbO
IqNT6pvyafj3Z0SQI82LYPtesK4nxKIDyiAe+sj8zhH0CeLLcLPX7dt91it35npw
hV68WxDzdmqb4rH2MYSoGCKaw2CJ7QfpqdybOtUsDgoqnnp2RnjpgNNG2MIg3j0n
xGGeDMzJh8mU/r/GJrDblIStJjvXe49klhSEdjD3R9re2gTrekNc0xRBv+aHAx3w
OCGIfKIvaVOgwGW9CTemaJtzSA9ByirXOOinW0XtjoLDKUs5kciYj9zddyxyowDZ
bi2GfGOY+jWjMkqzWu8ItjQA4qvFajcZomrfnlYTzusE9IhvEFpYzzLiQyupOjt4
cJ/Hqggvv613aqah7pg5qCBq4lmK0AN8Ga04bAMmjMBSjhf8awuTgqFuBQcDpYv2
9gtRh6W+OyHwsjLKzm+Y1d/0n7fteIYsEf70tRbVff6rIDAfzU1kK5xK2nJYaIqS
OiyxY17mtAP4SbS83lnTnMu3gyTEe2Hh7Fx0LVVNLG/RJ+KkVMZfgQSdnxg3fXku
wOGfRuUsD28sKxeKIXHhoW+7PGE/VJcr9XXhQjgHvUtQ2/gGjkoKYauLDrI2eWZO
tB3OCR3jLWuHhz0GpZxH
=SOgw
-----END PGP SIGNATURE-----

--/Zw+/jwnNHcBRYYu--
