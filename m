Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaDPElt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:41:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47165 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaDPElr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:41:47 -0400
Date: Tue, 15 Apr 2014 23:39:23 -0500
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, sundeep subbaraya <sundeep.lkml@gmail.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140416043922.GC15056@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140415171830.GB16002@saruman.home>
 <Pine.LNX.4.44L0.1404151345580.1310-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2JFBq9zoW8cOFH7v"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1404151345580.1310-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2JFBq9zoW8cOFH7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 15, 2014 at 01:55:38PM -0400, Alan Stern wrote:
> On Tue, 15 Apr 2014, Felipe Balbi wrote:
>=20
> > > 2. Does device need to know OUT transactions before hand so that OUT
> > > requests are queued for endpoint before packets are received
> > > from host?
> >=20
> > well, no. Gadget driver shouldn't depend on that. That's UDC driver's
> > responsability to manage that. I mean, if host sends OUT token and
> > there's nothing in the out queue, then UDC need to start transfer as
> > soon as gadget driver queues the request. If, on the other hand, gadget
> > driver queues packet before host has sent OUT token then you have two
> > choices:
> >=20
> > 1) start the transfer - most HW will wait for OUT token
> > 2) wait for out token
>=20
> I'm not familiar with the variations in all the different UDC hardware. =
=20
> Nevertheless, I wouldn't describe the situation in those terms.

OK, I've oversimplified... what I meant was that even if you start a
transfer at the UDC level, nothing will happen on the bus until HW sees
an OUT token. The buffer pointed to by req->buf won't get any writes,
DMA won't do anything.

On (2) I meant that some HW (e.g. dwc3) will assert the IRQ line once
they see a token for which they have to transfer descriptors in the
internal controller's cache.

> If an OUT transaction occurs and the gadget driver hasn't queued a
> request, the UDC hardware could store the incoming data in an internal
> buffer or it could NAK the transaction.  There aren't any other
> choices.  If there isn't enough space available in an internal buffer,
> the only possible action is NAK.

in HS there's also NYET

> Regardless, gadget drivers do not need to queue requests for OUT
> endpoints before the host starts sending data.  When the request does

they're not required, but they can. It's UDC driver's responsability to
start consuming the queue at the proper time.

> get queued, the UDC driver will make sure that the transfer takes
> place.

correct.

--=20
balbi

--2JFBq9zoW8cOFH7v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTTgl6AAoJEIaOsuA1yqREuP8P/iGR8dgxDlZyDWcLF5MFP7il
UML0YN3vmzN5k7XUcWQ7VP4fORyNoPgzDkXkLzZavOQbTR2wuw5JKgF2xpi6nP4J
hKoOSjoyvX9IRQOoQHaT+aqD9OlTVNNWFTgpOwqcsCsWLY8YOCkcYXJKrwdYaJXA
o1GafbCtBexY6g0Aa0CcGFSOfjQiFQIPjGm1z6USz+67w072kdeG9/Dkep6Po7jN
udEW1b0IZK8HPVBo1IQClSlqnQh/LGU5P4xYKshBV7SqG/OjAKiBNE7zvcNUpU35
9xjOf0hrD/M3tX3oJCYF657MoPh5NfHN6a4a1gp6XxIk8nPxCQ7lvvCztqiBImBZ
Ve6UNPP2HY7O/+V8fwLFqnsv67FTWbW7kPMwCS48fYNyB9II+MCD8XwM9B2QRkZi
1vA9duYOodqiAQ9C2d6Gh3wGGs0iNUYjC9HPzhbQPWWn0/XfobmRUuxqqUwcsV82
tOS+zmcb874NGPGvaljFe7FtBoDfMetJCklcMzv/fqjTjsgKbVj5J3huh9ytBiEQ
Nt4yGHJ3Ide9fteYeWf1WvnLkAe/E1f3XQfLgFcro2+mWXuL9t1WnubDwutw3J4r
wOYlkkvkUDr6sZ1q+Ul/sWWVCraAFx5kBAfM6HnRl74CRpqWUBQmWF6BKeiDyBYC
3qpB6c4dmcwpXZwn35e8
=CFFn
-----END PGP SIGNATURE-----

--2JFBq9zoW8cOFH7v--
