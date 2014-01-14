Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaANStX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:49:23 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47058 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaANStT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:49:19 -0500
Message-ID: <52D58665.70500@ti.com>
Date: Tue, 14 Jan 2014 14:48:05 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com> <52C4D612.2090808@nvidia.com> <52C5A6CE.5060904@nvidia.com> <20140106135145.GD21906@e106331-lin.cambridge.arm.com> <52CAC3AF.9020401@ti.com> <52CB69FA.9080903@nvidia.com> <52D45AC8.1010607@ti.com> <52D4A6DF.806@nvidia.com>
In-Reply-To: <52D4A6DF.806@nvidia.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="nu3mv24BEjNOpdFEfqVNQd0wwALSemmUi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nu3mv24BEjNOpdFEfqVNQd0wwALSemmUi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Wei,

On 13-01-2014 22:54, Wei Ni wrote:
> On 01/14/2014 05:29 AM, Eduardo Valentin wrote:
>> * PGP Signed by an unknown key
>>
>> Wei,
>>
>> On 06-01-2014 22:44, Wei Ni wrote:
>>> On 01/06/2014 10:54 PM, Eduardo Valentin wrote:
>>>>> Old Signed by an unknown key
>>>>
>>>> On 06-01-2014 09:51, Mark Rutland wrote:
>>>>> On Thu, Jan 02, 2014 at 05:50:06PM +0000, Matthew Longnecker wrote:=

>>>>>>
>>>>>>> I think the platform driver may set governor for the thermal zone=
,
>>>>>>> so how about to add a property named as "governor",
>>>>>>> and parse it to tzp->governor_name,
>>>>>>> something like:
>>>>>>>                  ret =3D of_property_read_string(child, "governor=
", &str);
>>>>>>>                  if (ret =3D=3D 0)
>>>>>>>                          if (strlen(str) < THERMAL_NAME_LENGTH)
>>>>>>>                                  strcpy(tzp->governor_name, str);=

>>>>>>>
>>>>>>> Thanks.
>>>>>>> Wei.
>>>>>>
>>>>>> DT is supposed to describe the hardware, right? The governor isn't=
=20
>>>>>> hardware -- it's a software control policy. On the other hand, tha=
t=20
>>>>>> control policy must be tuned according to the behaviors of the pla=
tform=20
>>>>>> hardware otherwise the system will be unstable.
>>>>>>
>>>>>> Is it appropriate to be naming the governor in DT? If so, is it eq=
ually=20
>>>>>> appropriate to describe any governor-specific parameters in DT (ev=
en=20
>>>>>> though they are pure software constructs)?
>>>>>
>>>>> The dt should be relatively static -- if the hardware doesn't chang=
e the
>>>>> dt shouldn't have to.
>>>>>
>>>>> The governers are not static. We can introduce new ones and throw a=
way
>>>>> old ones at any time. Tuning parameters can also change at any time=
=2E
>>>>>
>>>>> I'd prefer to not have governer details described in the dt, and th=
e
>>>>> choice of governer and configuration of its tuning parameters shoul=
d be
>>>>> made at runtime somehow.
>>>>
>>>> Agreed.
>>>
>>> Yes, I think so, but the of-thermal driver handle the
>>> thermal_zone_device_register, and pass the "tzp" without governor_nam=
e,
>>
>> In fact, it will fall into the default governor, which is step_wise, b=
y
>> default config.
>=20
> In the thermal_zone_device_register(), it has following codes:
>     if (tz->tzp)
>             tz->governor =3D __find_governor(tz->tzp->governor_name);
>     else
>             tz->governor =3D __find_governor(DEFAULT_THERMAL_GOVERNOR);=

>=20
> It mean if the tz->tzp is not NULL, and the governor_name is NULL, then=

> the __find_governor() will return NULL, so the tz->governor is NULL, it=

> can't fall into the default governor. And in the of-thermal driver, it
> call the thermal_zone_device_register(), and pass the "tzp" without
> governor_name.

Yes, it is a bug in the thermal core, thanks for reporting. Something
like [1] should fix it.

> I think if we want to change the governor in user space, we need to fix=

> this first.
>=20

Well no, the above bug does not prevent you to switch governors in
userspace.

[1] -  https://patchwork.kernel.org/patch/3487491/

>>
>>> so the created thermal_zone's governor will be NULL, then it can't ru=
n
>>> into the governor->throttle() if needed. And currently there have no
>>
>> Actually, no, the tz will be set to default governor, and its throttle=

>> call will be called.
>>
>>> interface to support updating governor and configuration at runtime.
>>> I think it's better to initialize the governor_name when register the=

>>> thermal zone device in the of-thermal driver.
>>
>> Still, why would you need to change the governor from a in kernel
>> decision? There is an ABI to change the thermal zone policy based on
>> user(land) request. If you need to change the policy from within the
>> kernel, which seams to be what you are trying to propose, you need to
>> explain why you need it, say, by giving at least one user of this API =
or
>> explaining its use case.
>=20
> The thermal_zone_device_register() support to set the governor which yo=
u
> want, but with the of-thermal framework, it only support to set to
> default governor, if fix above issue. I think the driver which use the
> of-thermal should be able to set to any governors which it want, in its=

> initialization. So I add the function thermal_update_governor().
>=20
>>
>>>
>>> Thanks.
>>>
>>>>
>>>>>
>>>>> Thanks,
>>>>> Mark.
>>>>>
>>>>>
>>>>
>>>>
>>>
>>>
>>>
>>
>>
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--nu3mv24BEjNOpdFEfqVNQd0wwALSemmUi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLVhmYACgkQCXcVR3XQvP1BagD6ApCdVX0sewwG0pI8Eg9+WL01
albhO7mx0hb7jRGvBR4A/jKdwDTamh2sshn/e65x3Lli8tcHV2fLfgokHz6qMeVR
=Y6Xs
-----END PGP SIGNATURE-----

--nu3mv24BEjNOpdFEfqVNQd0wwALSemmUi--
