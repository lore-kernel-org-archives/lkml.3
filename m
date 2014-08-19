Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaHSS6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:58:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57713 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbaHSS5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:57:50 -0400
Date: Tue, 19 Aug 2014 13:57:02 -0500
From: Felipe Balbi <balbi@ti.com>
To: Frans Klaver <frans.klaver@xsens.com>
CC: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Pelykh <alexey.pelykh@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        Frans Klaver <fransklaver@gmail.com>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/4] tty: omap-serial: use threaded interrupt handler
Message-ID: <20140819185701.GC22003@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
 <1408450488-4083-1-git-send-email-frans.klaver@xsens.com>
 <1408450488-4083-4-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
Content-Disposition: inline
In-Reply-To: <1408450488-4083-4-git-send-email-frans.klaver@xsens.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2014 at 02:14:47PM +0200, Frans Klaver wrote:
> At 3.6Mbaud, with slightly over 2Mbit/s data coming in, we see 1600 uart
> rx buffer overflows within 30 seconds. Threading the interrupt handling r=
educes
> this to about 170 overflows in 10 minutes.

Can you try Sebastian Siewior's patches for 8250_omap and 8250 dma
support ? That should help you a lot.

> In practice this therefore reduces the need for hardware flow control,
> meaning the sending side doesn't have to buffer as much either.
>=20
> Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
> ---
>  drivers/tty/serial/omap-serial.c | 31 ++++++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-s=
erial.c
> index 14a0167..57664b9 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -575,6 +575,21 @@ static void serial_omap_rdi(struct uart_omap_port *u=
p, unsigned int lsr)
>  }
> =20
>  /**
> + * serial_omap_fast_irq() - schedule interrupt handling
> + */
> +static irqreturn_t serial_omap_fast_irq(int irq, void *dev_id)
> +{
> +	struct uart_omap_port *up =3D dev_id;
> +	unsigned int iir =3D serial_in(up, UART_IIR);
> +
> +	if (iir & UART_IIR_NO_INT)
> +		return IRQ_NONE;
> +
> +	disable_irq_nosync(up->port.irq);

NAK. Either use IRQF_ONESHOT or actually mask the IRQs at the device's
registers (basically clearing IER).

--=20
balbi

--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT8539AAoJEIaOsuA1yqREubgP/i6HM/lzaIpLIB+pnvyrvQCs
11MLkMLKSa8ORfkapcUr/lCSbZPsvrJwzyMNWTrVF3grSQyPKRpPykJYEkJkrwQ+
BUUqrSt5VlJkgdvhhY1KVoqPLonFUrBKEnPsgmv59tMC9dc+4oPA0ZZD8EIT5vjf
RNh+ZKmi0jrtLLuAkwIPpe4LmglFqKLVEwiIWS2RmuWWnEOGwcGEEa4fzv21EV3b
dexziU0ZhrvoBU6pM5j8U5xsF02iXHcFjfeva87Rwb13bZRSPzVZ56C2k0U+3oT9
p1Vp82yzW089huJKH6//02cWbOevb7r0bs1gJCFVO8T8x+h5jFdbwBb+elaL0xbR
VnTclc3YeyP31nve5JeYUSfMog9zGoa03gz3Yr+M4ChxcuvCvOt71cVG8q5jF/yg
s6AXiBNqUhFFgQr7j3JnybLhI3rigkX7SdwRU/WfjJflS9dwpJimPwPd1v4okIry
OfxPBglxTTMQjPS+LwW2Wkxj/PSvKS5NJ8NOry6FaJT5eOJAysxo1mAT4yvrBjn5
4KhDBiPuXlD0vpu5TFTt6OKNsb2gqNt2qe3EHpDGrqcAfNMLLMwLad1npST++43b
KIobmrTDuivGZNPNZ1qXBZh5T5xZzConhtNzcB4FAQOATp3l/XjjpsiZV4oQonCB
Eto7ADF0v4uStCOhOoyd
=aLFS
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
