Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3IRUGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:06:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57928 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab3IRUGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:06:34 -0400
Message-ID: <523A0757.3050309@ti.com>
Date: Wed, 18 Sep 2013 16:04:39 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 02/16] drivers: thermal: introduce device tree parser
References: <5239F6D8.1020907@ti.com>  <1379530923-29268-1-git-send-email-eduardo.valentin@ti.com>  <1379531483.1787.55.camel@joe-AO722> <523A0290.8050502@ti.com> <1379534377.1787.59.camel@joe-AO722>
In-Reply-To: <1379534377.1787.59.camel@joe-AO722>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="aUHUqJqa3wsmMclmn1uuxnMCAIDgD6bk8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--aUHUqJqa3wsmMclmn1uuxnMCAIDgD6bk8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 18-09-2013 15:59, Joe Perches wrote:
> On Wed, 2013-09-18 at 15:44 -0400, Eduardo Valentin wrote:
>> Hello Joe,
>=20
> Hello Eduardo.
>=20
>>  18-09-2013 15:11, Joe Perches wrote:
>>> On Wed, 2013-09-18 at 15:02 -0400, Eduardo Valentin wrote:
>>>> This patch introduces a device tree bindings for
>>>> describing the hardware thermal behavior and limits.
>>>> Also a parser to read and interpret the data and feed
>>>> it in the thermal framework is presented.
>>>
>>> trivial notes:
> []
>>> If readings are within some non zero noise level,
>>> perhaps stable should be returned.
>>
>> Yes, there should be some sort of threshold for temperature trend. But=
 I
>> am not sure this is the right place to implement this. This type of
>> feature is in my TODO list, but I am planing to get it done within the=

>> core code of the thermal framework.
>=20
> No worries, one day...  Just wanted to bring it to attention.

Thanks, no worries, I should be working on it at some point in near
future. It does not hurt to add a TODO mark above this code though.

>=20
>>>> +static struct __thermal_zone *
>>>> +thermal_of_build_thermal_zone(struct device_node *np)
>>>> +{
> []
>>>> +	tz =3D kzalloc(sizeof(*tz), GFP_KERNEL);
>>>> +	if (!tz) {
>>>> +		pr_err("not enough memory for thermal of zone\n");
>>>
>>> Unnecessary OOM message.
>>> All allocs without GFP_NOWARN get a dump_stack()
>=20
> []
>=20
>> Hmmm.. I am pretty sure you have a good point. But to me seams to be
>> still a common practice to have drivers outputing error messages when
>> allocation fails. A simple git grep -A 4 kzalloc for instance, shows
>> that there are still quite a considerable amount of occurrences of suc=
h
>> practice.
>=20
> True though a considerable number have been removed.
> I think these should all be deleted eventually and
> there's no good reason to add more.


I see.  I will repost with your suggestion. Thanks.

>=20
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--aUHUqJqa3wsmMclmn1uuxnMCAIDgD6bk8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlI6B1cACgkQCXcVR3XQvP1LtAD/dq6y3m7A8RG/Thj6Q6YYKAUp
JUBf+LUjzbggBpG5usMBANlePSOdQFa0W6IjiQUm3MnUxLjNVu9wIzdoWSkwGY/3
=MqAX
-----END PGP SIGNATURE-----

--aUHUqJqa3wsmMclmn1uuxnMCAIDgD6bk8--
