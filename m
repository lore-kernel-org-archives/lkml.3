Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab3C1AHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:07:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41775 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754966Ab3C1AHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:07:00 -0400
Date: Thu, 28 Mar 2013 00:06:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 07/46] regulator: ab8500: Add support of low voltage
 battery
Message-ID: <20130328000657.GF18316@opensource.wolfsonmicro.com>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
 <1363881583-15234-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X4WsLVyvVA2qFUe+"
Content-Disposition: inline
In-Reply-To: <1363881583-15234-8-git-send-email-lee.jones@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X4WsLVyvVA2qFUe+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 21, 2013 at 03:59:04PM +0000, Lee Jones wrote:
> Low voltage batteries have a wider voltage range with
> lower operating voltages. Some consumers in the platform
> may not work with the lower voltages and therefore need
> an extra regulator to boost the voltage in this case.

So, the reason I keep stopping at this commit is that the changelog
bears no relationship to what the code is actually doing - the low
voltage battery stuff is a board specific thing not the device feature
which is rather buried here...  this all suggests that there's a
confusion between device and system code here.

> This driver adds support for checking the consumers that
> need higher voltage (Vaux1, 2 and 3 regulators, 3 V SIM)
> and control the external buck/boost regulator
> accordingly.

> Note that to utilize the low voltage battery support,
> the battery voltage thresholds must be changed. This
> applies for the low battery voltage threshold of the
> battery manager and the OTP setting for the AB8500
> BattOk levels.

This all looks board specific really, there's presumably a few signals
coming out of the AB8500 but the regulator definitions themselves (and
the names they're given) look rather more specific than that.

Which bits of this are for the AB8500 external regulator feature and
which bits are the external regulators?

--X4WsLVyvVA2qFUe+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRU4maAAoJELSic+t+oim9llAP/jEzV5eogafRvXV/T12qHS7p
m7XFG4RjOrQJF7MkqZaVyBX9+EidvSSx8RK8/6fw7hugvfYWL1kmfVCt1JHGvJiI
uDTu02iQ/g2ZbHis8YBW8hGMiGGkbkEvK9XCUF89dflmCY2/jv0VP0/pDHiLbBer
FlBaD8gf4mTguk62dvry71vhQiC54/e+DyKaME2SdTe2wnPmbP2NI08JXU7aTWf/
LbBZT3KxatRMw7ghbDKtZ8MBQu0Vf3Wn1Ta1CZUA9l9tz2KcwWAeiy1dU06UhQ4L
KwDhjx482m7a5zROl/T+l6RV/gDVrEhRX5/DF2ANA9jbrBNDeIpBMnZzFuXQPLMZ
Sw3Siux3/NbZoOan6UjEPz8vZuNlHVEYuhwrWBnQvjlAsW+/o002+9GpGJVh60Mk
IfUrOfUcfUzM+WOxqCzO8BsMctXnyHZmPYoSIWWwNFxvr3deUEuQd0+60VPePy+E
+P5U7dhd3WWcsHgUjR7s65ZgD1knn92YnRHrdOY/NbQ38S7R3kD4PRlGv4p17A18
/RxHe47FUnUb9cIha/ru2v+phcjptm5hKlYwTEPgeorLV3ZMGX8xWd9haCIM05ai
CIGUcC+9+myC+7e5qhKlyc4X3Zr2IV5S2O4O1F+IOg1JzOnpCksK8nFjpxAwHWlD
XuhyWc9J4m1Fvn06EvVM
=tMjR
-----END PGP SIGNATURE-----

--X4WsLVyvVA2qFUe+--
