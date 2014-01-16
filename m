Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaAPOCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:02:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55671 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaAPOCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:02:00 -0500
Date: Thu, 16 Jan 2014 14:01:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Yi Zhang <yizhang.mrvl@gmail.com>
Cc: Yi Zhang <yizhang@marvell.com>, hongfeng@marvell.com,
        linux-kernel@vger.kernel.org, zhouqiao@marvell.com
Message-ID: <20140116140153.GC17314@sirena.org.uk>
References: <CAK=oMXebE=OKzGbaRH_baOvRyhPXnw0MZuRrcZYLpeR73=XdqA@mail.gmail.com>
 <20140114210618.GZ15567@sirena.org.uk>
 <CAK=oMXc1YwQcAEfwzgr9QKVCF8kyT3wH2aubYtMYCcJBxviw6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ccMZA6j1vT5UqiK"
Content-Disposition: inline
In-Reply-To: <CAK=oMXc1YwQcAEfwzgr9QKVCF8kyT3wH2aubYtMYCcJBxviw6Q@mail.gmail.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Question] Should we make the primary interrupt handler
 configurable for regmap_add_irq_chip()?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1ccMZA6j1vT5UqiK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 16, 2014 at 07:33:13PM +0800, Yi Zhang wrote:
> 2014/1/15 Mark Brown <broonie@kernel.org>:
> > On Sat, Jan 11, 2014 at 12:15:21PM +0800, Yi Zhang wrote:

> >> I met a scenario:
> >> As soon as the interrupt is triggered, a wakelock is needed to be held
> >> until the threaded handler finishes,
> >> I think we may hold it in the primary interrupt handler, but now it's
> >> NULL by default;

> > This sounds like something we should just support in the core, though to

> Sorry, I'm not clear about this, you mean that this has been supported
> in regmap framework?
> I searched but didn't find related mail about this, could you please
> kindly point out the mail loop?
> thanks very much;

I'm saying we should support it in the core rather than providing a way
to override the handlers - it seems like it'll be sufficiently common
that we'll rapidly end up with multiple implementations anyway.  It
isn't currently supported in the core though, someone would need to
write that code.

--1ccMZA6j1vT5UqiK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1+ZOAAoJELSic+t+oim9HEoP/21T3B3gOXCQ2miq0CTB1Kza
5KvlzNp8umE/zM2c6Ot/Agb+dHTOGsG+UBwDuuFT0Ay9EMxrfijkcrFjStQta7CM
NsNnuw5OZPc/VET1ZVOWpZPxA+9JS36fM0ErJrAA7JfgkRkW+ZJel8KbN5AkKRJx
3RWdzAnzOIFVxk2hQnYLy1/ecywghgb/MtnV+3O4dx06/l1ihs+MzNK+BY6lNa9h
Vd/8rxeHXPe6HGcB5Y6WeHoTyIiP0fZ6zxwtkRUN8pOs2RHPHPsOqsdwPvIe+6QP
9mfjtGwOihipMzKPz4w42JvuPYaw08jPOoq4bQV14wVx8GK00v5mjjv9PUVQUDXz
etOkfpBw+KzOAqhwxp2UvjORYaxbne/l8YOq776K9tIPJhOs9hMLLmp4Q+tsPGte
qR1No0x9UYOI4vPhEal1+OlWK19Edce7z5UZNbiXTYMGTacUbzsvZU4kbc1p4C2f
ySwn3p19DRIE6Kvz90GH5AXzKajzYRuBqyN3IdQ73WKMl4ZzubgRIepFXq0EV/1E
mHCiBwCT5KzwE0Kd3VX6lP8+NayOjSqDC2usva7I1334oWVc67ZlQyULIc+JzZS+
dWMrRFC8K4qgCzg/ycZesrcVaBxjuz8BVkcB8G/zC2rzqcDc3EuffrTlaVHn83ej
KvcD5DVT1Gamp3cNdfkz
=XLdN
-----END PGP SIGNATURE-----

--1ccMZA6j1vT5UqiK--
