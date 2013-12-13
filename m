Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3LMTxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:53:19 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48253 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab3LMTxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:53:17 -0500
Date: Fri, 13 Dec 2013 13:52:34 -0600
From: Felipe Balbi <balbi@ti.com>
To: Andreas Larsson <andreas@gaisler.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <software@gaisler.com>
Subject: Re: [PATCH v3] usb: gadget: Add UDC driver for Aeroflex Gaisler
 GRUSBDC
Message-ID: <20131213195234.GE5292@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386144838-16403-1-git-send-email-andreas@gaisler.com>
 <20131212180106.GF1939@saruman.home>
 <52AABBCE.8000709@gaisler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UnaWdueM1EBWVRzC"
Content-Disposition: inline
In-Reply-To: <52AABBCE.8000709@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UnaWdueM1EBWVRzC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 13, 2013 at 08:48:30AM +0100, Andreas Larsson wrote:
> >On Wed, Dec 04, 2013 at 09:13:58AM +0100, Andreas Larsson wrote:
> >>+static void gr_finish_request(struct gr_ep *ep, struct gr_request *req,
> >>+			      int status)
> >>+{
> >>+	struct gr_udc *dev;
> >>+
> >>+	list_del_init(&req->queue);
> >>+
> >>+	if (likely(req->req.status =3D=3D -EINPROGRESS))
> >>+		req->req.status =3D status;
> >>+	else
> >>+		status =3D req->req.status;
> >>+
> >>+	dev =3D ep->dev;
> >>+	usb_gadget_unmap_request(&dev->gadget, &req->req, ep->is_in);
> >>+	gr_free_dma_desc_chain(dev, req);
> >>+
> >>+	if (ep->is_in) /* For OUT, actual gets updated bit by bit */
> >>+		req->req.actual =3D req->req.length;
> >>+
> >>+	if (!status) {
> >>+		if (ep->is_in)
> >>+			gr_dbgprint_request("SENT", ep, req);
> >>+		else
> >>+			gr_dbgprint_request("RECV", ep, req);
> >>+	}
> >>+
> >>+	/* Prevent changes to ep->queue during callback */
> >>+	ep->callback =3D 1;
> >>+	if (req =3D=3D dev->ep0reqo && !status) {
> >>+		if (req->setup)
> >>+			gr_ep0_setup(dev, req);
> >>+		else
> >>+			dev_err(dev->dev,
> >>+				"Unexpected non setup packet on ep0in\n");
> >>+	} else if (req->req.complete) {
> >>+		unsigned long flags;
> >>+
> >>+		/*
> >>+		 * Complete should be called with interrupts disabled according
> >>+		 * to the contract of struct usb_request
> >>+		 */
> >>+		local_irq_save(flags);
> >
> >sorry but this driver isn't ready for inclusion. local_irq_save() is a
> >pretty good hint that there's something wrong in the driver. Consider
> >the fact that local_irq_save() will disable preemption even when
> >CONFIG_PREEMPT_FULL is enabled and you have a bit a problem.
>=20
> This connection between local_irq_save and CONFIG_PREEMPT_RT_FULL was
> unknown to me. Sure, I can disable interrupts right at spin lock
> time.

that's better.

> >Also, the way you're using thread IRQs is quite wrong. I can't let that
> >pass and get merged upstream, sorry.
>=20
> What is quite wrong? What is it that I need to fix?

Ideally the hardirq handler should be usually to actually check if
$this_device generated the IRQ, that should involve reading a IRQSTATUS
register of some sort.

Sure, check that IRQs are actually enabled, but you also need to read
STATUS register before waking the thread up.

--=20
balbi

--UnaWdueM1EBWVRzC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSq2WCAAoJEIaOsuA1yqREAz0QAJgW4FSwk2BEs1eJQWv/zEwq
B0SJg521MLk6sEpV3/em1Vc8Ip0xGuaW/gaDfAaD90pE8P9GN2BTTR8zNou/VcKc
ABuJPkKBGBVZyaVAVGru5vG+9gBdAVxirD5KwneCvBMytac9VJelMkmQ/wquM3I/
GutyEs6GBLQi16lXwQEmovNMdblK1jCS++UFKy5pvUp7S9GQ6UO45SJXu6cnnAv8
lsTfeh8gYEMd9El7GDyTlHZb3+emNC8rEKTDryFNviC4dLCorD3gLEazCU1YkTY2
QWzrL6xzVqS1pjdk99zPIPzSEyjOirmtn0waD49EDDMPmbiiHTt3cNav0guo/pgV
x5H9dG7Uefg7Tzuu7a8cQlQSkyQsqAuZEpvZnPvS2Vqq4NvafFYUjCHYH++edHwp
n1byFoaPTseOLPBEblmXN39TMmUYAe0z27enexRuE3jacApLFI/RgsuS9y5+gMzY
8tv+Vmn3wAB1BFPX4DubWI/uzLMXHAYAtrpOLaA14aY/d7fgru0loW4JR2TIh1zk
x53x4KpFGL4iOmGMwlP8rJC3BRAnyMMJpYOjPvlHtt8p40ulJxPlJJllLh1DB1w4
G7+O1wtRyyAl852ZyWvAVDiZgYCJsFbIfurNQTV+T1FgzCqurd0HfoXOjBydVDop
XQXh4dvlt9AIfA/eF+fG
=6AuA
-----END PGP SIGNATURE-----

--UnaWdueM1EBWVRzC--
