Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaL2QDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 11:03:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54298 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaL2QDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 11:03:49 -0500
Date: Mon, 29 Dec 2014 16:03:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-spi@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org
Message-ID: <20141229160316.GO17800@sirena.org.uk>
References: <1419846074-240217-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E0e4ihfNxLmjeTLW"
Content-Disposition: inline
In-Reply-To: <1419846074-240217-1-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/spidev: Convert to use unified device property API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E0e4ihfNxLmjeTLW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 29, 2014 at 11:41:14AM +0200, Mika Westerberg wrote:
> This will allow the driver to match using DT compatible property if the
> device has ACPI _HID of "PRP0001" and accompanying "compatible" property
> listed in _DSD.

Which nobody should be doing since it's already totally broken for
something to be using this on the DT side except in the one case of the
Rohm device which is listed there.  I don't want to merge anything which
allows the breakage we're seeing with people putting spidev in their DTs
to be propagated into ACPI, at most we should have something that
specifically identifies individual devices only.

--E0e4ihfNxLmjeTLW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoXtEAAoJECTWi3JdVIfQtFQH/RWVQu+hAR8vPuKzMwIcllNK
BmlpZlqV2mxJQ7hyt8DOQuYp7J5Edw9XexIQefE5b/dEiAZiuOPOv3J+m0MQM2+h
mY/m9o1aZzJ+aLIlNoSQhp9cTDX9DZnX9mohENaUZgpvGkAjvVqEDdUs/gwDlD5a
dlPVzxMHI/o8VeW+0caSxhRK/ZaFsRdyxqElb/LmP8njtNzAvM7R9Ntar3MJ6wCN
18P/INpQtsNxPHvAanc45pLn0oGI6EUxRrxxwGJkO33oHeuGkYbX667hm2xkQIdE
5t68HlDb5iKS3jU8ivktixpoRRmOYHjwjUBBBhMQgn0pALn9o0W94SZOXHnchmg=
=JGH5
-----END PGP SIGNATURE-----

--E0e4ihfNxLmjeTLW--
