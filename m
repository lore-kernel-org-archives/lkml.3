Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3C1BGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 21:06:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49440 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754090Ab3C1BGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 21:06:17 -0400
Date: Thu, 28 Mar 2013 01:06:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrei Epure <epure.andrei@gmail.com>
Cc: cbou@mail.ru, dwmw2@infradead.org, milo.kim@ti.com,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] power: pass IRQF_ONESHOT to request_threaded_irq()
Message-ID: <20130328010611.GV18316@opensource.wolfsonmicro.com>
References: <1364431370-25029-1-git-send-email-epure.andrei@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t1CmwkW5H+10rlDA"
Content-Disposition: inline
In-Reply-To: <1364431370-25029-1-git-send-email-epure.andrei@gmail.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t1CmwkW5H+10rlDA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2013 at 02:42:50AM +0200, Andrei Epure wrote:
> Patch found using coccinelle.
>=20
> Signed-off-by: Andrei Epure <epure.andrei@gmail.com>

Some of these may be false positives especially for PMICs - often the
interrupts are guaranteed to be generated from the interrupt controller
on the device which runs in thread context.

More generally though why not fix this in request_threaded_irq() itself,
if there's no hard IRQ handler then add the flag transparently?  It'd
save boilerplate.  Indeed I could've sworn someone did that...

--t1CmwkW5H+10rlDA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRU5duAAoJELSic+t+oim9rQEP/ikW9huREn1RjpHcJKf7ym7N
s/8XvT9BG/YyVcej+0I7npbayY3mN5DrGMn4FvYxqIMflZteqp8qjusBpL+9l2nQ
QrqbIA8kvTdK8Dw/SvLVqQXKqN+QFWfBNZE4BT78WEB1H57agCDbg7njTj4UiyMp
XquQn9madOWDokb6F6EMED0piSAoRNvSCyNkWtUPD1Ss4QZgawDqf5TK7V6IRC9R
/3wnZUyxFg+rSq215L0mfslcqwDmsy3rXMdmA6IwtZU9lVdSNmeWJlyHBH1z7FO+
4G/139a38DI+mcKdwVpXLEoMk7tfruSpJV3vmpuT2TcChGfy9EjUqL8KDt9gjkHM
ze/Q349F3QDcwNxJtAoJd63zMDPIlLl9dxqBYINOVW9FIkGuaTZMDbnVlXHDWORv
j49NoPt2IaBb8RaHugfBluRYWAaNaMqvZA239gkomJ+xtDkSlFi+bz7aULaV3VeQ
V1HdE2j/CiTb8XWGe8p9V57ywcHcCrFq+tA6ZeSuOJpv98b9rJdUKQ6a4MdayZTt
bDcUveh37aG6MxPuB6oBqhtbIe3hQJoyT4i9i1MockwGd3GX3vTehf57WFUjQA4t
3Bh6DRMJ+MnaQ8RmxFIUuY+8yPIoUZeaKZjOFX7QlUZknqe1VsPKBt7448zKMliN
zAh7Egfa6jJngM1x444I
=fMy2
-----END PGP SIGNATURE-----

--t1CmwkW5H+10rlDA--
