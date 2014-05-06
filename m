Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985AbaEFEs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 00:48:58 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:33374 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933966AbaEFEs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 00:48:56 -0400
Message-ID: <536869B4.3070506@monstr.eu>
Date: Tue, 06 May 2014 06:48:52 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Korsgaard <peter@korsgaard.com>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, arnd@arndb.de,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] tty: serial: uartlite: Specify time for sending chars
References: <4c1854686987185d547d1d548f89248cb27ba40c.1399301297.git.michal.simek@xilinx.com>	<874n14i7yn.fsf@dell.be.48ers.dk> <5367D76A.2040206@monstr.eu> <87wqe0gggo.fsf@dell.be.48ers.dk>
In-Reply-To: <87wqe0gggo.fsf@dell.be.48ers.dk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="XjwSSeITTP7jUWG2ocG20HqJxRtOHGc30"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XjwSSeITTP7jUWG2ocG20HqJxRtOHGc30
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/05/2014 09:42 PM, Peter Korsgaard wrote:
>>>>>> "Michal" =3D=3D Michal Simek <monstr@monstr.eu> writes:
>=20
> Hi,
>=20
>  >> > diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/u=
artlite.c
>  >> > index 5f90ef24d475..723a6b79cd14 100644
>  >> > --- a/drivers/tty/serial/uartlite.c
>  >> > +++ b/drivers/tty/serial/uartlite.c
>  >> > @@ -418,14 +418,20 @@ static struct uart_ops ulite_ops =3D {
>  >> >  #ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
>  >> >  static void ulite_console_wait_tx(struct uart_port *port)
>  >> >  {
>  >> > -	int i;
>  >> >  	u8 val;
>  >> > +	unsigned long timeout;
>  >>=20
>  >> >  	/* Spin waiting for TX fifo to have space available */
>  >> > -	for (i =3D 0; i < 100000; i++) {
>  >>=20
>  >> It would be good to add a note about the slow jtag variant here.
>=20
>  > What exactly you would like to see here?
>  > Just that this 1s is here because of mdm uart.
>=20
> Something like:
>=20
>  /*
>   * Spin waiting for TX fifo to have space available.
>   * When using the Microblaze Debug Module this can take up to 1s
>   */

up to you. You are driver owner. :-)
I have sent v2 with this change and I have added your ACK.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--XjwSSeITTP7jUWG2ocG20HqJxRtOHGc30
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNoabQACgkQykllyylKDCH7awCcCn3BY65V9bCn+tvq+0eaXYgl
X8QAoI3FkjfoWNw2IJfz47ShrmQpaDaj
=nDDA
-----END PGP SIGNATURE-----

--XjwSSeITTP7jUWG2ocG20HqJxRtOHGc30--
