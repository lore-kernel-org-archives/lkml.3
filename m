Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551AbaCTRbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:31:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42471 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbaCTRbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:31:14 -0400
Date: Thu, 20 Mar 2014 12:29:20 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Alan Cox <alan@linux.intel.com>, Marcel Holtmann <marcel@holtmann.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Muralidharan Karicheri <m-karicheri2@ti.com>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hci_ldsic nested locking problem
Message-ID: <20140320172920.GC2827@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140320163435.GH32692@saruman.home>
 <1395333736.22077.32.camel@acox1-desk.ger.corp.intel.com>
 <20140320171621.GA2827@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Content-Disposition: inline
In-Reply-To: <20140320171621.GA2827@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2014 at 12:16:22PM -0500, Felipe Balbi wrote:
> On Thu, Mar 20, 2014 at 04:42:16PM +0000, Alan Cox wrote:
> > On Thu, 2014-03-20 at 11:34 -0500, Felipe Balbi wrote:
> > > Hi,
> > >=20
> > > when 8250 driver calls uart_write_wakeup(), the tty port lock is alre=
ady
> > > taken. hci_ldisc.c's implementation of ->write_wakeup() calls
> > > tty->ops->write() to actually send the characters, but that call will
> > > try to acquire the same port lock again.
> > >=20
> > > Looking at other line disciplines that looks like a bug in hci_ldisc.=
c.
> > > Am I correct to assume that ->write_wakeup() is supposed to *just*
> > > wakeup the bottom half so we handle ->write() in another context ?
> > >=20
> > > Is it legal to call tty->ops->write() from within ->write_wakeup() ?
> >=20
> > It isn't because you might send all the bytes and go
> >=20
> > 	write
> > 		write_wakeup
> > 			write
> > 				write wakeup
> > 					...
> >=20
> > and recurse

then we need updates to Documentation:

Documentation/serial/tty.txt::

|  Driver Side Interfaces:
| =20
|  receive_buf()	-	Hand buffers of bytes from the driver to the ldisc
|  			for processing. Semantics currently rather
|  			mysterious 8(
| =20
|  write_wakeup()	-	May be called at any point between open and close.
|  			The TTY_DO_WRITE_WAKEUP flag indicates if a call
|  			is needed but always races versus calls. Thus the
|  			ldisc must be careful about setting order and to
|  			handle unexpected calls. Must not sleep.
| =20
|  			The driver is forbidden from calling this directly
|  			from the ->write call from the ldisc as the ldisc
|  			is permitted to call the driver write method from
|  			this function. In such a situation defer it.

documentation says ldisc is allowed to call ->write() from
->write_wakeup(). huh ?

--=20
balbi

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTKyVwAAoJEIaOsuA1yqRExOwP/jhhHuX63jO1qddruUaicFq2
TYiRqcMD/Kl6E9vzVptmgw14UU0O5HqBT72rzM7qgQo5e2ik7t7mW04fkx730vZO
JKdliyP19PLfTKvDS71YLugrnrb2DszH7FpS3zLVxP2OHB6H2huVctblnOZlCRdL
iIKuRc5B2QUL43B58czi5hZjVhows9v/s47CJjKQ3sG7+xnOI1FgKOXAx0oVyykV
7LGQ5h6af90RZWmbT2oN1BxRoSeyiEvJBkxjidNxrCYBrLHwq2NSC7fD77059lfL
9XudWBUEMuiROedLO1K7iuwqJMooSoe+aPUpouLwO34PTa5CHtNFgW+rmRRLNkgu
xBn+T3ouJfemDynYxoUbGq+qAHr7mvhJFyYcvqWVyJOROQME3Oe+3w8cR+CoJGvz
ed0ica7QUXQuZRBoG4waRUrk0STNddQ4wIFfU0NwasiijTcoUL86bFIcF0cANeJu
yuGLMP11/wXyxveB4VPCPXTUQzN6OzEkk69BbLDd+TKC/mwGtdO6yHGNqnQX647L
z82EvaQDaoHSUGKVJV7J6bN4ubZRTEeQtp6jbn4iXku2BoOBqQnLIZJgMF+MV30a
zC7JWlQiGc8F0OcPsaaOc8e/Oc0Jz0KzHIAtgGNReKOz33TKkqlPOXFewE3K8CAR
uvLxR5Tz3nrTtTeI5MJl
=ETut
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
