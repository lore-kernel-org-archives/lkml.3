Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaEESYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:24:53 -0400
Received: from mail-yk0-f180.google.com ([209.85.160.180]:39510 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaEESYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:24:50 -0400
Message-ID: <5367D76A.2040206@monstr.eu>
Date: Mon, 05 May 2014 20:24:42 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Korsgaard <peter@korsgaard.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, arnd@arndb.de,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] tty: serial: uartlite: Specify time for sending chars
References: <4c1854686987185d547d1d548f89248cb27ba40c.1399301297.git.michal.simek@xilinx.com> <874n14i7yn.fsf@dell.be.48ers.dk>
In-Reply-To: <874n14i7yn.fsf@dell.be.48ers.dk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="JXTHC618oJifMOQx5ANJBIfQqVSQdi8xV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JXTHC618oJifMOQx5ANJBIfQqVSQdi8xV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/05/2014 05:03 PM, Peter Korsgaard wrote:
>>>>>> "Michal" =3D=3D Michal Simek <michal.simek@xilinx.com> writes:
>=20
>  > Xilinx MDM (Microblaze Debug Module) also contains
>  > uart interface via JTAG which is compatible with
>  > uartlite driver. This interface is really slow
>  > that's why timeout is setup to 1s.
>=20
>  > Make this time delay not to be cpu speed dependent.
>=20
>  > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>  > ---
>=20
>  > RFC sent here:
>  > https://lkml.org/lkml/2013/9/30/250
>  > I finally got HW design which is just slow to be able
>  > to test it.
>=20
>  > ---
>  >  drivers/tty/serial/uartlite.c | 10 ++++++++--
>  >  1 file changed, 8 insertions(+), 2 deletions(-)
>=20
>  > diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uart=
lite.c
>  > index 5f90ef24d475..723a6b79cd14 100644
>  > --- a/drivers/tty/serial/uartlite.c
>  > +++ b/drivers/tty/serial/uartlite.c
>  > @@ -418,14 +418,20 @@ static struct uart_ops ulite_ops =3D {
>  >  #ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
>  >  static void ulite_console_wait_tx(struct uart_port *port)
>  >  {
>  > -	int i;
>  >  	u8 val;
>  > +	unsigned long timeout;
>=20
>  >  	/* Spin waiting for TX fifo to have space available */
>  > -	for (i =3D 0; i < 100000; i++) {
>=20
> It would be good to add a note about the slow jtag variant here.

What exactly you would like to see here?
Just that this 1s is here because of mdm uart.

You can find out commit ID via git blame and description
is in commit message.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--JXTHC618oJifMOQx5ANJBIfQqVSQdi8xV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNn12oACgkQykllyylKDCEChACeLDGA7GzzK1lgwSFmnTf+WzsP
cDwAmwdg+0c4qbA5Q7g8wDY0x8hXybf7
=h//m
-----END PGP SIGNATURE-----

--JXTHC618oJifMOQx5ANJBIfQqVSQdi8xV--
