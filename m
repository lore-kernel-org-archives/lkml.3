Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3EINu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 09:50:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47591 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab3EINuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 09:50:25 -0400
Date: Thu, 9 May 2013 14:50:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Ming Lei <tom.leiming@gmail.com>, Saravana Kannan <skannan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>, Liam Girdwood <lrg@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Message-ID: <20130509135017.GD3200@sirena.org.uk>
References: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
 <1368076726-11492-2-git-send-email-skannan@codeaurora.org>
 <CACVXFVMd_iRtEM8ZLK6Ps66gZO6SCp1mXSgY6JbWtRJjJUh+ag@mail.gmail.com>
 <CACxGe6uHBNUcbD9SeRP5c3E8NN-Z2yjVV+9VAhuoJnXoBtTu2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Content-Disposition: inline
In-Reply-To: <CACxGe6uHBNUcbD9SeRP5c3E8NN-Z2yjVV+9VAhuoJnXoBtTu2w@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] driver core: Add API to wait for deferred probe to
 complete during init
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 09, 2013 at 12:50:46PM +0100, Grant Likely wrote:

> However, if a device that shuts down resources after init has
> completed and then cannot turn those resources back on when another
> driver requests them then it sounds like there is a bigger design
> problem. We're in a hotplug world and most of the time a driver cannot
> assume that a resource will never get requested after initcalls have
> completed. It sounds like a design bug in the driver if it cannot
> handle that use case.

Even if the driver copes fine it can still be desirable to avoid the
power down/up cycle if it involves some user visible effect - things
like blinking the display off then on for example.  That said I am a
little suspicious about this approach, it doesn't feel as robust as it
should to go round individual callers.

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRi6mVAAoJELSic+t+oim9lU0P/jHOdV7bZDgzw1oEnF+k9D4g
/Gmu9RXy/eJKFNrv05nUaBCgg7YYuLq7P3ixyNErAQjne61hY8IlbL0HYEsg7lEh
CQKLotCFj+EQXT89gqeApVBlYqlMbjRuh7cmGxqwPagclal8YMWK9LGyHA/GM1aY
CqsWlEpIjsQAoKu0vFYbeIwZoPk9Kvrj97w5oCZgpabU4x8YDfxdtl4C5iQjwPfI
SanLKe8ykqGzvt7jS+mQWDIuy7/pdZLGAjbeSV7cytyRPeuMclRNqv/iN/j7CXF2
70Opp3tgL2TW/esdrly1Wbp1Do+2i6B0iiXaVJrtqcmXoyjVW00D6VX0DYTG3rw2
7PNpH90dJTAkNFLibfoTh4Kve9+YggMh0+r7kgTlA7LsD0fmOnR/SrhYRAG4zwRb
yLFsyXyB+NQ3fTvDVooIL0nPLHn7qA6vC74ACJ47bNj7ObOji0kc/Kh0OHDuFgkL
YMYiIBd+hc7TccvpRyKP80B7mpNv/fFM1/rzqygEq/HsWPexqvA7R//PXvH13JJG
lzrF/hSS9j0UbJMsDI26n2eX5ZS+G4IEWf7oKRYosPz/qB3Cynoj8hkwl9EL/u9S
RdD9MRFcInjhsAcuox3QLCAEFCTqKsjmqVxNwviy7O23FoMKuBkz1HP2WhwMf3Vq
TlC4DredIEr9yPZFa1W2
=QdHy
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
