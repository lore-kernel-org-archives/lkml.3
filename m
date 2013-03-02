Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab3CBXLG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 18:11:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50540 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125Ab3CBXLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 18:11:05 -0500
Message-ID: <1362265843.3768.162.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 34/77] xen/blkback: Dont trust the handle from the frontend.
From: Ben Hutchings <ben@decadent.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Sat, 02 Mar 2013 23:10:43 +0000
In-Reply-To: <1362263724.1334.18.camel@x61.thuisdomein>
References: <20130301194351.913471337@linuxfoundation.org>
	 <20130301194355.578429064@linuxfoundation.org>
	 <1362172344.20156.15.camel@x61.thuisdomein>
	 <1362253682.3768.136.camel@deadeye.wl.decadent.org.uk>
	 <1362263724.1334.18.camel@x61.thuisdomein>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kG5A7jFlBp0jaF8QRtBr"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kG5A7jFlBp0jaF8QRtBr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-03-02 at 23:35 +0100, Paul Bolle wrote:
[...]
> 0) I've had another look at the relevant code in v3.8.2-rc1. It can be
> summarized like this:
>=20
> static int xen_vbd_translate()
> {
> 	[...]
> 	int rc =3D -EACCES;
>=20
> 	if ([...])
> 		goto out;
> 	[...]
>=20
> 	[p]req->dev  =3D vbd->pdevice;
> 	[p]req->bdev =3D vbd->bdev;
> 	[...]
>=20
>  out:
> 	return rc;
> }
>=20
> static int dispatch_rw_block_io()
> {
> 	struct phys_req preq;
> 	[...]
>=20
> 	preq.sector_number =3D req->u.rw.sector_number;
> 	preq.nr_sects      =3D 0;
> 	[...]
>=20
> 	for ([...]) {
> 		[...]
> 		preq.nr_sects +=3D seg[i].nsec;
> 	}
>=20
> 	if (xen_vbd_translate(&preq, blkif, operation) !=3D 0) {
> 		pr_debug(DRV_PFX "access denied: %s of [%llu,%llu] on dev=3D%04x\n",
> 			 operation =3D=3D READ ? "read" : "write",
> 			 preq.sector_number,
> 			 preq.sector_number + preq.nr_sects, preq.dev);
> 		goto [...];
> 	}
> 	[...]
> }
>=20
> 1) So if xen_vbd_translate() fails, it can return before setting
> preq.dev. That makes the call of pr_debug() use an uninitialized value,
> doesn't it?

Oh yes, so it's a completely valid warning in this case!

> Does inlining xen_vbd_translate() and/or
> dispatch_rw_block_io() generate code were that can't happen anymore?
> (Both functions being static they probably are inlined.)
>=20
> 2) And even if inlining does generate code where this can't happen,
> isn't it enough that preq.dev can be used uninitialized if no code were
> inlined?

If gcc inlines a function call, it analyses data flow between the two
functions.  Otherwise it assumes that the called function will
initialise any variable it's given a pointer to, and the warning doesn't
appear.  (That's my experience, anyway.)

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-kG5A7jFlBp0jaF8QRtBr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTKG8+e/yOyVhhEJAQr48BAAkjbCBU2LaeYRP/GSDpmU+EgJjCfGIGqj
VUQuE75RaDHQ3F7HVIEAPtxpToQt1La9+DH5VeMJQ6yD9iAurClfTNgKHwk70Qn2
Q9fKK7uCbmyQ4GdJw3TynvLF25rPrei9f8aQqhJLVSwU14zaXjqIVBvXOzF+twAH
FCN4ziV+wMIYUEFNWJ523KTSGdc1O8bdj0YjJl+SFNv/iW4XTXVp3gJMdqPTWnJQ
P93/gcXAYFzArzJEUk0v5cKd+sDIi+ThLcZBu3WXPb6uIX+fU8+joIpkcoUdjuco
aA/7oT0X8Soo3R8PePJZymSmgVlI2iYloAsRhxrVDHUdiDEHnqLUKpeArCMMm+tb
8WIMC0+ypb953EFs8VXmXWr0b/DjC+nOZCN/E503crTfqDIO8r6UV2JGvH7FOUA6
9YHHROfXOIxSWJ7OOgrTnKEiqmGn3kIFIWHKOHIJX3TAkebKlaWkvxlAD8LtWzgG
5S/4rgkBsztZ0F2UPdTz4C3BGSWNfVi6lX6yWWwdlIa7HggEVbh59QfG6WPZhUbE
1eDe4YR3tEkf5NPr0CPWxUHP3e5I8ZLq6ch2p75bpU2VA4pwPjWZl91tIk3mVLjG
z3Y1M8OnDIIW9Y9cLNEhEIHjwlbRZFc1IhVjc8VbhQnlyY/eYciRLgiSAfrl4JGc
BCiKwBN559c=
=s7A7
-----END PGP SIGNATURE-----

--=-kG5A7jFlBp0jaF8QRtBr--
