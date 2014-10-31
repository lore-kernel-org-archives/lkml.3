Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbaJaSSD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:18:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59638 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724AbaJaSSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:18:01 -0400
Date: Fri, 31 Oct 2014 18:17:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141031181735.GT18557@sirena.org.uk>
References: <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl>
 <1414668415-597-1-git-send-email-mike.looijmans@topic.nl>
 <20141030165133.GB18557@sirena.org.uk>
 <545397BD.1070701@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5nUKqBW0XvnsonJi"
Content-Disposition: inline
In-Reply-To: <545397BD.1070701@topic.nl>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] Add ltc3562 voltage regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5nUKqBW0XvnsonJi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 31, 2014 at 03:07:57PM +0100, Mike Looijmans wrote:
> On 30-10-2014 17:51, Mark Brown wrote:

> >This appears to be reimplementing regmap (including a cache).  Please
> >use that instead.  Pretty much the entire driver could then be replaced
> >with the regmap helpers, none of the operations look like they'd be
> >needed, and you'd get the regmap diagnostic infrastructure.

> The chip doesn't have an I2C register map, it uses "commands".
> It does not support read transactions at all, it will NACK those. The first
> byte contains a bit mask that tells which outputs are to be configured and
> in what mode, the next is the enable bit and setpoint value. The first byte
> already contains data, it's not just an address.

If that's the case the code is really rather unclear about what it's
doing - the use of "reg" for what's being written doesn't help, nor does
the fact that what looks like a cache is being kept.  The code should
either use regmap or make it clear why that doesn't fit well.

--5nUKqBW0XvnsonJi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUU9I/AAoJECTWi3JdVIfQgUAH/1IMqRLAX6En68sbSbSOpQE7
McFUIiCp0wkIZhT3hHCZojKfZv1wtmO9qxZuprWYHjn1SG2W7LhUPcTEBwD7u2d+
5QH5Rjy27AtLLOIrxCv/OJkZXbFlBNMkVtajoi0igiYybaSoUUG9l/dEfzqX38p+
tPseYCgRA7Lq4VBnEojmjkLPc7xF+toQgnvKMuZ9JQwso3hLGEHnMhuuxi/BqfvQ
+QbOhnOscq3/0+JMrjrWwuvr7X6PvmXZlx/9Ng89KR9sKzcJJSJY5+n9P5X1bae5
p+jsVk6bMogipStVrOGwBMZxvRIga6BOLtPq7POAxNafPF6ZLCGiox+qOecofnw=
=UxhV
-----END PGP SIGNATURE-----

--5nUKqBW0XvnsonJi--
