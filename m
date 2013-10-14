Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab3JNOSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:18:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57179 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3JNOSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:18:16 -0400
Message-ID: <525BFD1B.5080709@ti.com>
Date: Mon, 14 Oct 2013 10:18:03 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        <linux-pm@vger.kernel.org>, <naveenkrishna.ch@gmail.com>,
        <rui.zhang@intel.com>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amit.daniel@samsung.com>,
        <kgene.kim@samsung.com>, <devicetree@vger.kernel.org>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: Re: [PATCH 1/3 v4] thermal: samsung: correct the fall interrupt en,
 status bit fields
References: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com> <2386580.3V2pzai3k2@amdc1032> <525814EE.8060700@ti.com> <1615083.zyGXhBfPcS@amdc1032>
In-Reply-To: <1615083.zyGXhBfPcS@amdc1032>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="GSXQ8SNS86O1d1FtJcx2I0wPRb8uFmrOE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GSXQ8SNS86O1d1FtJcx2I0wPRb8uFmrOE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11-10-2013 11:57, Bartlomiej Zolnierkiewicz wrote:
>=20
> Hi,
>=20
> On Friday, October 11, 2013 11:10:38 AM Eduardo Valentin wrote:
>> Hi Naveen,
>>
>> On 09-10-2013 10:03, Bartlomiej Zolnierkiewicz wrote:
>>>
>>> Hi,
>>>
>>> All patches (#1-#3) look good to me, FWIW you can add:
>>>
>>> 	Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>>>
>>> Please note that (at least) patch #3 conflicts with Lukasz's EXYNOS44=
12
>>> fixup patchset:
>>>
>>> 	https://lkml.org/lkml/2013/10/9/35
>>>
>>> It is up to Eduardo to resolve this but it probably would be better t=
o
>>> merge EXYNOS4412 fixes first and then add EXYNOS5420 support. This wo=
uld
>>> require you to port patch #3 over Lukasz's patchset though.
>>
>> My question is if this fix applies also to EXYNOS4412, as it  is not
>> mentioned in the patch description and the change affects all supporte=
d
>=20
> This patch doesn't affect EXYNOS4210 as exynos4210_tmu_registers struct=


I was, at least for now, worried about 4412, as I mentioned above.

> uses the default zero value for inten_fall_mask, inten_fall_shift and
> intclr_fall_shift.
>=20
>> chip version deliberately. Has this change been validated on all
>> supported chip versions?
>>
>> Amit, I saw you ack, but still, it is not clear how this change behave=
s
>> across supported hardware.
>=20
> For EXYNOS4412 and EXYNOS5250 this patch doesn't cause any functionalit=
y
> changes because while the patch changes inten_fall_shift usage to
> intclr_fall_shift one in exynos_tmu_initialize() it defines
> EXYNOS_TMU_CLEAR_FALL_INT_SHIFT to 12 (old EXYNOS_TMU_FALL_INT_SHIFT
> value).
>=20

OK. Then the patch is about a symbol rename, right?

> This patch only changes driver behavior for EXYNOS5440 on which the
> used shift value changes from 4 to 12.

I see.

>=20
> PS I've only noticed it now but after this patch inten_fall_shift becom=
es
> unused and can be removed.
>=20


Then we should remove it.



> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>=20
>>>
>>> Best regards,
>>> --
>>> Bartlomiej Zolnierkiewicz
>>> Samsung R&D Institute Poland
>>> Samsung Electronics
>>>
>>> On Wednesday, October 09, 2013 05:38:27 PM Naveen Krishna Chatradhi w=
rote:
>>>> The FALL interrupt related en, status bits are available at an offse=
t of
>>>> 16 on INTEN, INTSTAT registers and at an offset of
>>>> 12 on INTCLEAR register.
>>>>
>>>> This patch corrects the same for exyns5250 and exynos5440
>>>>
>>>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>>> ---
>>>> Changes since v1:
>>>> Changes since v2:
>>>> Changes since v3:
>>>>   None
>>>>
>>>>  drivers/thermal/samsung/exynos_tmu.c      |    2 +-
>>>>  drivers/thermal/samsung/exynos_tmu.h      |    2 ++
>>>>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
>>>>  drivers/thermal/samsung/exynos_tmu_data.h |    3 ++-
>>>>  4 files changed, 7 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/=
samsung/exynos_tmu.c
>>>> index b43afda..af69209 100644
>>>> --- a/drivers/thermal/samsung/exynos_tmu.c
>>>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>>>> @@ -265,7 +265,7 @@ skip_calib_data:
>>>>  				data->base + reg->threshold_th1);
>>>> =20
>>>>  		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
>>>> -			(reg->inten_fall_mask << reg->inten_fall_shift),
>>>> +			(reg->inten_fall_mask << reg->intclr_fall_shift),
>>>>  				data->base + reg->tmu_intclear);
>>>> =20
>>>>  		/* if last threshold limit is also present */
>>>> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/=
samsung/exynos_tmu.h
>>>> index b364c9e..7c6c34a 100644
>>>> --- a/drivers/thermal/samsung/exynos_tmu.h
>>>> +++ b/drivers/thermal/samsung/exynos_tmu.h
>>>> @@ -134,6 +134,7 @@ enum soc_type {
>>>>   * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
>>>>   * @tmu_intstat: Register containing the interrupt status values.
>>>>   * @tmu_intclear: Register for clearing the raised interrupt status=
=2E
>>>> + * @intclr_fall_shift: shift bits for interrupt clear fall 0
>>>>   * @emul_con: TMU emulation controller register.
>>>>   * @emul_temp_shift: shift bits of emulation temperature.
>>>>   * @emul_time_shift: shift bits of emulation time.
>>>> @@ -204,6 +205,7 @@ struct exynos_tmu_registers {
>>>>  	u32	tmu_intstat;
>>>> =20
>>>>  	u32	tmu_intclear;
>>>> +	u32	intclr_fall_shift;
>>>> =20
>>>>  	u32	emul_con;
>>>>  	u32	emul_temp_shift;
>>>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/the=
rmal/samsung/exynos_tmu_data.c
>>>> index 9002499..23fea23 100644
>>>> --- a/drivers/thermal/samsung/exynos_tmu_data.c
>>>> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
>>>> @@ -122,6 +122,7 @@ static const struct exynos_tmu_registers exynos5=
250_tmu_registers =3D {
>>>>  	.inten_fall0_shift =3D EXYNOS_TMU_INTEN_FALL0_SHIFT,
>>>>  	.tmu_intstat =3D EXYNOS_TMU_REG_INTSTAT,
>>>>  	.tmu_intclear =3D EXYNOS_TMU_REG_INTCLEAR,
>>>> +	.intclr_fall_shift =3D EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
>>>>  	.emul_con =3D EXYNOS_EMUL_CON,
>>>>  	.emul_temp_shift =3D EXYNOS_EMUL_DATA_SHIFT,
>>>>  	.emul_time_shift =3D EXYNOS_EMUL_TIME_SHIFT,
>>>> @@ -210,6 +211,7 @@ static const struct exynos_tmu_registers exynos5=
440_tmu_registers =3D {
>>>>  	.inten_fall0_shift =3D EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
>>>>  	.tmu_intstat =3D EXYNOS5440_TMU_S0_7_IRQ,
>>>>  	.tmu_intclear =3D EXYNOS5440_TMU_S0_7_IRQ,
>>>> +	.intclr_fall_shift =3D EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
>>>>  	.tmu_irqstatus =3D EXYNOS5440_TMU_IRQ_STATUS,
>>>>  	.emul_con =3D EXYNOS5440_TMU_S0_7_DEBUG,
>>>>  	.emul_temp_shift =3D EXYNOS_EMUL_DATA_SHIFT,
>>>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/the=
rmal/samsung/exynos_tmu_data.h
>>>> index dc7feb5..8788a87 100644
>>>> --- a/drivers/thermal/samsung/exynos_tmu_data.h
>>>> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
>>>> @@ -69,9 +69,10 @@
>>>>  #define EXYNOS_TMU_RISE_INT_MASK	0x111
>>>>  #define EXYNOS_TMU_RISE_INT_SHIFT	0
>>>>  #define EXYNOS_TMU_FALL_INT_MASK	0x111
>>>> -#define EXYNOS_TMU_FALL_INT_SHIFT	12
>>>> +#define EXYNOS_TMU_FALL_INT_SHIFT	16
>>>>  #define EXYNOS_TMU_CLEAR_RISE_INT	0x111
>>>>  #define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
>>>> +#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT	12
>>>>  #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
>>>>  #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
>>>>  #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--GSXQ8SNS86O1d1FtJcx2I0wPRb8uFmrOE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJb/RsACgkQCXcVR3XQvP1GEwD/Xmj3BdF4Tpj/A1E8EM/3Qj9O
sEbFT0MMBdYMhRtY9iwBAJTnZhb+q9n5ozn/0kGznl9JnXeuslcJ6Ghxl+ObaMMO
=gGLT
-----END PGP SIGNATURE-----

--GSXQ8SNS86O1d1FtJcx2I0wPRb8uFmrOE--
