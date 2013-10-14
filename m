Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab3JNN45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:56:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48059 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab3JNN4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:56:53 -0400
Message-ID: <525BF815.2030604@ti.com>
Date: Mon, 14 Oct 2013 09:56:37 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        <linux-pm@vger.kernel.org>, <naveenkrishna.ch@gmail.com>,
        <rui.zhang@intel.com>, <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.daniel@samsung.com>, <kgene.kim@samsung.com>,
        <devicetree@vger.kernel.org>, Lukasz Majewski <l.majewski@samsung.com>
Subject: Re: [PATCH 1/3 v4] thermal: samsung: correct the fall interrupt en,
 status bit fields
References: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com> <1381320509-23967-1-git-send-email-ch.naveen@samsung.com> <2386580.3V2pzai3k2@amdc1032>
In-Reply-To: <2386580.3V2pzai3k2@amdc1032>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="alS4v14A89j7t0ojtcWorSOPkkrtwOgSA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--alS4v14A89j7t0ojtcWorSOPkkrtwOgSA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Naveen,

On 09-10-2013 10:03, Bartlomiej Zolnierkiewicz wrote:
>=20
> Hi,
>=20
> All patches (#1-#3) look good to me, FWIW you can add:
>=20
> 	Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>=20
> Please note that (at least) patch #3 conflicts with Lukasz's EXYNOS4412=

> fixup patchset:
>=20
> 	https://lkml.org/lkml/2013/10/9/35
>=20
> It is up to Eduardo to resolve this but it probably would be better to
> merge EXYNOS4412 fixes first and then add EXYNOS5420 support. This woul=
d
> require you to port patch #3 over Lukasz's patchset though.
>=20

Please rebase your patch set on top of Lukasz'. There are conflicts
while applying patch 3. Please also compile test it before posting,
check comment I made on patch 2.

> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>=20
> On Wednesday, October 09, 2013 05:38:27 PM Naveen Krishna Chatradhi wro=
te:
>> The FALL interrupt related en, status bits are available at an offset =
of
>> 16 on INTEN, INTSTAT registers and at an offset of
>> 12 on INTCLEAR register.
>>
>> This patch corrects the same for exyns5250 and exynos5440
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> ---
>> Changes since v1:
>> Changes since v2:
>> Changes since v3:
>>   None
>>
>>  drivers/thermal/samsung/exynos_tmu.c      |    2 +-
>>  drivers/thermal/samsung/exynos_tmu.h      |    2 ++
>>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
>>  drivers/thermal/samsung/exynos_tmu_data.h |    3 ++-
>>  4 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sa=
msung/exynos_tmu.c
>> index b43afda..af69209 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -265,7 +265,7 @@ skip_calib_data:
>>  				data->base + reg->threshold_th1);
>> =20
>>  		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
>> -			(reg->inten_fall_mask << reg->inten_fall_shift),
>> +			(reg->inten_fall_mask << reg->intclr_fall_shift),
>>  				data->base + reg->tmu_intclear);
>> =20
>>  		/* if last threshold limit is also present */
>> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sa=
msung/exynos_tmu.h
>> index b364c9e..7c6c34a 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.h
>> +++ b/drivers/thermal/samsung/exynos_tmu.h
>> @@ -134,6 +134,7 @@ enum soc_type {
>>   * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
>>   * @tmu_intstat: Register containing the interrupt status values.
>>   * @tmu_intclear: Register for clearing the raised interrupt status.
>> + * @intclr_fall_shift: shift bits for interrupt clear fall 0
>>   * @emul_con: TMU emulation controller register.
>>   * @emul_temp_shift: shift bits of emulation temperature.
>>   * @emul_time_shift: shift bits of emulation time.
>> @@ -204,6 +205,7 @@ struct exynos_tmu_registers {
>>  	u32	tmu_intstat;
>> =20
>>  	u32	tmu_intclear;
>> +	u32	intclr_fall_shift;
>> =20
>>  	u32	emul_con;
>>  	u32	emul_temp_shift;
>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therm=
al/samsung/exynos_tmu_data.c
>> index 9002499..23fea23 100644
>> --- a/drivers/thermal/samsung/exynos_tmu_data.c
>> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
>> @@ -122,6 +122,7 @@ static const struct exynos_tmu_registers exynos525=
0_tmu_registers =3D {
>>  	.inten_fall0_shift =3D EXYNOS_TMU_INTEN_FALL0_SHIFT,
>>  	.tmu_intstat =3D EXYNOS_TMU_REG_INTSTAT,
>>  	.tmu_intclear =3D EXYNOS_TMU_REG_INTCLEAR,
>> +	.intclr_fall_shift =3D EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
>>  	.emul_con =3D EXYNOS_EMUL_CON,
>>  	.emul_temp_shift =3D EXYNOS_EMUL_DATA_SHIFT,
>>  	.emul_time_shift =3D EXYNOS_EMUL_TIME_SHIFT,
>> @@ -210,6 +211,7 @@ static const struct exynos_tmu_registers exynos544=
0_tmu_registers =3D {
>>  	.inten_fall0_shift =3D EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
>>  	.tmu_intstat =3D EXYNOS5440_TMU_S0_7_IRQ,
>>  	.tmu_intclear =3D EXYNOS5440_TMU_S0_7_IRQ,
>> +	.intclr_fall_shift =3D EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
>>  	.tmu_irqstatus =3D EXYNOS5440_TMU_IRQ_STATUS,
>>  	.emul_con =3D EXYNOS5440_TMU_S0_7_DEBUG,
>>  	.emul_temp_shift =3D EXYNOS_EMUL_DATA_SHIFT,
>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/therm=
al/samsung/exynos_tmu_data.h
>> index dc7feb5..8788a87 100644
>> --- a/drivers/thermal/samsung/exynos_tmu_data.h
>> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
>> @@ -69,9 +69,10 @@
>>  #define EXYNOS_TMU_RISE_INT_MASK	0x111
>>  #define EXYNOS_TMU_RISE_INT_SHIFT	0
>>  #define EXYNOS_TMU_FALL_INT_MASK	0x111
>> -#define EXYNOS_TMU_FALL_INT_SHIFT	12
>> +#define EXYNOS_TMU_FALL_INT_SHIFT	16
>>  #define EXYNOS_TMU_CLEAR_RISE_INT	0x111
>>  #define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
>> +#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT	12
>>  #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
>>  #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
>>  #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--alS4v14A89j7t0ojtcWorSOPkkrtwOgSA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJb+BgACgkQCXcVR3XQvP33bAEA+TvC0CzHsDA0FOFZiSffXNo4
sEnJ+BhLsXeiA9wyds4A/0kR9MLg89ZKsceLQuH6xf73QjUm9+Rb2wuFkMif/TJ1
=BQrI
-----END PGP SIGNATURE-----

--alS4v14A89j7t0ojtcWorSOPkkrtwOgSA--
