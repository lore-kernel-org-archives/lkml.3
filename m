Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaHTQGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:06:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58073 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaHTQGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:06:51 -0400
Date: Wed, 20 Aug 2014 11:06:05 -0500
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
Message-ID: <20140820160604.GH24500@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406645577-18620-1-git-send-email-frans.klaver@xsens.com>
 <1408450488-4083-1-git-send-email-frans.klaver@xsens.com>
 <1408450488-4083-4-git-send-email-frans.klaver@xsens.com>
 <20140819185701.GC22003@saruman.home>
 <20140820064028.GC9319@ci00147.xsens-tech.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9sSKoi6Rw660DLir"
Content-Disposition: inline
In-Reply-To: <20140820064028.GC9319@ci00147.xsens-tech.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9sSKoi6Rw660DLir
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 08:40:28AM +0200, Frans Klaver wrote:
> On Tue, Aug 19, 2014 at 01:57:02PM -0500, Felipe Balbi wrote:
> > On Tue, Aug 19, 2014 at 02:14:47PM +0200, Frans Klaver wrote:
> > > At 3.6Mbaud, with slightly over 2Mbit/s data coming in, we see 1600 u=
art
> > > rx buffer overflows within 30 seconds. Threading the interrupt handli=
ng reduces
> > > this to about 170 overflows in 10 minutes.
> >=20
> > Can you try Sebastian Siewior's patches for 8250_omap and 8250 dma
> > support ? That should help you a lot.
>=20
> I'll have a look at that series. Thanks for pointing it out.
>=20
> > >  drivers/tty/serial/omap-serial.c | 31 ++++++++++++++++++++++++-------
> > >  1 file changed, 24 insertions(+), 7 deletions(-)
> > >=20
> > > diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/om=
ap-serial.c
> > > index 14a0167..57664b9 100644
> > > --- a/drivers/tty/serial/omap-serial.c
> > > +++ b/drivers/tty/serial/omap-serial.c
> > > @@ -575,6 +575,21 @@ static void serial_omap_rdi(struct uart_omap_por=
t *up, unsigned int lsr)
> > >  }
> > > =20
> > >  /**
> > > + * serial_omap_fast_irq() - schedule interrupt handling
> > > + */
> > > +static irqreturn_t serial_omap_fast_irq(int irq, void *dev_id)
> > > +{
> > > +	struct uart_omap_port *up =3D dev_id;
> > > +	unsigned int iir =3D serial_in(up, UART_IIR);
> > > +
> > > +	if (iir & UART_IIR_NO_INT)
> > > +		return IRQ_NONE;
> > > +
> > > +	disable_irq_nosync(up->port.irq);
> >=20
> > NAK. Either use IRQF_ONESHOT or actually mask the IRQs at the device's
> > registers (basically clearing IER).
>=20
> Given the work that's been done on the 8250 based driver, what are the
> short-term chances omap-serial will be dropped? I'd be happy to improve
> here if it makes sense to do so. If the 8250 based driver is going to
> replace omap-serial anyway on the short term, I don't see the point of
> further developing this patch. The others would still make sense in my
> opinion.

if we find a way to maintain the same ttyO* naming scheme and make it
coexist with ttyS* naming, then we could drop as soon as 8250_omap is
ready for prime time.

--=20
balbi

--9sSKoi6Rw660DLir
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9MdsAAoJEIaOsuA1yqRE+i0P/jOlXZ6FiDz9F74YSnbjOYBY
I9cIlhoosTWcknyS3AZKMtaU8/zyRbbeVwWNVPQrGyVK9q16LGMoV4YUdaYTeQnN
/0WeviuSoDRBULEiKJEIahIbAtT5+ftMttYhX6MCqXvJvJTUyfOF7RIK4UdQ2NCd
lqWa37dS9KKH0Po4YtL8i9ZcPWyUlrRFI5aw86Oos65BIvcH7F8AAfe24cXRAEMM
QTd67cX5GR1TJCcm+znb0S2X5/PVd3BCleHdTRM9dODzX3xZYGQ/JtoH2ABCBCVb
SW0dPHE49aYz6xcYms2cwe7bzF2axf2sQSROXMJZxKn75qa8E6UaHb9M6Q9DrtC+
f0jwlMmL917gZJGeT5GW4A7Aiq9kyk32spswRyEKgC4wDdFIdzO+Phpc23b6vl9u
zyDEg0M/i8IAcbrK+K+aEvomCxP/dRB0CkcIbcthz4Eon8jUr+AzzbQzkrK0BbFA
pbrJFf9ivAFh9uTLhnAb+551qDXBn1mpW9Ki/nVa0sD4lL53+lIfiufTGo9CNFmo
tH59zqOXAEqZ/SLxAgNXRWnrAibHbUx46LFxD0d0nuA+GWieEjleci911RUgo+mr
L69YQxz2Ldn4xw0EW2Vz3nN53SP3Kci28Uo2nrZzpv8r3nvxGcEICu9Dn/eG8rtb
ufT1mIwqK2s82wyCcbpo
=Dv3x
-----END PGP SIGNATURE-----

--9sSKoi6Rw660DLir--
