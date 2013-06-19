Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934658Ab3FSMMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:12:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52506 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934297Ab3FSMMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:12:42 -0400
Message-ID: <51C1A012.7050809@ti.com>
Date: Wed, 19 Jun 2013 08:12:02 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <benoit.cousson@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        J Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH 1/1] arm: add bandgap DT entry for OMAP5
References: <1371609398-26454-1-git-send-email-eduardo.valentin@ti.com> <51C18990.8000109@ti.com>
In-Reply-To: <51C18990.8000109@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2MIMGNGBWQONRSXIXJEWA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2MIMGNGBWQONRSXIXJEWA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 19-06-2013 06:36, Benoit Cousson wrote:
> Hi Eduardo,
>=20
> On 06/18/2013 09:36 PM, Eduardo Valentin wrote:
>> Add bandgap device DT entry for OMAP5 dtsi.
>>
>> Cc: "Beno=C3=AEt Cousson" <b-cousson@ti.com>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: linux-omap@vger.kernel.org
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
>> Signed-off-by: J Keerthy <j-keerthy@ti.com>
>> ---
>>   arch/arm/boot/dts/omap5.dtsi | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>> ---
>>
>> Benoit,
>>
>> Sorry for this very late request, but can you please consider
>> these patches for 3.11 still?
>>
>> I completely forgot to send these on my "Enable TI SoC thermal driver"=
 series.
>>
>> All best,
>>
>> Eduardo
>>
>> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dt=
si
>> index 2ad63c4..5ede6e1 100644
>> --- a/arch/arm/boot/dts/omap5.dtsi
>> +++ b/arch/arm/boot/dts/omap5.dtsi
>> @@ -615,5 +615,13 @@
>>   			interrupts =3D <0 80 0x4>;
>>   			ti,hwmods =3D "wd_timer2";
>>   		};
>=20
> missing blank line
>=20
>> +		bandgap {
>=20
> You must use the first address in that case. Otherwise DT will affect a=
 random number and provide a non-standard device name. That does not real=
ly matter in theory, but it will looks ugly in the /sys/devices list.
>=20
>> +			reg =3D <0x4a0021e0 0xc
>> +				0x4a00232c 0xc
>> +				0x4a002380 0x2c
>> +				0x4a0023C0 0x3c>;
>> +				interrupts =3D <0 126 4>; /* talert */
>=20
> Not well aligned and should use the macros.
>=20
>> +			compatible =3D "ti,omap5430-bandgap";
>> +		};
>>   	};
>>   };
>>
>=20
> I did the update for you :-)
>=20
> Here is the version I've just applied.
>=20
> Benoit
>=20
>=20
>>From f0160bb93467e22f2f8bc77591dcd7e35cdee999 Mon Sep 17 00:00:00 2001
> From: Eduardo Valentin <eduardo.valentin@ti.com>
> Date: Tue, 18 Jun 2013 22:36:38 -0400
> Subject: [PATCH] ARM: dts: Add bandgap DT entry for OMAP5
>=20
> Add bandgap device DT entry for OMAP5 dtsi.
>=20
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> Signed-off-by: Benoit Cousson <benoit.cousson@linaro.org>
> ---
>  arch/arm/boot/dts/omap5.dtsi |    9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dts=
i
> index accab62..47693c9 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -696,5 +696,14 @@
>  				interrupts =3D <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
>  			};
>  		};
> +
> +		bandgap@4a0021e0 {
> +			reg =3D <0x4a0021e0 0xc
> +			       0x4a00232c 0xc
> +			       0x4a002380 0x2c
> +			       0x4a0023C0 0x3c>;
> +			interrupts =3D <GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH>;
> +			compatible =3D "ti,omap5430-bandgap";
> +		};
>  	};
>  };
>=20

Looks good to me.

Tks Benoit!

--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2MIMGNGBWQONRSXIXJEWA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHBoBIACgkQCXcVR3XQvP0+FQEAm/fHb0/HoHu/hnFAVQwuQQbT
nylEaeFACipMg44SpMYA/0j27UnQ2QFwuhLMNRwrazuw8n/dRIvhwJiu9eYoo1W4
=jxcH
-----END PGP SIGNATURE-----

------enig2MIMGNGBWQONRSXIXJEWA--
