Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaKAXsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:48:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60866 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279AbaKAXsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 19:48:37 -0400
Message-ID: <1414885706.27313.6.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 023/102] block: Fix dev_t minor allocation lifetime
From: Ben Hutchings <ben@decadent.org.uk>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Keith Busch <keith.busch@intel.com>
Date: Sat, 01 Nov 2014 23:48:26 +0000
In-Reply-To: <54556A32.8020003@fb.com>
References: <lsq.1414880883.370330013@decadent.org.uk>
	 <54556A32.8020003@fb.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bhFkqp1rGFXvsjoKGhx/"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bhFkqp1rGFXvsjoKGhx/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2014-11-01 at 17:18 -0600, Jens Axboe wrote:
> On 2014-11-01 16:28, Ben Hutchings wrote:
> > 3.2.64-rc1 review patch.  If anyone has any objections, please let me k=
now.
> >
> > ------------------
> >
> > From: Keith Busch <keith.busch@intel.com>
> >
> > commit 2da78092dda13f1efd26edbbf99a567776913750 upstream.
> >
> > Releases the dev_t minor when all references are closed to prevent
> > another device from acquiring the same major/minor.
> >
> > Since the partition's release may be invoked from call_rcu's soft-irq
> > context, the ext_dev_idr's mutex had to be replaced with a spinlock so
> > as not so sleep.
> >
> > Signed-off-by: Keith Busch <keith.busch@intel.com>
> > Signed-off-by: Jens Axboe <axboe@fb.com>
> > [bwh: Backported to 3.2:
> >   - Adjust filename
> >   - idr insertion API is different, and blk_alloc_devt() is preallocati=
ng
> >     a node in a different way]
>=20
> As I've noted for pretty much every stable branch so far, you have to=20
> backport commit 46f341ffcfb5 as well, if you backport this one.

I'm not caught up on reading the stable list, so I missed that.  Thanks
for pointing it out again; I'll add it.

Ben.

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-bhFkqp1rGFXvsjoKGhx/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFVxSue/yOyVhhEJAQpaIxAAj91fcFl/0m4twFo2COtlJP8pyqjCJBIo
P4AgrDRtLFuoTvQIROVCxgfy00xs60K0LiRY4aYrJEH3wJ9Ujjnc0TXsWADIP+dC
9lkxZx0DoyqBCvHwu+J8YbUenEf7KVbjp1Pfx+At5Xk4lpKe0Zq0/tOMAVIGgGy2
bhPJPN2S3pgLlV/YC7MBuoMA4eQW4mDV6PoxP1OBw+x8O7X6Ahxwv7A1r8yy0j1b
PDr5xwRm3x88GIH1RfAGFRBwqWFpkDkZmFTNc5HrTF7o8d2VnY2r3Qs6Eq3taSRi
xKLgx81sUhFhRAd2ruKLTjW+aQB9F2lqXEQIk5t48Sk5oBb/KIIpT5d9+YUssJd7
TcX4taaPOXeY6oEc1Ic7owbGizLV9SD6XoYaL/3RY6V3MP7K5yuS8b6g2h22LmK3
NtrOzXe4pogpVVxxPWh/yhdGFIgfLSI8fJsd3Vo62ClaNxa9oNfzcCfn/Tj5IHUl
snyc+lVn/RXiMHkYAgO6319G7f8rkA9UtwThrnIhsr6sSUkdABmk7LFZZ46RYYCe
O2zJpVxl47yK7y+IdZmpjNnPsmK6gNi1qXsJJV80QKANlaKbcdWvgYyhGDQq55wU
tXe0ez2fpThRIXy+sOkMoQVOSSaC7FpYHalJTVE/UdQKJGrEhOLY7i7FscEmPjc6
JMvCMm8olgE=
=u6iq
-----END PGP SIGNATURE-----

--=-bhFkqp1rGFXvsjoKGhx/--
