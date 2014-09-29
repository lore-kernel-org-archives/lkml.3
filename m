Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbaI2OGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:06:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55460 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbaI2OGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:06:13 -0400
Date: Mon, 29 Sep 2014 09:05:50 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: Michal Sojka <sojka@merica.cz>, <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, Bryan Wu <cooloney@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.vokac@comap.cz>
Subject: Re: [PATCH v6 2/4] usb: gadget: Refactor request completion
Message-ID: <20140929140550.GF32403@saruman>
Reply-To: <balbi@ti.com>
References: <Pine.LNX.4.44L0.1409241106100.1580-100000@iolanthe.rowland.org>
 <1411591401-5874-1-git-send-email-sojka@merica.cz>
 <1411591401-5874-3-git-send-email-sojka@merica.cz>
 <54291D3A.6070106@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8JPrznbw0YAQ/KXy"
Content-Disposition: inline
In-Reply-To: <54291D3A.6070106@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8JPrznbw0YAQ/KXy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 29, 2014 at 10:50:02AM +0200, Robert Baldyga wrote:
> > diff --git a/drivers/usb/gadget/udc/fsl_qe_udc.c b/drivers/usb/gadget/u=
dc/fsl_qe_udc.c
> > index 7324308..dd18ea3 100644
> > --- a/drivers/usb/gadget/udc/fsl_qe_udc.c
> > +++ b/drivers/usb/gadget/udc/fsl_qe_udc.c
> > @@ -118,10 +118,7 @@ static void done(struct qe_ep *ep, struct qe_req *=
req, int status)
> >  	ep->stopped =3D 1;
> >  	spin_unlock(&udc->lock);
> > =20
> > -	/* this complete() should a func implemented by gadget layer,
> > -	 * eg fsg->bulk_in_complete() */
> > -	if (req->req.complete)
> > -		req->req.complete(&ep->ep, &req->req);
> > +	usb_gadget_giveback_request(&ep->ep, &req->req);
>=20
> It looks like you have omitted if() statement. Are you sure that request
> has set complete() callback?

complete is mandatory. If a request comes without a complete, it
deserves to oops.

> Maybe it's worth to add this if inside usb_gadget_giveback_request()
> function?

nope, we want those cases to oops so we catch the broken gadget driver.

--=20
balbi

--8JPrznbw0YAQ/KXy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKWc+AAoJEIaOsuA1yqRE/TUQAIGYClMeH66a3ZNk1E6AFQQL
0XmJ+E+0ttpCt7viJIZPuON5BkXeWxdudTEMmCr2ombQIl9vIPA6MNMzILmXp+5i
SDtF639yoLQAM4nPuM93jd/6MHLSfUXsvFF3S1mQq/7Prp2Jzxj2q3qky3kLppxK
ny6zHqaK0c4P6zE5as2pmsEm1XatqBkAec5AFv3xW8fI+FfMyyBRlwCeeA2JUvgH
ZTC8gBNOgTjPyoG6ohTmAouKHXKdwAyBnr8ENPL1lV18h+c17AP8mnpREFW1o+D0
/XIYp9h5eO8vDJsRzSge/Lh8pGX9F1s2Eza3538qJFgoNBh14z+l/FWv/w2FHvq3
DyrHSrAE5Z6jwGqhb2osfEgg5+ywcSycKAA8oD5nN8Tm6EtvMvuEw52HQujOH+Rz
ourn2kw+OrY6YmQam7SOkaCJJ/pl9xUtRBZoe3Js+nzMMMDOxwk/fs2noNIkpDMt
OEkzgniPqm7QVrAFkKvOS/0FVORLsUClBvfC1ls2+kkoJjwvasNJCmdHYf9yOjZo
DauO212Kc/VCneTzFQfQDei2FBcqlU9cBjzl3dqhTzlzR10wf3Er1RrNVU5OtLfq
OxCLD4ut7u8D6FZ4ogSm9EEsvHSd9QP4PCtnf9/sbyMiN3h+6RgLAF6EDtoTX1/F
vnO40J5y0iwA+lBRlIww
=fwfc
-----END PGP SIGNATURE-----

--8JPrznbw0YAQ/KXy--
