Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab3LBS1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:27:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:2934 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab3LBS1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:27:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,812,1378882800"; 
   d="asc'?scan'208";a="443322664"
Message-ID: <529CD206.5080605@linux.intel.com>
Date: Mon, 02 Dec 2013 10:31:34 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: balbi@ti.com
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, mina86@mina86.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 5/5] usb: dwc3: implement gadget's quirk ep_out_align_size
References: <1384290286-21432-1-git-send-email-david.a.cohen@linux.intel.com> <1384290286-21432-6-git-send-email-david.a.cohen@linux.intel.com> <20131125210614.GP18046@saruman.home>
In-Reply-To: <20131125210614.GP18046@saruman.home>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ixuSVaweQ2X3KuIQT16v6TKitot8Bitjk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ixuSVaweQ2X3KuIQT16v6TKitot8Bitjk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/25/2013 01:06 PM, Felipe Balbi wrote:
> Hi,
>=20
> On Tue, Nov 12, 2013 at 01:04:46PM -0800, David Cohen wrote:
>> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
>> index 5452c0fce360..7c2d36f6ad4b 100644
>> --- a/drivers/usb/dwc3/gadget.c
>> +++ b/drivers/usb/dwc3/gadget.c
>> @@ -1130,6 +1130,14 @@ static int dwc3_gadget_ep_queue(struct usb_ep *=
ep, struct usb_request *request,
>>  	dev_vdbg(dwc->dev, "queing request %p to %s length %d\n",
>>  			request, ep->name, request->length);
>> =20
>> +	/* If ep out, roundup request->length to epout maxpacketsize */
>> +	if (!(dep->number & 1)) {
>=20
> we have a direction field in the dep structure, please use that.
>=20
>> +		unsigned int aligned =3D roundup(request->length,
>> +					       ep->desc->wMaxPacketSize);
>> +		req->pad =3D aligned - request->length;
>> +		request->length =3D aligned;
>=20
> this is quite dangerous. You really don't know the size that gadget
> driver allocated. What if we're using SLOB and gadget driver allocated
> exactly 31 bytes (think MSC's CBW) ? Then you change request->length to=

> 512-bytes (or 1024 if USB SS), and host happens to be buggy (or
> exploited somehow) and sends more than 31-bytes ? You told dwc3 you
> could receive more than 31-bytes even though you don't know what follow=
s
> your 31-byte buffer.
>=20
> This is why I have been saying that gadget driver *must* be the one
> hadnling this issue based on the quirk flag.

Thanks. I've seen different point of views in this thread. Since you're
the maintainer, I'll resend the patch following your directions.

Br, David



--ixuSVaweQ2X3KuIQT16v6TKitot8Bitjk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQIcBAEBAgAGBQJSnNIIAAoJEGU5KLu7JjjxsioP/jpEUtl1MJRNR2fzBigrMWCW
lpN4QGGhfT6S7vRw2dVGhUVGu73v1WOjmAXKLyQFxW2Sh9dlcn+MKT4YpVo8WkHG
Wv6DasjmDd49GWUc4b0RnnVu1KmNzVn2LnDyts5x6sQw77eBT7FWAKnhyGJ3Vf3b
evcB+xGMURalr4oTXvw6UQACMuUvxWLo5voX8XCukR8/I0jakCUbVBSjuT6bKvfn
XpxOy6wks/DB5tJnEmnQ1/zWs6ma2SRgBCbAfrUd8aUauin0/QG9EM47v1vJKOwn
8kYsZd1xFCo9p+MPRy9spO7GEigBUQl6nFQvAPQ/szjtBWdIItHQZMrAfoFO31nk
kg/GYKXprVL9UoZV7BYtaP0UBeYuiNcC8+iGgbAxTuw9m1bcsT1THBXcXFLpKwpL
M7KfQQBMYveUai6wWSsZeFiStTjCqv+bp4Qs48UBwquRhbFIvm2/42tVzylkvqBf
s4jJMmR78nRsN3eq4QaSvVTaxZL/5//7U6Bi8q/4Ga1pGDQIp4kq8puhJxDJJR9y
N+3j5tpql0uc6u/RcFEvSWdsfrQhfLGgE8GKGtuzIZP1ktENpWvpxJGYCnyFwSCg
juFE8lo06tXDzRIT9wdEBeX3tujJFiVrG8ZvDGXlSK18+vmfwIkvybJ4Whaee/o5
prO9yx/cF4SqK9zgCVL+
=sj9E
-----END PGP SIGNATURE-----

--ixuSVaweQ2X3KuIQT16v6TKitot8Bitjk--
