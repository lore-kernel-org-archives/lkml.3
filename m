Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3GVNbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:31:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59199 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3GVNbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:31:16 -0400
Date: Mon, 22 Jul 2013 14:30:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130722133052.GT9858@sirena.org.uk>
References: <1374485092-13211-1-git-send-email-p.zabel@pengutronix.de>
 <20130722100856.GQ9858@sirena.org.uk>
 <1374491474.4355.12.camel@pizza.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JvcFcSNq1wOCYqbI"
Content-Disposition: inline
In-Reply-To: <1374491474.4355.12.camel@pizza.hi.pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: irq: Acknowledge also interrupts that are masked
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JvcFcSNq1wOCYqbI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 22, 2013 at 01:11:14PM +0200, Philipp Zabel wrote:
> Am Montag, den 22.07.2013, 11:08 +0100 schrieb Mark Brown:

> > what happens for masked interrupts.  Though based on your description of
> > the problem it sounds like a quirk to ack interrupts immediately after
> > masking them might do the trick instead of the full on always ack
> > behaviour.

> thanks, this seems to work, too:

Great.  I think a quirk might still be in order in case something is
relying on the interrupts still being asserted (eg, for handover after
boot) and it needs to check if ack_base is defined (for clear on read
interrupt controllers) but otherwise that looks good for upstream if you
want to send a patch?

--JvcFcSNq1wOCYqbI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7TQJAAoJELSic+t+oim9d94P/iBbZg5amxbAiyRjgZRG4ElR
8TfosSXWrxHaOQZhMRTd6y++3gJ2ThYOJRh2ozoUD7d1KRpCrnhg51GFqCf68jbv
9gG9M+elpKx5wONnFOFQSAL6/NEQVqBWSpOJTbvv1uWxC7ZwvpkK+iDlX+nTKXDm
lk7gTv/axxnS1m6sX60djkN4sf6AKsykCKY89KcLZ2kJHzPLm+2ChawuWCJoxPJ2
eT5d74W0n5636kVtbKTimXz8+QSdFx8AZsQnHSmQ/esnxbCwa8tjotD5bzN/9rxh
otahDOSljBJDEjZHVbHFJ8/+5ZryMbNsnLOZC7fGvkSJJuUu+IVOipXznGmqVuHi
QTNDzvppsmEoGzQ25+4ZQfzZQWuFlpMHCPqqlHV1QMxAJc0yMgTKpSNJUxTRMqhx
peKt9gmqijkvjvSS6DkZmFuAPoMR/mDeoGxIpyU84PIkb1eZbkaACJF4POxG7xtf
qeWYpzaOhklcddwAZ6JqrT6vPayye+8jfjah5zsvAEOFYNwK1hrY1xqZqC3SF578
BXDhpLE5IEUZpn5ezT9JVsrLmb2qXqjQYNEQBxCR21eUrABEGwm4sYijl4itHxVE
8jrtfx9SiMvEvKPHvqHkgsVNM+dTKscRQs2XWGuqdTz332Soq/1nj+UJIhrSnjyX
y1A1fuwiyCNWsfyq3G6q
=bdIY
-----END PGP SIGNATURE-----

--JvcFcSNq1wOCYqbI--
