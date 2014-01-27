Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaA0Ke5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:34:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59950 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaA0Ke4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:34:56 -0500
Date: Mon, 27 Jan 2014 10:34:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Wei Ni <wni@nvidia.com>, linux-kernel@vger.kernel.org,
        LM Sensors <lm-sensors@lm-sensors.org>
Message-ID: <20140127103437.GU11727@sirena.org.uk>
References: <52E561D0.4040308@roeck-us.net>
 <20140126211357.6fa68909@endymion.delvare>
 <52E573B6.9040903@roeck-us.net>
 <20140126214936.7736f530@endymion.delvare>
 <52E58330.90602@roeck-us.net>
 <52E58656.7000903@roeck-us.net>
 <20140126235103.GP11727@sirena.org.uk>
 <52E5DDA5.2010705@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="abhKGpAWOHR+b9c1"
Content-Disposition: inline
In-Reply-To: <52E5DDA5.2010705@roeck-us.net>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [lm-sensors] lm90 driver no longer working on PCs in 3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--abhKGpAWOHR+b9c1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 08:16:37PM -0800, Guenter Roeck wrote:
> On 01/26/2014 03:51 PM, Mark Brown wrote:
> >On Sun, Jan 26, 2014 at 02:04:06PM -0800, Guenter Roeck wrote:

> >>I think I have a better idea: Surround the regulator code, or at least
> >>its error handling, in the lm90 driver with

> >>	if (IS_ENABLED(CONFIG_OF)) {
> >>	}

> >>Would that be ok ? If yes I'll submit a patch. I'll do the same in
> >>another driver I am working on.

> >That's not going to have the desired effect in cases where DT is built
> >into the kernel but not in use on the current system (which is a
> >configuration that gets used) and will remove error handling for non-DT
> >systems that do have regulators set up.  There's not the relationship
> >between this and DT that you seem think there is...

> >Besides, if we're going to do a bodge like that we should do it in the
> >core and not in individual callers.

> Then it appears the only remedy at this time is to revert the patch.

Why - that seems like a bit of a leap?  The first order problem with
what you're doing there is that conditionalising this on DT being built
into the kernel is the wrong conditional for several reasons, if you do
want to use an approach like this that at least needs to be changed.

--abhKGpAWOHR+b9c1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5jY6AAoJELSic+t+oim9O3AP/RBJY/tbtJNpkSRbt3i1lagM
KoZMgar7W/osn5+H/G5Er/LkteLolrRQBG4GVLC5HhAQpAvIf7TgxGpbbws60YoN
tcGi7G6Vq9xzqQ+44jqbi/2WMPM+2Nto/uZ9PIEt/HzJiXpVK5MVm0ZXsP+XnWlG
SStNtHwpSxav0HWV5JqRs4RdwqXlhwGuG3wO26MWfdy83OSCakvKacuogF6wQ+8o
7XepaqQX/W/RHDWFNhGrv8Vamh5mYybyWF8Hk3CyUL/SOpzMAaS/UPqLRjiJvxMO
n7TR549BG0Om7p7YqT6F2Bwi/OfTi0maladxJlusa1/Je4T4UQozcVIH6LFCR07w
DjaEF/wZPZO2VZK2mLRQ45ZJt8PZ73rXwFqD/71ZTK1jDMSa0C3sOgNdF8ASBtmA
ChHOwq0AyDXhZ3/9HAXvcDP1Ul9m4JLOAdW91oq87OmguBvkH7Ljt8YzXdzbRO9s
Hd6Wns90d+BM/7RyTiWfAPgGV6+h5CAi+wc7GiRGR7x+uQiDdQ8yOC6HCJ3ye+aa
/kjFinka7d7Yh+ustrkMQiAbPyqbXNuhYBZoDBw11epywG87+ixk/0dbBIEb5eqI
qTPRWkHWGaf2Swu28t9QgSDhxKNoUUU856XTdr+dFj0IYhn9sjokoNeltCaoO5lr
KXHo3ZcniWuXfGNQ5WZJ
=eVlW
-----END PGP SIGNATURE-----

--abhKGpAWOHR+b9c1--
