Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967289Ab3E2X7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 19:59:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52420 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967257Ab3E2X7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 19:59:37 -0400
Date: Thu, 30 May 2013 02:58:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] usb: gadget: r8a66597-udc: do not unlock unheld spinlock
 in r8a66597_sudmac_irq()
Message-ID: <20130529235841.GB23190@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1369860697-17362-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <1369860697-17362-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Thu, May 30, 2013 at 12:51:37AM +0400, Alexey Khoroshilov wrote:
> r8a66597_irq() processes sudmac part (r8a66597_sudmac_irq()) before locki=
ng r8a66597->lock.
> But transfer_complete(), that is called inside (r8a66597_sudmac_irq()->su=
dmac_finish()->transfer_complete()),
> expects r8a66597->lock is locked. As a result unheld spinlock can be unlo=
cked.
>=20
> The patch just moves locking before calling r8a66597_sudmac_irq().
>=20
> Found by Linux Driver Verification project (linuxtesting.org).
>=20
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

should this go to stable ? Looks like this bug has been there since
2.6.32.

--=20
balbi

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRppYxAAoJEIaOsuA1yqREW40P/1KAUM6tq1ubTcBrmx1FrSs1
raRU4ekPfDNmWKa87M7PCzy01oZylwX01RU3nL1ajuutdyEPqDUCnz1R+u5p9Br8
FaA64KddoULuv10BIUSZug6NK/lls0cvO2olYqUaRW1Pt8IirqOl2OkWVRXv353O
vcK4QUuzcyMrl8l0HXzpPpbvJ9gokFjupbnkFpfj9s0b/6MEZmE8rmE0FAHU1U2d
VMDMPenZOms8fr6siXuN7W2X44OjWQyoRYVUrEc6jzwVbURocm6HzBjS5Dw/742w
0FAqrW97B3uUy+69Mx4m2kGcuEFJpJW4y8Vqm0q0pj630j5nGu0bsqYFANV9CsHl
g+pEJq4wuQYURgzAe4D8RGKiN6VenLeCWsvd+VtnayxDYf8oKxs/EzjLL7RWcgzL
NmuHJyy5M1rK7v8KXvFVfg0nKEqzgkXHn9wUwQsgdY+K74ObeZrPRNCemgYT0iG7
c//Jvd5/NlnJhkU9QVjlISy2pwRzygGBclxIlbIJ8fWeHxKPT5ix85HGmFqFwFlH
1zxLuHWsZIaj2wBTTJ7X+BbITWDmWbwXIimImDhkMYmziN5zhouZXn8zxD5couxt
/C+eRVD9aktqNYZnyOHO8F7prg//xLjiqzQgeagFUrM5oFj/HNEYNq4XfLPhoqKy
NIEPBr4ubU7Zzc7vhiKb
=GxcQ
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
