Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbbANVPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:15:31 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46310 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbbANVP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:15:29 -0500
Date: Wed, 14 Jan 2015 15:14:34 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Robert Baldyga <r.baldyga@samsung.com>,
        <paulz@synopsys.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dinguyen@opensource.altera.com>, <yousaf.kaukab@intel.com>,
        <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] usb: dwc2: call dwc2_is_controller_alive() under
 spinlock
Message-ID: <20150114211434.GT16533@saruman>
Reply-To: <balbi@ti.com>
References: <20150114193754.GQ16533@saruman>
 <Pine.LNX.4.44L0.1501141504420.1464-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/TDNEY6SkuiyIcFh"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1501141504420.1464-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/TDNEY6SkuiyIcFh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 14, 2015 at 03:06:39PM -0500, Alan Stern wrote:
> > > This patch fixes bug described here:
> > > https://lkml.org/lkml/2014/12/22/185
> > >=20
> > > Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> > > ---
> > >=20
> > > Changelog:
> > >=20
> > > v2:
> > > - fixed comment from Paul Zimmerman
> > >=20
> > > v1: https://lkml.org/lkml/2015/1/13/186
> > >=20
> > >  drivers/usb/dwc2/core_intr.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > >=20
> > > diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_int=
r.c
> > > index ad43c5b..02e3e2d 100644
> > > --- a/drivers/usb/dwc2/core_intr.c
> > > +++ b/drivers/usb/dwc2/core_intr.c
> > > @@ -476,13 +476,13 @@ irqreturn_t dwc2_handle_common_intr(int irq, vo=
id *dev)
> > >  	u32 gintsts;
> > >  	irqreturn_t retval =3D IRQ_NONE;
> > > =20
> > > +	spin_lock(&hsotg->lock);
> > > +
> > >  	if (!dwc2_is_controller_alive(hsotg)) {
> >=20
> > This is really, really odd. Register accesses are atomic, so the lock
> > isn't really doing anything. Besides, you're calling
> > dwc2_is_controller_alive() from within the IRQ handler, so IRQs are
> > already disabled.
>=20
> Spinlocks sometimes do more than you think.  For instance, here the=20
> lock prevents the register access from happening while some other CPU=20
> is holding the lock.  If a silicon quirk causes the register access to=20
> interfere with other activities, this could be important.

readl() (which is used by dwc2_is_controller_alive()) adds a memory
barrier to the register accesses, that should force all register
accesses the be correctly ordered. I fail to see how a silicon quirk
could cause this and if, indeed, it does, I'd be more comfortable with a
proper STARS tickect number from synopsys :-s

Then again, I don't even have a device with this controller and it seems
to only be a problem with Robert's setup, so maybe it's a silicon bug
caused by whoever integrated dwc2 in his silicon.

--=20
balbi

--/TDNEY6SkuiyIcFh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUttw6AAoJEIaOsuA1yqREG3kP/0dTlcG2JyqrcX0ojDXYUjE1
AlhqsxwDR2MIpGPH/XNdU14xP6ObwycjbUyxcyp9IA6t1h7WL8oeyPJ9U4DANFWd
o9G2SpeQxjsdCb+rhvjigVxpXa08xMe2k4+UpkqjfctAGPhIQ2FlGYjhqeS0275Q
lFiH8tg+vx8D8hV19sEjCPzAk+4FvZG0TR5IMT3R7IGPGSsNIZqcNncwKSxOdTZw
KeYedf0DLYIehmh53q1FE7V2c4+DiBWkHxfp9Ffkts4jg97IP/5gXt2CVhpjD2Ml
fJ1L/N5BEdTgA8goGppfjHsIET2XIzKOwLSPZ9/RdcpTE+WJAvFhNZjI0CIqXvHV
DrL/suDXrKb7epZZf+QjSZCPsRCbgitPko9nFupWepn60WEwZGUUTY4u0F7yhY8E
YIUmtUvMjKAp+okrqJ3T2RFDZSJSDpCi1lXNkbQ2mz/F6VXLEGTn7D5vFKy2Nstu
8u+/J81TYebKkoMzVpouuj37j0BCzZ8cbPstEQftsfLjsEnbVO/u0eTFF+LHxB38
rjQ0qLFImfzq2WUONWCNuVZ8JUeiLUvKDtB23xfZGjWOctjG0Z3+oYvyh5kHlNL5
4HxuT9m5fQA3MXUpDHsySb4M35ZFEXOXSb6zqxHgURHl0AOrkcslgkbnC8JFqJb4
Iy73JWrINfXBk0EhZbkq
=orn9
-----END PGP SIGNATURE-----

--/TDNEY6SkuiyIcFh--
