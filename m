Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaJOSzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 14:55:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57937 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbaJOSzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 14:55:48 -0400
Date: Wed, 15 Oct 2014 13:55:39 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: be more verbose on ERRATIC_ERROR interrupt
Message-ID: <20141015185539.GF15770@saruman>
Reply-To: <balbi@ti.com>
References: <1413317705-10194-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141015050022.GA2378@saruman>
 <20141015165718.GB4529@psi-dev26.jf.intel.com>
 <20141015170145.GC4529@psi-dev26.jf.intel.com>
 <20141015170610.GC15770@saruman>
 <20141015183633.GD4529@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RDS4xtyBfx+7DiaI"
Content-Disposition: inline
In-Reply-To: <20141015183633.GD4529@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RDS4xtyBfx+7DiaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 15, 2014 at 11:36:33AM -0700, David Cohen wrote:
> On Wed, Oct 15, 2014 at 12:06:10PM -0500, Felipe Balbi wrote:
> > On Wed, Oct 15, 2014 at 10:01:45AM -0700, David Cohen wrote:
> > > On Wed, Oct 15, 2014 at 09:57:18AM -0700, David Cohen wrote:
> > > > On Wed, Oct 15, 2014 at 12:00:22AM -0500, Felipe Balbi wrote:
> > > > > Hi,
> > > > >=20
> > > > > On Tue, Oct 14, 2014 at 01:15:05PM -0700, David Cohen wrote:
> > > > > > ERRATIC_ERROR interrupt is an event that needs more attention f=
rom
> > > > > > developers than currently implemented, since this indicates a s=
erious
> > > > > > stability issue. The only way to get warned about it is by sele=
cting the
> > > > > > maximum driver's verbosity.
> > > > > >=20
> > > > > > This patch increases a bit the error's verbosity.
> > > > > >=20
> > > > > > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > > > > > ---
> > > > > >  drivers/usb/dwc3/gadget.c | 3 ++-
> > > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > > >=20
> > > > > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadge=
t.c
> > > > > > index 3818b26bfc05..132e761d62e4 100644
> > > > > > --- a/drivers/usb/dwc3/gadget.c
> > > > > > +++ b/drivers/usb/dwc3/gadget.c
> > > > > > @@ -2484,7 +2484,8 @@ static void dwc3_gadget_interrupt(struct =
dwc3 *dwc,
> > > > > >  		dev_vdbg(dwc->dev, "Start of Periodic Frame\n");
> > > > > >  		break;
> > > > > >  	case DWC3_DEVICE_EVENT_ERRATIC_ERROR:
> > > > > > -		dev_vdbg(dwc->dev, "Erratic Error\n");
> > > > > > +		WARN_ON_ONCE(1);
> > > > > > +		dev_dbg(dwc->dev, "Erratic Error\n");
> > > > >=20
> > > > > how about:
> > > > > 		WARN_ONCE(true, "Erratic Error\n");
> > > > >=20
> > > > > instead ?
> > > >=20
> > > > When erratic error event happens, in my experience it is usually
> > > > followed but many of them in a row. It may end up too verbose.
> > >=20
> > > Oops, sorry for my confusion. I read WARN(), not WARN_ONCE() when I r=
ead
> > > for the first time :)
> > >=20
> > > I let the dev_dbg() because it may be useful to get all the occurrenc=
es
> > > in case debug is enabled. But WARN_ONCE() is fine too if you prefer.
> >=20
> > We might WARN_ONCE() and forcibly disconnect from host as the platform
> > worn't work anymore after Erratic Error happens. Then just make that
> > clear with "Erratic Error: disconnecting from host\n" or something like
> > that.
>=20
> That works.
> I assume calling dwc3_gadget_disconnect_interrupt() from
> DWC3_DEVICE_EVENT_ERRATIC_ERROR should be enough to disconnect the
> gadget and propagate the status to userspace.
>=20
> >=20
> > The only way to fix erratic error (by fixing code - probably PHY driver)
> > will require rebooting the platform anyway. At a minimum, you'd have to
> > unload and reload dwc3.ko, just make sure (if you can reproduce erratic
> > error easily) modprobe -r dwc3 && modprobe dwc3 still causes dwc3 to
> > reconnect to host.
>=20
> It does. Forcing soft reset on whole IP is how databook describes to
> solve it.

alright, then please send a patch and I'll take for v3.19

--=20
balbi

--RDS4xtyBfx+7DiaI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPsMrAAoJEIaOsuA1yqRE3EEP/3pCURils87mq2gXNyDIdlUZ
+Mi6K89zd5rbIu8pEvVld8ZmrcJQkDhFnsvCdKWwrMVVEJbcdza1sxmWHaLD0fg3
7tIucKsM2wJY7QzbwAfXlDSuYDQRxFcrRbc6hAwA/dkQEkJUa1aNuYIJdPbV7/l1
pIoUFlBF7u97P2mW8xYZ69LYpAT+I2fP3IC9PUmb4EOT47WhFs2i9dztFtUp8vlG
NJ3ZOFkUbsPdGjjcVNB4hrhqInjN0LhTzHVwC7A2eex7pi7/NPRXXTtbHSrvAYmm
xXHh8X7BivMCymeYHpqi+6o63S3icN0gkxIaJEX9uo66SvAqKPnDZ3n6PW2LpHuF
xA3zLagcoK3RWCcx+lCk1l0l04xO/e9GpHZ0QrlLyvu9YFEF3oD4zWzxwv924mgI
w5rsxsINTjvjGzWuFfiDcxUglkkpTBxbR4IqIVcN+qL5MPYnaCSK3ZNmP5Hf8kiy
Iy7ggop0SWp33LGu6BuXiTHv4RP+jkG38RFpaJBppJuIPP4CZkSn2XPOwyNZkT/C
W3zE0V1izY927vI+U2q5rpdIwUY29nMkpFYgyCDNYve7PJD74+/U/l/FJwt7qLIp
8PaFuUMRlmx2IjkGQUFXpwV7GYVHM9fns9XG7Uw8hcWzy9EUN702L3x9iTI6jqCH
WsrXkzMQwVucPg+K42GT
=6Nku
-----END PGP SIGNATURE-----

--RDS4xtyBfx+7DiaI--
