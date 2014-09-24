Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaIXOtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:49:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42767 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaIXOtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:49:09 -0400
Date: Wed, 24 Sep 2014 09:48:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michal Sojka <sojka@merica.cz>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, Bryan Wu <cooloney@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.vokac@comap.cz>
Subject: Re: [PATCH v5 1/3] usb: gadget: Refactor request completion
Message-ID: <20140924144845.GB17997@saruman>
Reply-To: <balbi@ti.com>
References: <1410938473-29385-1-git-send-email-sojka@merica.cz>
 <1410938473-29385-2-git-send-email-sojka@merica.cz>
 <20140917152801.GD6903@saruman.home>
 <874mvyahcd.fsf@steelpick.2x.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <874mvyahcd.fsf@steelpick.2x.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 23, 2014 at 10:09:22AM +0200, Michal Sojka wrote:
> >> +/**
> >> + * usb_gadget_giveback_request - give the request back to the gadget =
layer
> >> + * Context: in_interrupt()
> >> + *
> >> + * This is called by device controller drivers in order to return the
> >> + * completed request back to the gadget layer.
> >> + */
> >> +void usb_gadget_giveback_request(struct usb_ep *ep,
> >> +		struct usb_request *req)
> >> +{
> >> +	if (likely(req->complete))
> >> +		req->complete(ep, req);
> >> +	else
> >> +		pr_err("%s : req->complete must not be NULL\n", __func__);
> >
> > let it Oops. We require ->complete to be valid, if there's any gadget
> > driver not setting ->complete, it deserves to oops so we can the
> > error.
>=20
> The Oops was there before, but I removed it because greg k-h didn't want
> it. See http://marc.info/?l=3Dlinux-usb&m=3D140917381611947&w=3D2. Do you
> still want the oops here?

you don't need a BUG_ON(), just call req->complete() directly without
any checks, if it's not valid, it _will_ oops. ->complete() is mandatory
and anybody sending requests without complete deserve to oops.

--=20
balbi

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUItnNAAoJEIaOsuA1yqRE4JgP/3IiJ7bxzJA7YhEop/kM06yX
SXfoR8BmkoLNy17THYZWZnyGq9hompmjXI+Gr2dNxXPzkCCpq5U6f58Lj9pg9czn
D0tW0DuJoqkXhLHjIOH/FnF89l01NQT1zBWvmYtXRajKLVIYyQT0l8OhqSnCXzOI
/8fua6nWfraSOlvqkpIYm/G1I+gYGV5ONG7fudB3nkfOpHLbXISAMU3/8LXh4wF6
acqqIoQRkCvCM8Chdqgm5WWJ/tVaX4Pyp9xW09gkEKf83/bRTgZ+Ips4moJ9LKue
0/ZfSSiLYsbC33naOgvP/1m8tu1Iyr0/cU2JlKArnPN6/W4KSv2cRLGhq7dTEdVx
aXEJ4LFtaFzZOkqnq+3Xat9L3efBen+GIkeFG+cea5pdvRsOB3yO/tttBvmM5/xd
TwkN9VlcI+7+aWtf4UaOhJA4uFYYUQ1b+72wHX+rgSuCcO5PkruVXPpEet66dHa0
rQdCkXavwTihIxoDWA1VO9uDtzDVKoU27DOLui8W9VRTnRupY22mNP4u3BIYpy5e
JOficnMbaAFbIO/NLh+/cRB5Dc0cQvN+klLg74yEy1Ez2FqQOVnPMvTqa1zdx5i6
97j8h0G7vyIcvVddzoCZJpLBLYvZfo/El9trzommxkpECJDDGlrUU0ZNkZYQTAYk
0P7tyV4oNk1Ubd1CSEhI
=cGEK
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
