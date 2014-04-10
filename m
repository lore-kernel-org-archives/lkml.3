Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbaDJV6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 17:58:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41541 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbaDJV6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 17:58:11 -0400
Date: Thu, 10 Apr 2014 16:55:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: <r.sricharan@ti.com>, <tglx@linutronix.de>, <galak@codeaurora.org>,
        <santosh.shilimkar@ti.com>, Darren Etheridge <detheridge@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq: crossbar: improve allocate_free_irq() complexity
Message-ID: <20140410215527.GF27668@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396392259-27437-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WlEyl6ow+jlIgNUh"
Content-Disposition: inline
In-Reply-To: <1396392259-27437-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WlEyl6ow+jlIgNUh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 01, 2014 at 05:44:19PM -0500, Felipe Balbi wrote:
> current algorithm in allocate_free_irq() is O(n),
> by just keeping track of last allocated IRQ with a
> simple unsigned integer, we can find a free IRQ
> in O(1).
>=20
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>=20
> compile-tested only as J6 DTS is currently missing crossbar
> altogether :-(
>=20
> There's a drawback with this patch which I'm not sure if we
> should care a lot because I couldn't entirely grasp when is
> domain->xlate() called and if we will map/unmap IRQs in runtime
> or will this *always* be done only during boot.
>=20
> If we're talking about runtime IRQ remapping, then this, clearly,
> won't work. But if this will be done only during boot up, then we
> avoid iterating over the irq_map array each time we try to translate
> a new IRQ prior to mapping it.
>=20
> Comments are highly welcome as I'll probably learn something new
> about the IRQ subsystem ;-)

do not apply this one!!! It won't work in all cases.

--=20
balbi

--WlEyl6ow+jlIgNUh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTRxNPAAoJEIaOsuA1yqRE2OgP/jtoS6uhlvNuiLnFVoPdhDAd
rEEP8pk5S5Vp5z2SPn/RfnJEkPqeekUBZAep1z7tw7xV6Y0f7+jmQxqicYu6Rc55
4YcW9cVHCiKvZp0TINaTDi++jupONgLS/Etdt0tmZF8gsAs2yCfaDnLjyq+YjGkM
ZR8NEn6vOLzpNCPUIul8aiJ1pmupn3NtrFIa/sAEYaun/VdsVhLolXg/MkscO62h
DIymYjhzLR8aYm4gnAozI6hiZAxRey4gi5JrEpUW10BXKrEql3fgVBmrkenmbCvU
oyN5BwWDrDx/AKTQ+e6k28Twkfz1SJSAfh9XZrlSEUGTQmHHlu8HtC0P9d3q5J4D
8iboU2iR8iIFYLQFiBOjE4Q7y89pwkyKcgZePXpjIZazwSDTWn+gHEL68FZlTvs8
lrSw2sQrpRw5ac/TsgZTU3hyw8c89UP52YLdC4FDKCv7h38eDHJMugAk51p3VGjr
nuiiYEZvQC0bXFH87vDvSxVxkQO58N3SDjJtQYEHgEw460KyKbSTUw2SZrzR7OIe
3PAiWcyBqKORFFBwFPjPMpEN7lIzxTXG3wYKhtg/sUyrg7qk5quf9/pE1KgZTT9w
zz5pvY8ULYhT0FbgcPppnMpkYpXAcrYhVjnNngZmmGN5Cq7qdNCh7UvsiDYGDxLZ
tCOFAV/6t/XTo//Ndx58
=Ada3
-----END PGP SIGNATURE-----

--WlEyl6ow+jlIgNUh--
