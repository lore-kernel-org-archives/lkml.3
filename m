Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaDORUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:20:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45961 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaDORUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:20:45 -0400
Date: Tue, 15 Apr 2014 12:18:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: sundeep subbaraya <sundeep.lkml@gmail.com>
CC: <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140415171830.GB16002@saruman.home>
Reply-To: <balbi@ti.com>
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local>
 <20140220182257.GF23217@saruman.home>
 <CALHRZuoF52kHH7aPd5AA3iCG9iZhCFu-2=u3_jEiSFrUOnBAew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
In-Reply-To: <CALHRZuoF52kHH7aPd5AA3iCG9iZhCFu-2=u3_jEiSFrUOnBAew@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 26, 2014 at 03:37:52PM +0530, sundeep subbaraya wrote:
> >> +     INIT_LIST_HEAD(&req->queue);
> >
> > remove this INIT_LIST_HEAD();
> >
> > also, before returning, I suppose you probably want to link the request
> > to the endpoint somehow. Usually people save the endpoint pointer inside
> > the private request structure (iow: req->ep =3D ep;)
> >
>=20
> in ep_queue (say,for IN transaction) the driver copies the gadget
> driver buffer to HW endpoint buffer and if whole data
> has been transferred successfully then request is not added to
> endpoint request list. Hence  INIT_LIST_HEAD(&req->queue)
> is required since list_add_tail is not done every time in ep_queue. Is
> it ok to let this be here?o

my bad, you _do_ need this INIT_LIST_HEAD() here. When I first read, I
thought you were initializing struct usb_request list_head, and that is
not necessary ;-)

> >> +     if (req !=3D NULL)
> >> +             list_add_tail(&req->queue, &ep->queue);
> Here. INIT_LIST_HEAD(&req->queue) is required in alloc_req since
> list_add_tail is not executed every time.
>=20
> Could you please clarify my questions regarding requests queuing.
> 1. If Device need to send 5120 bytes to host and
> ep->desc->wMaxPacketSize is 512 then single request with length 5120
> is issued or 10 requests are issued?

single request.

> 2. Does device need to know OUT transactions before hand so that OUT
> requests are queued for endpoint before packets are received
> from host?

well, no. Gadget driver shouldn't depend on that. That's UDC driver's
responsability to manage that. I mean, if host sends OUT token and
there's nothing in the out queue, then UDC need to start transfer as
soon as gadget driver queues the request. If, on the other hand, gadget
driver queues packet before host has sent OUT token then you have two
choices:

1) start the transfer - most HW will wait for OUT token
2) wait for out token

--=20
balbi

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTTWnmAAoJEIaOsuA1yqRENb4QAIOqCsRTTq+olnq+15irjaey
Kt++seu/we5grxBRQ12Zbm4HsWjlxMF+1XOepAVdjzCdGqRpBc4cvqVJONwBbfxt
fYgMrALwUGCkfyStqENSYgBNBhHMNtTk2wxITtP4LvXcbiGCRLVnmbHpuA3C7Gp3
MgO6Oaep/UIfFAtMmwdldS6tIB62LXnH4SonFzNHpi5QfM7K45lKQjJwdMtvpZgG
43R34mjCqarI5FJjK+pUUKSrlT0y9Jy0OER3PbkmDFNRbhWhU4bKRi2GJPVyp2sv
tfZeCiT0n3oW20nBMe6oFinPpWv16H49/HxTlReDYCnpwsRMKD+01N/xX8dUKtim
wFkD6P0iN9BzvADer7Wsm5WYnBNIIqoASkJ6d77zuMHB90zXCev1vejCrfL4uhGF
waYxoydMkucX5+87FYK7VionVvHDXY0QkaK1L01mYhX2cmNQgY9/rRHHbA5i2HDa
Q2C11z72WpRv4AAe6Ud0xbZy4KmZUQ/ChBR/RAERzQF5Ml/vStuduBlx7BOI2p0B
mrW+bv8ROWcD58da7CqDGNwbRHI4DNWvYWsNCYfeeOpgG2h71cA8IjrB3cjD4Fjx
865gcClsawb2FhvfM1z7kaqeY3KQrMi9HWqqVo+4LOkWiG0FwvTstzvEjANCQJEN
y18tINYolwtfiQ9Dwl43
=tPC9
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
