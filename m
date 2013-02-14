Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989Ab3BNLDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:03:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56720 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756916Ab3BNLD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:03:29 -0500
Date: Thu, 14 Feb 2013 11:03:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Chris Ball <cjb@laptop.org>, Kevin Liu <keyuan.liu@gmail.com>
Subject: Re: [PATCH 3/3 RESEND] mmc: sdhci: check voltage range only on
 regulators aware of voltage value
Message-ID: <20130214110324.GA13249@opensource.wolfsonmicro.com>
References: <87bobqrcb4.fsf@octavius.laptop.org>
 <1360656096-1671-1-git-send-email-m.szyprowski@samsung.com>
 <Pine.LNX.4.64.1302122309470.14434@axis700.grange>
 <511B41B8.3060506@samsung.com>
 <Pine.LNX.4.64.1302130844530.18535@axis700.grange>
 <20130213113525.GB5062@opensource.wolfsonmicro.com>
 <511C9AD7.6000904@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <511C9AD7.6000904@samsung.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 09:05:43AM +0100, Marek Szyprowski wrote:

> 1. mmc_regulator_get_ocrmask() works only with regulators which support
> regulator_count_voltages() and regulator_list_voltage(). Recently
> support for
> continuous regulators have been merged. Such regulators doesn't provide
> regulator_list_voltage() method, but are able to change/set voltage to the
> given value. I agree that they are not very common, so right now we can
> probably ignore them until the first board, which uses them arrives.

OK, I think this should be changed to use regulator_is_supported_voltage()
to pick a range if list_voltage() isn't there, we don't want to list an
extremely large number of voltages so using list_voltage() for continous
regulators wouldn't make sense.

> 2. The second issue might be related to the testing of precise
> voltage values
> in the ocr mask, not the whole allowed ranges. Such issues in
> sdhci.c driver
> has been recently fixed by commit cec2e216f72c6b5ccdadb60aadbe99821d744503
> ("mmc: sdhci: Use regulator min/max voltage range according to spec"), but I
> don't know MMC core code to judge if ocr mask is used for exact voltage
> checking or only for checking the voltage ranges. However someone with good
> mmc subsystem knowledge should check it.

Looking at the code I'd expect it to work with continuous regulators, if
it doesn't we should fix that.

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRHMR1AAoJELSic+t+oim9OkMP/0A7Swi/II43Jt3bB20JkNlW
IwMoUMzf7ed/zFIqXVTCY1DVfL1p2ofzJSQLRwCPWC2W3eJmwo9tD7P+RQG+RgRI
ex5hXv3bf/DtEegDNdT4aNmonoOUt/raugZ1uIh3QT3pZdmv4kUzFhtpJQOG4AgY
lIE50sk9XSyxapNfAXMtcXH25BJwa3B1qpgp+2Goea5tyl6sjBqMeFSpRnC0jZ12
zErGowMJFkyL1ZP1gl5Uh2+D0qXnYvNkhmnV1mUE/j7oK2KGD19w4n7rme4irJ4i
svPRx8Dq3Ez+50zPVD4og5/IXtGcWLivj2+laI6of9P9Wm0kW+suWMh5/HZrBXAj
mYW2sE+qXZEeWhUuZTix0wXDi6CyACRfbpKRwSuYGI/KVdRTYQc3+h32+u4HXXGI
TRkuYYH1godGeRuhAGJ4cwUjgfygIl4flvWuc9C4Yon0ZQP8mo6qz5j+6LsfGKHo
dLJa8/MeDS8/bmQoBisvG0P1MHXbnWbNZw00usJwCABcQ84SoAAB94A5uFgkJx0G
cwPiSei13Am1iVeOpIEtJcKiW0IgPHOQK2GLIKk7qupUsDeOF03xMtj+syPxWqV1
dvNm0KGDdBke8WgnMA2O0ZsYo+a70Hv7W27P++MShBuIzSRj+Hg7YyJwAq7bQDRC
waYDlzXAEng9Xx2EC1da
=S+SX
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
