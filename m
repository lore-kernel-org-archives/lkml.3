Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab3LKWv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 17:51:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39109 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3LKWv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 17:51:27 -0500
Date: Wed, 11 Dec 2013 22:51:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20131211225116.GC11044@sirena.org.uk>
References: <1386666583-3280-1-git-send-email-k.kozlowski@samsung.com>
 <1386666583-3280-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B4IIlcmfBL/1gGOG"
Content-Disposition: inline
In-Reply-To: <1386666583-3280-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: s5m8767: Fix driver probe fail on BUCK7/8
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B4IIlcmfBL/1gGOG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2013 at 10:09:43AM +0100, Krzysztof Kozlowski wrote:
> The BUCK7 and BUCK8 were not supported by s5m8767 driver. If they were
> configured in DTS then the driver probing would fail with EINVAL:
> [    0.288474] VCC_SUB_1.35V: failed to apply 1350000uV constraint
> [    0.288671] s5m8767-pmic s5m8767-pmic: regulator init failed for 35
> [    0.294931] s5m8767-pmic: probe of s5m8767-pmic failed with error -22

> This patch adds support for BUCK7 and BUCK8 regulators using standard
> regmap get/set voltage sel functions.

I've applied these but this changelog doesn't entirely add up so I
rewrote it a bit.  The patch is implementing the get and set voltage
operations, the regulators were actually supported.  The errors were
being caused by the DT attempting to set the voltage for a fixed voltage
regulator which obviously won't work - I suspect that the DTs might not
be ideal, it seems common to overspecify voltages in DTs for some
reason.

--B4IIlcmfBL/1gGOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqOxhAAoJELSic+t+oim9RtIP/i84T5ZEXsQjPnsFpeslVmfI
vSY5mpTOlGl8LJIwOp0ntcmtpDOwmaOk2pEM4+f8mip/UEZElMYqRWPEhP2f9oAg
Bv/BXUk5SEON+za5lkjFPKZbp3Wc3cwmeSdWrEDZgQ/uG0gjttdYutcA6j89e9uG
xgyh/W7lLHufOKZvjYFjmM7egUqmg7PEEwbj42I3F19s8viruLIIjQRcuZqqAp/f
uKg1qrT5Ph6rEnQaXdi0qD3pOCakD6C9uebUYLxEyOvuOFrbxXP0R3wwRdGhRkhq
aZTpeKricaSHwYD6ot10KRwlAIxJ36d6UGiI76kxnBl8kNkhEfIoTYYa6mCkgmtE
D6LmTN3Fi6bgWD5jA2ANKdehRPriQVCC9q/Wpr/PCvcummhuptk1WFp0vT1AtsHg
8//0VI2TSTVafzOKkUZPz46jKHhLiKTCA0rC7NbSUL9YEIiWo3c79VOkm67+SHuJ
deUErV2IOZBWX4fKHNi8g8XYNVR6TTvAtNdoOPSy5XAcoXFyM7mPIPtu8GrCxKaq
snni/y1oRPFGpGG10dLlsk18/C+GAtUYFpxvABCvUJVSYE5ERWE0jEsYkQWQ4MDB
ZQ+APw9HXykpnFbHjDtT8nbj+7iNz7DcHG4TRV8Q0aM6ZS6mmS6ALszGxYCS+Gh2
aV1t+0A6+r8rqnaPyhhH
=i6dt
-----END PGP SIGNATURE-----

--B4IIlcmfBL/1gGOG--
