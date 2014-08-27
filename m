Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965074AbaH0USU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:18:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35360 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964947AbaH0USQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:18:16 -0400
Date: Wed, 27 Aug 2014 15:17:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michal Sojka <sojka@merica.cz>
CC: <linux-usb@vger.kernel.org>, Bryan Wu <cooloney@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.vokac@comap.cz>
Subject: Re: [PATCH v3 1/2] usb: gadget: Refactor request completion
Message-ID: <20140827201753.GA25944@saruman.home>
Reply-To: <balbi@ti.com>
References: <CAK5ve-Jz7=7uZ3_Qg2bAH9BiGRZ36k-Oj9TNZ-_nAvaq6LGbjA@mail.gmail.com>
 <1409144625-25274-1-git-send-email-sojka@merica.cz>
 <1409144625-25274-2-git-send-email-sojka@merica.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <1409144625-25274-2-git-send-email-sojka@merica.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2014 at 03:03:44PM +0200, Michal Sojka wrote:
> All USB peripheral controller drivers called completion routines
> directly. This patch moves the completion call from drivers to
> usb_gadget_giveback_request(), in order to have a place where common
> functionality can be added.
>=20
> All places in drivers/usb/ matching "[-.]complete(" were replaced with a
> call to usb_gadget_giveback_request(). This was compile-tested with all
> ARM drivers enabled and runtime-tested for musb.
>=20
> Signed-off-by: Michal Sojka <sojka@merica.cz>
> ---
>  drivers/usb/chipidea/udc.c              |  6 +++---
>  drivers/usb/dwc2/gadget.c               |  6 +++---
>  drivers/usb/dwc3/gadget.c               |  2 +-
>  drivers/usb/gadget/udc/amd5536udc.c     |  2 +-
>  drivers/usb/gadget/udc/at91_udc.c       |  2 +-
>  drivers/usb/gadget/udc/atmel_usba_udc.c |  4 ++--
>  drivers/usb/gadget/udc/bcm63xx_udc.c    |  2 +-
>  drivers/usb/gadget/udc/dummy_hcd.c      | 10 +++++-----
>  drivers/usb/gadget/udc/fotg210-udc.c    |  2 +-
>  drivers/usb/gadget/udc/fsl_qe_udc.c     |  6 +-----
>  drivers/usb/gadget/udc/fsl_udc_core.c   |  6 ++----
>  drivers/usb/gadget/udc/fusb300_udc.c    |  2 +-
>  drivers/usb/gadget/udc/goku_udc.c       |  2 +-
>  drivers/usb/gadget/udc/gr_udc.c         |  2 +-
>  drivers/usb/gadget/udc/lpc32xx_udc.c    |  2 +-
>  drivers/usb/gadget/udc/m66592-udc.c     |  2 +-
>  drivers/usb/gadget/udc/mv_u3d_core.c    |  8 ++------
>  drivers/usb/gadget/udc/mv_udc_core.c    |  8 ++------
>  drivers/usb/gadget/udc/net2272.c        |  2 +-
>  drivers/usb/gadget/udc/net2280.c        |  2 +-
>  drivers/usb/gadget/udc/omap_udc.c       |  2 +-
>  drivers/usb/gadget/udc/pch_udc.c        |  2 +-
>  drivers/usb/gadget/udc/pxa25x_udc.c     |  2 +-
>  drivers/usb/gadget/udc/pxa27x_udc.c     |  2 +-
>  drivers/usb/gadget/udc/r8a66597-udc.c   |  2 +-
>  drivers/usb/gadget/udc/s3c-hsudc.c      |  3 +--
>  drivers/usb/gadget/udc/s3c2410_udc.c    |  2 +-
>  drivers/usb/gadget/udc/udc-core.c       |  9 +++++++++
>  drivers/usb/musb/musb_gadget.c          |  2 +-
>  drivers/usb/renesas_usbhs/mod_gadget.c  |  2 +-
>  include/linux/usb/gadget.h              |  8 ++++++++
>  31 files changed, 58 insertions(+), 56 deletions(-)
>=20
> diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
> index b8125aa..0444d3f 100644
> --- a/drivers/usb/chipidea/udc.c
> +++ b/drivers/usb/chipidea/udc.c
> @@ -627,7 +627,7 @@ __acquires(hwep->lock)
> =20
>  		if (hwreq->req.complete !=3D NULL) {
>  			spin_unlock(hwep->lock);
> -			hwreq->req.complete(&hwep->ep, &hwreq->req);
> +			usb_gadget_giveback_request(&hwep->ep, &hwreq->req);
>  			spin_lock(hwep->lock);
>  		}
>  	}
> @@ -922,7 +922,7 @@ __acquires(hwep->lock)
>  			if ((hwep->type =3D=3D USB_ENDPOINT_XFER_CONTROL) &&
>  					hwreq->req.length)
>  				hweptemp =3D hwep->ci->ep0in;
> -			hwreq->req.complete(&hweptemp->ep, &hwreq->req);
> +			usb_gadget_giveback_request(&hweptemp->ep, &hwreq->req);
>  			spin_lock(hwep->lock);
>  		}
>  	}
> @@ -1347,7 +1347,7 @@ static int ep_dequeue(struct usb_ep *ep, struct usb=
_request *req)
> =20
>  	if (hwreq->req.complete !=3D NULL) {
>  		spin_unlock(hwep->lock);
> -		hwreq->req.complete(&hwep->ep, &hwreq->req);
> +		usb_gadget_giveback_request(&hwep->ep, &hwreq->req);
>  		spin_lock(hwep->lock);
>  	}
> =20
> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> index 0ba9c33..5a524a6 100644
> --- a/drivers/usb/dwc2/gadget.c
> +++ b/drivers/usb/dwc2/gadget.c
> @@ -987,8 +987,8 @@ static int s3c_hsotg_process_req_feature(struct s3c_h=
sotg *hsotg,
>  					hs_req =3D ep->req;
>  					ep->req =3D NULL;
>  					list_del_init(&hs_req->queue);
> -					hs_req->req.complete(&ep->ep,
> -							     &hs_req->req);
> +					usb_gadget_giveback_request(&ep->ep,
> +								    &hs_req->req);
>  				}
> =20
>  				/* If we have pending request, then start it */
> @@ -1245,7 +1245,7 @@ static void s3c_hsotg_complete_request(struct s3c_h=
sotg *hsotg,
> =20
>  	if (hs_req->req.complete) {
>  		spin_unlock(&hsotg->lock);
> -		hs_req->req.complete(&hs_ep->ep, &hs_req->req);
> +		usb_gadget_giveback_request(&hs_ep->ep, &hs_req->req);
>  		spin_lock(&hsotg->lock);
>  	}
> =20
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 349cacc..b4b7a6b 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -268,7 +268,7 @@ void dwc3_gadget_giveback(struct dwc3_ep *dep, struct=
 dwc3_request *req,
>  			req->request.length, status);
> =20
>  	spin_unlock(&dwc->lock);
> -	req->request.complete(&dep->endpoint, &req->request);
> +	usb_gadget_giveback_request(&dep->endpoint, &req->request);
>  	spin_lock(&dwc->lock);
>  }
> =20
> diff --git a/drivers/usb/gadget/udc/amd5536udc.c b/drivers/usb/gadget/udc=
/amd5536udc.c
> index 41b062e..3b9d138 100644
> --- a/drivers/usb/gadget/udc/amd5536udc.c
> +++ b/drivers/usb/gadget/udc/amd5536udc.c
> @@ -841,7 +841,7 @@ __acquires(ep->dev->lock)
>  		&req->req, req->req.length, ep->ep.name, sts);
> =20
>  	spin_unlock(&dev->lock);
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	spin_lock(&dev->lock);
>  	ep->halted =3D halted;
>  }
> diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/a=
t91_udc.c
> index cfd18bc..9968f53 100644
> --- a/drivers/usb/gadget/udc/at91_udc.c
> +++ b/drivers/usb/gadget/udc/at91_udc.c
> @@ -267,7 +267,7 @@ static void done(struct at91_ep *ep, struct at91_requ=
est *req, int status)
> =20
>  	ep->stopped =3D 1;
>  	spin_unlock(&udc->lock);
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	spin_lock(&udc->lock);
>  	ep->stopped =3D stopped;
> =20
> diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.c b/drivers/usb/gadget=
/udc/atmel_usba_udc.c
> index 906e65f..e96032f 100644
> --- a/drivers/usb/gadget/udc/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
> @@ -463,7 +463,7 @@ static void receive_data(struct usba_ep *ep)
>  			list_del_init(&req->queue);
>  			usba_ep_writel(ep, CTL_DIS, USBA_RX_BK_RDY);
>  			spin_unlock(&udc->lock);
> -			req->req.complete(&ep->ep, &req->req);
> +			usb_gadget_giveback_request(&ep->ep, &req->req);
>  			spin_lock(&udc->lock);
>  		}
> =20
> @@ -495,7 +495,7 @@ request_complete(struct usba_ep *ep, struct usba_requ=
est *req, int status)
>  		ep->ep.name, req, req->req.status, req->req.actual);
> =20
>  	spin_unlock(&udc->lock);
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	spin_lock(&udc->lock);
>  }
> =20
> diff --git a/drivers/usb/gadget/udc/bcm63xx_udc.c b/drivers/usb/gadget/ud=
c/bcm63xx_udc.c
> index e969eb8..2235b88 100644
> --- a/drivers/usb/gadget/udc/bcm63xx_udc.c
> +++ b/drivers/usb/gadget/udc/bcm63xx_udc.c
> @@ -1088,7 +1088,7 @@ static int bcm63xx_ep_disable(struct usb_ep *ep)
>  			breq->req.status =3D -ESHUTDOWN;
> =20
>  			spin_unlock_irqrestore(&udc->lock, flags);
> -			breq->req.complete(&iudma->bep->ep, &breq->req);
> +			usb_gadget_giveback_request(&iudma->bep->ep, &breq->req);
>  			spin_lock_irqsave(&udc->lock, flags);
>  		}
>  	}
> diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/=
dummy_hcd.c
> index 2b54955..81dc595 100644
> --- a/drivers/usb/gadget/udc/dummy_hcd.c
> +++ b/drivers/usb/gadget/udc/dummy_hcd.c
> @@ -258,7 +258,7 @@ static void nuke(struct dummy *dum, struct dummy_ep *=
ep)
>  		req->req.status =3D -ESHUTDOWN;
> =20
>  		spin_unlock(&dum->lock);
> -		req->req.complete(&ep->ep, &req->req);
> +		usb_gadget_giveback_request(&ep->ep, &req->req);
>  		spin_lock(&dum->lock);
>  	}
>  }
> @@ -658,7 +658,7 @@ static int dummy_queue(struct usb_ep *_ep, struct usb=
_request *_req,
>  		spin_unlock(&dum->lock);
>  		_req->actual =3D _req->length;
>  		_req->status =3D 0;
> -		_req->complete(_ep, _req);
> +		usb_gadget_giveback_request(_ep, _req);
>  		spin_lock(&dum->lock);
>  	}  else
>  		list_add_tail(&req->queue, &ep->queue);
> @@ -702,7 +702,7 @@ static int dummy_dequeue(struct usb_ep *_ep, struct u=
sb_request *_req)
>  		dev_dbg(udc_dev(dum),
>  				"dequeued req %p from %s, len %d buf %p\n",
>  				req, _ep->name, _req->length, _req->buf);
> -		_req->complete(_ep, _req);
> +		usb_gadget_giveback_request(_ep, _req);
>  	}
>  	local_irq_restore(flags);
>  	return retval;
> @@ -1385,7 +1385,7 @@ top:
>  			list_del_init(&req->queue);
> =20
>  			spin_unlock(&dum->lock);
> -			req->req.complete(&ep->ep, &req->req);
> +			usb_gadget_giveback_request(&ep->ep, &req->req);
>  			spin_lock(&dum->lock);
> =20
>  			/* requests might have been unlinked... */
> @@ -1761,7 +1761,7 @@ restart:
>  						req);
> =20
>  				spin_unlock(&dum->lock);
> -				req->req.complete(&ep->ep, &req->req);
> +				usb_gadget_giveback_request(&ep->ep, &req->req);
>  				spin_lock(&dum->lock);
>  				ep->already_seen =3D 0;
>  				goto restart;
> diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/ud=
c/fotg210-udc.c
> index e143d69..1d31592 100644
> --- a/drivers/usb/gadget/udc/fotg210-udc.c
> +++ b/drivers/usb/gadget/udc/fotg210-udc.c
> @@ -70,7 +70,7 @@ static void fotg210_done(struct fotg210_ep *ep, struct =
fotg210_request *req,
>  		req->req.status =3D status;
> =20
>  	spin_unlock(&ep->fotg210->lock);
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	spin_lock(&ep->fotg210->lock);
> =20
>  	if (ep->epnum) {
> diff --git a/drivers/usb/gadget/udc/fsl_qe_udc.c b/drivers/usb/gadget/udc=
/fsl_qe_udc.c
> index 7324308..dd18ea3 100644
> --- a/drivers/usb/gadget/udc/fsl_qe_udc.c
> +++ b/drivers/usb/gadget/udc/fsl_qe_udc.c
> @@ -118,10 +118,7 @@ static void done(struct qe_ep *ep, struct qe_req *re=
q, int status)
>  	ep->stopped =3D 1;
>  	spin_unlock(&udc->lock);
> =20
> -	/* this complete() should a func implemented by gadget layer,
> -	 * eg fsg->bulk_in_complete() */
> -	if (req->req.complete)
> -		req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
> =20
>  	spin_lock(&udc->lock);
> =20
> @@ -2728,4 +2725,3 @@ module_platform_driver(udc_driver);
>  MODULE_DESCRIPTION(DRIVER_DESC);
>  MODULE_AUTHOR(DRIVER_AUTHOR);
>  MODULE_LICENSE("GPL");
> -
> diff --git a/drivers/usb/gadget/udc/fsl_udc_core.c b/drivers/usb/gadget/u=
dc/fsl_udc_core.c
> index 75b23ea..c362079 100644
> --- a/drivers/usb/gadget/udc/fsl_udc_core.c
> +++ b/drivers/usb/gadget/udc/fsl_udc_core.c
> @@ -197,10 +197,8 @@ __acquires(ep->udc->lock)
>  	ep->stopped =3D 1;
> =20
>  	spin_unlock(&ep->udc->lock);
> -	/* complete() is from gadget layer,
> -	 * eg fsg->bulk_in_complete() */
> -	if (req->req.complete)
> -		req->req.complete(&ep->ep, &req->req);
> +
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
> =20
>  	spin_lock(&ep->udc->lock);
>  	ep->stopped =3D stopped;
> diff --git a/drivers/usb/gadget/udc/fusb300_udc.c b/drivers/usb/gadget/ud=
c/fusb300_udc.c
> index d40255f..d52687d 100644
> --- a/drivers/usb/gadget/udc/fusb300_udc.c
> +++ b/drivers/usb/gadget/udc/fusb300_udc.c
> @@ -876,7 +876,7 @@ static void done(struct fusb300_ep *ep, struct fusb30=
0_request *req,
>  		req->req.status =3D status;
> =20
>  	spin_unlock(&ep->fusb300->lock);
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	spin_lock(&ep->fusb300->lock);
> =20
>  	if (ep->epnum) {
> diff --git a/drivers/usb/gadget/udc/goku_udc.c b/drivers/usb/gadget/udc/g=
oku_udc.c
> index 6c85839..bf9c5ef 100644
> --- a/drivers/usb/gadget/udc/goku_udc.c
> +++ b/drivers/usb/gadget/udc/goku_udc.c
> @@ -320,7 +320,7 @@ done(struct goku_ep *ep, struct goku_request *req, in=
t status)
>  	/* don't modify queue heads during completion callback */
>  	ep->stopped =3D 1;
>  	spin_unlock(&dev->lock);
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	spin_lock(&dev->lock);
>  	ep->stopped =3D stopped;
>  }
> diff --git a/drivers/usb/gadget/udc/gr_udc.c b/drivers/usb/gadget/udc/gr_=
udc.c
> index 08df5c4..924533b 100644
> --- a/drivers/usb/gadget/udc/gr_udc.c
> +++ b/drivers/usb/gadget/udc/gr_udc.c
> @@ -339,7 +339,7 @@ static void gr_finish_request(struct gr_ep *ep, struc=
t gr_request *req,
>  	} else if (req->req.complete) {
>  		spin_unlock(&dev->lock);
> =20
> -		req->req.complete(&ep->ep, &req->req);
> +		usb_gadget_giveback_request(&ep->ep, &req->req);
> =20
>  		spin_lock(&dev->lock);
>  	}
> diff --git a/drivers/usb/gadget/udc/lpc32xx_udc.c b/drivers/usb/gadget/ud=
c/lpc32xx_udc.c
> index 1629ad7..feab0ba 100644
> --- a/drivers/usb/gadget/udc/lpc32xx_udc.c
> +++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
> @@ -1479,7 +1479,7 @@ static void done(struct lpc32xx_ep *ep, struct lpc3=
2xx_request *req, int status)
> =20
>  	ep->req_pending =3D 0;
>  	spin_unlock(&udc->lock);
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	spin_lock(&udc->lock);
>  }
> =20
> diff --git a/drivers/usb/gadget/udc/m66592-udc.c b/drivers/usb/gadget/udc=
/m66592-udc.c
> index de88d33..8985656 100644
> --- a/drivers/usb/gadget/udc/m66592-udc.c
> +++ b/drivers/usb/gadget/udc/m66592-udc.c
> @@ -729,7 +729,7 @@ __acquires(m66592->lock)
>  		restart =3D 1;
> =20
>  	spin_unlock(&ep->m66592->lock);
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	spin_lock(&ep->m66592->lock);
> =20
>  	if (restart) {
> diff --git a/drivers/usb/gadget/udc/mv_u3d_core.c b/drivers/usb/gadget/ud=
c/mv_u3d_core.c
> index 1624871..046a1f8 100644
> --- a/drivers/usb/gadget/udc/mv_u3d_core.c
> +++ b/drivers/usb/gadget/udc/mv_u3d_core.c
> @@ -222,12 +222,8 @@ void mv_u3d_done(struct mv_u3d_ep *ep, struct mv_u3d=
_req *req, int status)
>  	}
> =20
>  	spin_unlock(&ep->u3d->lock);
> -	/*
> -	 * complete() is from gadget layer,
> -	 * eg fsg->bulk_in_complete()
> -	 */
> -	if (req->req.complete)
> -		req->req.complete(&ep->ep, &req->req);
> +
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
> =20
>  	spin_lock(&ep->u3d->lock);
>  }
> diff --git a/drivers/usb/gadget/udc/mv_udc_core.c b/drivers/usb/gadget/ud=
c/mv_udc_core.c
> index 040fb16..3c5db80 100644
> --- a/drivers/usb/gadget/udc/mv_udc_core.c
> +++ b/drivers/usb/gadget/udc/mv_udc_core.c
> @@ -248,12 +248,8 @@ static void done(struct mv_ep *ep, struct mv_req *re=
q, int status)
>  	ep->stopped =3D 1;
> =20
>  	spin_unlock(&ep->udc->lock);
> -	/*
> -	 * complete() is from gadget layer,
> -	 * eg fsg->bulk_in_complete()
> -	 */
> -	if (req->req.complete)
> -		req->req.complete(&ep->ep, &req->req);
> +
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
> =20
>  	spin_lock(&ep->udc->lock);
>  	ep->stopped =3D stopped;
> diff --git a/drivers/usb/gadget/udc/net2272.c b/drivers/usb/gadget/udc/ne=
t2272.c
> index 059cfe5..84d7162 100644
> --- a/drivers/usb/gadget/udc/net2272.c
> +++ b/drivers/usb/gadget/udc/net2272.c
> @@ -394,7 +394,7 @@ net2272_done(struct net2272_ep *ep, struct net2272_re=
quest *req, int status)
>  	/* don't modify queue heads during completion callback */
>  	ep->stopped =3D 1;
>  	spin_unlock(&dev->lock);
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	spin_lock(&dev->lock);
>  	ep->stopped =3D stopped;
>  }
> diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/ne=
t2280.c
> index f4eac11..2cda166 100644
> --- a/drivers/usb/gadget/udc/net2280.c
> +++ b/drivers/usb/gadget/udc/net2280.c
> @@ -928,7 +928,7 @@ done(struct net2280_ep *ep, struct net2280_request *r=
eq, int status)
>  	/* don't modify queue heads during completion callback */
>  	ep->stopped =3D 1;
>  	spin_unlock(&dev->lock);
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	spin_lock(&dev->lock);
>  	ep->stopped =3D stopped;
>  }
> diff --git a/drivers/usb/gadget/udc/omap_udc.c b/drivers/usb/gadget/udc/o=
map_udc.c
> index e731373..dcdfea4 100644
> --- a/drivers/usb/gadget/udc/omap_udc.c
> +++ b/drivers/usb/gadget/udc/omap_udc.c
> @@ -315,7 +315,7 @@ done(struct omap_ep *ep, struct omap_req *req, int st=
atus)
>  	/* don't modify queue heads during completion callback */
>  	ep->stopped =3D 1;
>  	spin_unlock(&ep->udc->lock);
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	spin_lock(&ep->udc->lock);
>  	ep->stopped =3D stopped;
>  }
> diff --git a/drivers/usb/gadget/udc/pch_udc.c b/drivers/usb/gadget/udc/pc=
h_udc.c
> index eb8c3be..0b69b32 100644
> --- a/drivers/usb/gadget/udc/pch_udc.c
> +++ b/drivers/usb/gadget/udc/pch_udc.c
> @@ -1486,7 +1486,7 @@ static void complete_req(struct pch_udc_ep *ep, str=
uct pch_udc_request *req,
>  	spin_unlock(&dev->lock);
>  	if (!ep->in)
>  		pch_udc_ep_clear_rrdy(ep);
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	spin_lock(&dev->lock);
>  	ep->halted =3D halted;
>  }
> diff --git a/drivers/usb/gadget/udc/pxa25x_udc.c b/drivers/usb/gadget/udc=
/pxa25x_udc.c
> index 251e4d5..42f7eeb 100644
> --- a/drivers/usb/gadget/udc/pxa25x_udc.c
> +++ b/drivers/usb/gadget/udc/pxa25x_udc.c
> @@ -347,7 +347,7 @@ static void done(struct pxa25x_ep *ep, struct pxa25x_=
request *req, int status)
> =20
>  	/* don't modify queue heads during completion callback */
>  	ep->stopped =3D 1;
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	ep->stopped =3D stopped;
>  }
> =20
> diff --git a/drivers/usb/gadget/udc/pxa27x_udc.c b/drivers/usb/gadget/udc=
/pxa27x_udc.c
> index 597d39f..4868369 100644
> --- a/drivers/usb/gadget/udc/pxa27x_udc.c
> +++ b/drivers/usb/gadget/udc/pxa27x_udc.c
> @@ -758,7 +758,7 @@ static void req_done(struct pxa_ep *ep, struct pxa27x=
_request *req, int status,
>  	if (pflags)
>  		spin_unlock_irqrestore(&ep->lock, *pflags);
>  	local_irq_save(flags);
> -	req->req.complete(&req->udc_usb_ep->usb_ep, &req->req);
> +	usb_gadget_giveback_request(&req->udc_usb_ep->usb_ep, &req->req);
>  	local_irq_restore(flags);
>  	if (pflags)
>  		spin_lock_irqsave(&ep->lock, *pflags);
> diff --git a/drivers/usb/gadget/udc/r8a66597-udc.c b/drivers/usb/gadget/u=
dc/r8a66597-udc.c
> index 4600842..0ec09a4 100644
> --- a/drivers/usb/gadget/udc/r8a66597-udc.c
> +++ b/drivers/usb/gadget/udc/r8a66597-udc.c
> @@ -925,7 +925,7 @@ __acquires(r8a66597->lock)
>  		sudmac_free_channel(ep->r8a66597, ep, req);
> =20
>  	spin_unlock(&ep->r8a66597->lock);
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	spin_lock(&ep->r8a66597->lock);
> =20
>  	if (restart) {
> diff --git a/drivers/usb/gadget/udc/s3c-hsudc.c b/drivers/usb/gadget/udc/=
s3c-hsudc.c
> index 10c6a12..dfbf557 100644
> --- a/drivers/usb/gadget/udc/s3c-hsudc.c
> +++ b/drivers/usb/gadget/udc/s3c-hsudc.c
> @@ -258,8 +258,7 @@ static void s3c_hsudc_complete_request(struct s3c_hsu=
dc_ep *hsep,
> =20
>  	hsep->stopped =3D 1;
>  	spin_unlock(&hsudc->lock);
> -	if (hsreq->req.complete !=3D NULL)
> -		hsreq->req.complete(&hsep->ep, &hsreq->req);
> +	usb_gadget_giveback_request(&hsep->ep, &hsreq->req);
>  	spin_lock(&hsudc->lock);
>  	hsep->stopped =3D stopped;
>  }
> diff --git a/drivers/usb/gadget/udc/s3c2410_udc.c b/drivers/usb/gadget/ud=
c/s3c2410_udc.c
> index 357b58e..ff423d1 100644
> --- a/drivers/usb/gadget/udc/s3c2410_udc.c
> +++ b/drivers/usb/gadget/udc/s3c2410_udc.c
> @@ -272,7 +272,7 @@ static void s3c2410_udc_done(struct s3c2410_ep *ep,
>  		status =3D req->req.status;
> =20
>  	ep->halted =3D 1;
> -	req->req.complete(&ep->ep, &req->req);
> +	usb_gadget_giveback_request(&ep->ep, &req->req);
>  	ep->halted =3D halted;
>  }
> =20
> diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/u=
dc-core.c
> index b0d9817..2eb0ae4 100644
> --- a/drivers/usb/gadget/udc/udc-core.c
> +++ b/drivers/usb/gadget/udc/udc-core.c
> @@ -102,6 +102,15 @@ void usb_gadget_unmap_request(struct usb_gadget *gad=
get,
>  }
>  EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
> =20
> +void usb_gadget_giveback_request(struct usb_ep *ep,
> +		struct usb_request *req)

you also need some kernel-doc for this function stating the context
where it needs to be called.

--=20
balbi

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/jzxAAoJEIaOsuA1yqREE8YP/Al+xgJLe3TnfeItXTy9tRSe
7EiBdGWyIAONJX8rCE3C8LobrVWHy8p5jBKd2aM+Kf77sNCoimf4EMzxf2ZLy6qv
YgW6VfKEza6N5HudK6OXOskEhTt2c4U0tRbrqCN6ZftEC2acz4q8pQIzsRD/ycaK
e6LQlS2L/FP4A33XYSmRgrD0psv21Un1rYs3jJ5IYYqcOkKn8WyTWV6spN5nCd4s
FgiAhPieYXHg4a8cizGsdCZvsZFn+K9FUSer8aE/Wm5yuLMJFCX4TWBD73hncSn4
//1V3yAHQW88V7mVAcba0ArmVS5RCK9Y04ENAuFnRMPyPx+SfvMWGroEsNoFKz64
BYM+0+7+kjg80lB+zVmmEZ7VqjZdPeKgtPIz0aBbDAZeT5aqjjeFHrk/7h5dE74c
fhhwsZXUqOs2mP5ZQnkLo/KLxjAuJLuXHR4qPA2z1HbMb7v6+bkm2gqzLS+arlqJ
Tg3yNzRMkOK34cYkMgUfqyHFwhUHAfUhXPqwsdT01sx+a8bRrz3Ofr0F35aZhWSV
/2FYrFpEKRcBgebcOaS1xK/7ouH6G7IZpvQxfrAu5prjtiDQA26gi4EPmG0uoJ3a
3oWkGANCB4LrdatROB6TWs2DVOQ0HZhe/qbdZkiLnhWGFIHjvV8zddzxhQ3xcLDp
i9HLplqcWd1So7Ds2n5o
=W7q0
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
