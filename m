Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaAMPib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:38:31 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60948 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbaAMPiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:38:22 -0500
Message-ID: <52D40829.9030708@ti.com>
Date: Mon, 13 Jan 2014 11:37:13 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Matthew Longnecker <mlongnecker@nvidia.com>
CC: Wei Ni <wni@nvidia.com>, Eduardo Valentin <eduardo.valentin@ti.com>,
        <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <grant.likely@linaro.org>,
        <durgadoss.r@intel.com>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com> <52C4D612.2090808@nvidia.com> <52C5A6CE.5060904@nvidia.com>
In-Reply-To: <52C5A6CE.5060904@nvidia.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="qRRl9BSqdcGVBinNxfeT4c6Olt32DcQed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qRRl9BSqdcGVBinNxfeT4c6Olt32DcQed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02-01-2014 13:50, Matthew Longnecker wrote:
>=20
>> I think the platform driver may set governor for the thermal zone,
>> so how about to add a property named as "governor",
>> and parse it to tzp->governor_name,
>> something like:
>>                  ret =3D of_property_read_string(child, "governor", &s=
tr);
>>                  if (ret =3D=3D 0)
>>                          if (strlen(str) < THERMAL_NAME_LENGTH)
>>                                  strcpy(tzp->governor_name, str);

The above is not applicable to DT. The very first version of my proposed
series did include some sort of governor treatment too, fetching such
data from DT.

>>
>> Thanks.
>> Wei.
>=20
> DT is supposed to describe the hardware, right? The governor isn't
> hardware -- it's a software control policy. On the other hand, that
> control policy must be tuned according to the behaviors of the platform=

> hardware otherwise the system will be unstable.

Yes, this is the correct understanding. We can describe hardware,
including thermal constraints, as long as they do not include policy or
OS specific implementation.

>=20
> Is it appropriate to be naming the governor in DT? If so, is it equally=

> appropriate to describe any governor-specific parameters in DT (even
> though they are pure software constructs)?

No for both questions.

However, for the parameters, as long as you can map the software
parameter as a hardware descriptor, then we can discuss if that can be
used as DT properties.

>=20
> -Matt
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--qRRl9BSqdcGVBinNxfeT4c6Olt32DcQed
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLUCCkACgkQCXcVR3XQvP10KwEApcUxeBGNeMLMrEnU9a4Q/Bh9
i02tQi67DtB9B15nfcQA/3QfCydXrzf/etgKNFlnNOfq2Ryn38FxekhWUCqDIdXa
=kpN1
-----END PGP SIGNATURE-----

--qRRl9BSqdcGVBinNxfeT4c6Olt32DcQed--
