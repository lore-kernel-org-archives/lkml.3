Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaJQTMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 15:12:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41310 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbaJQTMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 15:12:34 -0400
Date: Fri, 17 Oct 2014 14:12:22 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] usb: dwc2: gadget: sparse warning of context
 imbalance
Message-ID: <20141017191222.GZ26260@saruman>
Reply-To: <balbi@ti.com>
References: <1413521043-7587-1-git-send-email-sudipm.mukherjee@gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E345C@US01WEMBX2.internal.synopsys.com>
 <20141017185209.GY26260@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E0304844E34A6@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UEW5kU42M6+IO/TD"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844E34A6@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UEW5kU42M6+IO/TD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2014 at 07:05:19PM +0000, Paul Zimmerman wrote:
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Friday, October 17, 2014 11:52 AM
> >=20
> > On Fri, Oct 17, 2014 at 06:50:19PM +0000, Paul Zimmerman wrote:
> > > > From: Sudip Mukherjee [mailto:sudipm.mukherjee@gmail.com]
> > > > Sent: Thursday, October 16, 2014 9:44 PM
> > > >
> > > > sparse was giving the following warning:
> > > >         warning: context imbalance in 's3c_hsotg_ep_enable'
> > > > 	                - different lock contexts for basic block
> > > >
> > > > we were returning ENOMEM while still holding the spinlock.
> > > > The sparse warning was fixed by releasing the spinlock before retur=
n.
> > > >
> > > > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > > > ---
> > > >  drivers/usb/dwc2/gadget.c | 7 +++++--
> > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> > > > index 7b5856f..7f25527 100644
> > > > --- a/drivers/usb/dwc2/gadget.c
> > > > +++ b/drivers/usb/dwc2/gadget.c
> > > > @@ -2561,8 +2561,10 @@ static int s3c_hsotg_ep_enable(struct usb_ep=
 *ep,
> > > >  			hs_ep->fifo_size =3D val;
> > > >  			break;
> > > >  		}
> > > > -		if (i =3D=3D 8)
> > > > -			return -ENOMEM;
> > > > +		if (i =3D=3D 8) {
> > > > +			ret =3D -ENOMEM;
> > > > +			goto error;
> > > > +		}
> > > >  	}
> > > >
> > > >  	/* for non control endpoints, set PID to D0 */
> > > > @@ -2579,6 +2581,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep =
*ep,
> > > >  	/* enable the endpoint interrupt */
> > > >  	s3c_hsotg_ctrl_epint(hsotg, index, dir_in, 1);
> > > >
> > > > +error:
> > > >  	spin_unlock_irqrestore(&hsotg->lock, flags);
> > > >  	return ret;
> > > >  }
> > >
> > > Acked-by: Paul Zimmerman <paulz@synopsys.com>
> >=20
> > v3.18-rc or v3.19 ?
>=20
> v3.18-rc, since it's a bugfix. And I forgot, this should be marked for
> 3.17 stable too.

Alright, I'll add that.

--=20
balbi

--UEW5kU42M6+IO/TD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQWoWAAoJEIaOsuA1yqREALsP/RXP3tK8j9+yfvaDESRG+2pQ
s+xZt8A98fScvfQd0cOzV3C7QcgRGPlsHkjRYzgRxIIm5LxGxA0Bk4uPgFg2jW7j
EKliVDIdZYTXSfW0u/Qre0Cure5fPXeeyBs0kSdh+e/gwtt1Tll6oI14nEfpuBQE
1NCOrJp+T8ZTgedQKWf+LAFhzRQZq3zu12ejSdZkoYMfUHGN9+S3gPxeucHDOsVO
ZogftN9uE3DR/IHpHCKB0enCxXYVZ9cXLmQtbgl6oFxVUIUotLufvnb05OAc1yrn
dNnl5VbhefkWdJykE7RNGLHb3GZmSq3bJQPjIIQaV3ycIoqEuo9bd13d0IgLRUT7
8hfsUPnPxM+4haT2EI7VTgaAjyvZQ5768mYSDpreRKg9smRbBis4KooL7mk9P2c8
KJDc05rEnkirHiy6y1Ca3oXrOEu+8WEJcf+EEk2WKos1SPCPgj4wzRKUtHs0DFTp
WhCyMujKY56zFn/rhKD+ZuPlY+MCHANLiLM11Y6ENMj8TX5UBpppHvpwmatOARS6
UiFJTDOXybmRdJD6SUAq+kM8f/bu/H08/Vv99uc0XoNK0aMcFvPOBsmy320CK0Ep
/ZGPkY9cPX5DZS+qXvq0GgGlzOTcVEN0yQMRQHZU12lFwtCoJZYy85/xrv/LjEgt
EMBQtQN4+MVOcqK2qbn4
=gEju
-----END PGP SIGNATURE-----

--UEW5kU42M6+IO/TD--
