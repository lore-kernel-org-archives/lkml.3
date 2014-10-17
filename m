Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaJQSwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 14:52:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40485 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbaJQSwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 14:52:21 -0400
Date: Fri, 17 Oct 2014 13:52:09 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] usb: dwc2: gadget: sparse warning of context
 imbalance
Message-ID: <20141017185209.GY26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413521043-7587-1-git-send-email-sudipm.mukherjee@gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E345C@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yhqQ34TVR4fE8mPU"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844E345C@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yhqQ34TVR4fE8mPU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2014 at 06:50:19PM +0000, Paul Zimmerman wrote:
> > From: Sudip Mukherjee [mailto:sudipm.mukherjee@gmail.com]
> > Sent: Thursday, October 16, 2014 9:44 PM
> >=20
> > sparse was giving the following warning:
> >         warning: context imbalance in 's3c_hsotg_ep_enable'
> > 	                - different lock contexts for basic block
> >=20
> > we were returning ENOMEM while still holding the spinlock.
> > The sparse warning was fixed by releasing the spinlock before return.
> >=20
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> >  drivers/usb/dwc2/gadget.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> > index 7b5856f..7f25527 100644
> > --- a/drivers/usb/dwc2/gadget.c
> > +++ b/drivers/usb/dwc2/gadget.c
> > @@ -2561,8 +2561,10 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
> >  			hs_ep->fifo_size =3D val;
> >  			break;
> >  		}
> > -		if (i =3D=3D 8)
> > -			return -ENOMEM;
> > +		if (i =3D=3D 8) {
> > +			ret =3D -ENOMEM;
> > +			goto error;
> > +		}
> >  	}
> >=20
> >  	/* for non control endpoints, set PID to D0 */
> > @@ -2579,6 +2581,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
> >  	/* enable the endpoint interrupt */
> >  	s3c_hsotg_ctrl_epint(hsotg, index, dir_in, 1);
> >=20
> > +error:
> >  	spin_unlock_irqrestore(&hsotg->lock, flags);
> >  	return ret;
> >  }
>=20
> Acked-by: Paul Zimmerman <paulz@synopsys.com>

v3.18-rc or v3.19 ?

--=20
balbi

--yhqQ34TVR4fE8mPU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQWVZAAoJEIaOsuA1yqREDvAP/3gojywxn4hrh8fJ03CvzAxP
iyY4PxYsD/lL2peeRhLCmRlXGUIZmtsugTOmkq1hwFqleU5TRE3W+rwMqbmUf7xo
Z/kHb4GFr9/dHSBONIDkkhvlw9ro6krV/u/CG4odJfZWNMcKpvkURZNHnLPoUMTz
xhfIckzBj6Yykthuu0tnh/m1qeUw/KoWJ0G1rxpLlu0daBiD/ZwwxgrC93QHUBCm
781ZoJpuSZuu/8SC3C+YRKUQsgVHaZZenjA7jtTNlZWrP2agjzcu+RImy81qnemD
BCEJJ6rK36Gzz7fE39iPcGqXeHQsXPpeN8qt2Sc1xNF61EfXihaYhHnKP95hLuUV
68Vf0/uZgkIoAyTGB/DCtYmItD6May+n+Op7c2AN/1VBUysYVbo0isePYI6cifUn
xI3umwk7+kVorlnbAr6aUbRUqaL+vN8DnKMzpFHWIp1iTD4Aw5UDyd6zoGG8Qonk
whxt8k6k01GIJfcp3pZNlEDUuSAk6VJPHl5LgyJR8tiXGbJoYbhWkTWrXLtOa4/x
G4OD7LGnhSqvXPsc/pTGi+3E9L03tWuiASHWnNlfR+aQRelbIwAu4rcaZJdOgjH1
HPx83ovJLHUPo6SEcUumtz300Y/rA8wlT30Oje8eaYh1lB82Q7dpoEIQ/BclxWNY
etWUTtMNkwQUJK49PV19
=1h7m
-----END PGP SIGNATURE-----

--yhqQ34TVR4fE8mPU--
