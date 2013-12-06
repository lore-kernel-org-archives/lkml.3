Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162726Ab3LFXvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:51:42 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53818 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161351Ab3LFXvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:51:38 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Tim Kryger <tim.kryger@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] serial: 8250_dw: Improve unwritable LCR workaround
Date: Fri, 06 Dec 2013 23:51:25 +0000
Message-ID: <5548535.pYirbknue4@radagast>
Organization: Imagination Technologies
User-Agent: KMail/4.10.5 (Linux/3.12.3+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <4548523.McqEijQYrs@radagast>
References: <1380647888-32473-1-git-send-email-tim.kryger@linaro.org> <20131126183559.GA18570@localhost> <4548523.McqEijQYrs@radagast>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2356815.7zO10Rhlyr"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2356815.7zO10Rhlyr
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday 06 December 2013 23:29:02 James Hogan wrote:
> So it looks like the LCR does always change immediately for me in this case
> (obviously it hasn't hit the BUSY case), but not all the bits can be
> written. In particular bit 5 and bit 7 at the least. If I do this (sorry
> for whitespace munging):
> 
> diff --git a/drivers/tty/serial/8250/8250_dw.c
> b/drivers/tty/serial/8250/8250_dw.c
> index 4658e3e..722d448 100644
> --- a/drivers/tty/serial/8250/8250_dw.c
> +++ b/drivers/tty/serial/8250/8250_dw.c
> @@ -96,7 +96,7 @@ static void dw8250_serial_out(struct uart_port *p, int
> offset, int value)
>  	if (offset == UART_LCR) {
>  		int tries = 1000;
>  		while (tries--) {
> -			if (value == p->serial_in(p, UART_LCR))
> +			if (value & ~0xa0 == p->serial_in(p, UART_LCR) & ~0xa0)
>  				return;
>  			dw8250_force_idle(p);
>  			writeb(value, p->membase + (UART_LCR << p->regshift));
> @@ -132,7 +132,7 @@ static void dw8250_serial_out32(struct uart_port *p, int
> offset, int value)
>  	if (offset == UART_LCR) {
>  		int tries = 1000;
>  		while (tries--) {
> -			if (value == p->serial_in(p, UART_LCR))
> +			if (value & ~0xa0 == p->serial_in(p, UART_LCR) & ~0xa0)

My appologies, that should have had some more brackets (I should have retested 
after cleaning up my debugging). I.e.
+			if ((value & ~0xa0) == (p->serial_in(p, UART_LCR) & ~0xa0))

Cheers
James
--nextPart2356815.7zO10Rhlyr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJSomMGAAoJEKHZs+irPybfyP8P/RVAD9zcYl7GNQ+m4KaaAvr7
vtJTXfWZmDAag4C/kexA3M402zKuhpMyH0aUxwH40glPN8JexdC6C8DCmZFwNS1e
DStQwyXm+DolXu8V/Cwm4naQ/YE1mmas/2CavS9fF3eAMk1JhBP8L+0GZFH/My44
zDsf5oeJeBmIfTg1znUgHQBNm07ATr2WUGah3xqnjDCvuG1k4p86H2xWpgab4MUw
bkwQJyJ/sLoyatpFPqHTDe9F+T9iFOCF7S0KARbiiRkVxTeSFXVRVaOJI9fHqg9C
bLbUcCl4FlE+0J3+bm3/i530bGFYcOizm0N7DI6U1Sl3cTAhpcu3XBWmaxPQnJPZ
mDevhXwv6IdMfLXBIDk2vC4ADw8tSzAocpg52eMvxwuVmTDFt77PvezWz3eRgX2U
JG2X/K9QbDUSI257I+3TE76+FfpPCsjX/+f7yKSwI+jBLM6s6FDfMUDwjgvQlBjX
scLtIwcM+tfOsD4OPoYoJO6MxCj8/GeN47EUh/V3lMWq0+ZXkWVDcTyNIc8JKL6t
JHkS4zslaYW7ZGu4dln7+9hbfLUIDq5W2b2V0TXh7snZC6PSQgRE83Ps2TGD+GpX
k6RPY9Q1b8x1BE6A339+5ga5G0WDxzNTMz1+NPsHwDzzI8w9dKlyoxfUiUgNHozR
54UQQt4YhZoFsIWOmHKo
=KWH/
-----END PGP SIGNATURE-----

--nextPart2356815.7zO10Rhlyr--

