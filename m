Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaLAOYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:24:44 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35238 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbaLAOYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:24:42 -0500
Message-ID: <547C7A24.8090403@monstr.eu>
Date: Mon, 01 Dec 2014 15:24:36 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>, Jingoo Han <jg1.han@samsung.com>,
        Sandeep Nair <sandeep_n@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@gmail.com>,
        Andy Gross <agross@codeaurora.org>,
        Thierry Reding <treding@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] ARM: zynq: Add OCM controller driver
References: <cover.1415962281.git.michal.simek@xilinx.com>	<6741d995fbec801d795c5db481e39425bd912f8a.1415962281.git.michal.simek@xilinx.com>	<CACRpkdbZ8Pwy=04dhJq5ONZ1B-SQK1f=eLZjjCDmV7UQ0aHduA@mail.gmail.com>	<857cab03bd6445c59cc345349a00f67c@BL2FFO11FD010.protection.gbl> <CACRpkdbL=yOwjC7j=eacg9K2Mb3rwcKy3b0F8y2H9Nz8RsRRcg@mail.gmail.com>
In-Reply-To: <CACRpkdbL=yOwjC7j=eacg9K2Mb3rwcKy3b0F8y2H9Nz8RsRRcg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2AsdAsqHF2xPXskKiCUTaaq0noPXHl39x"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2AsdAsqHF2xPXskKiCUTaaq0noPXHl39x
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/28/2014 04:35 PM, Linus Walleij wrote:
> On Thu, Nov 27, 2014 at 2:57 PM, Michal Simek <michal.simek@xilinx.com>=
 wrote:
>> On 11/27/2014 02:20 PM, Linus Walleij wrote:
>>> On Fri, Nov 14, 2014 at 11:52 AM, Michal Simek <michal.simek@xilinx.c=
om> wrote:
>=20
>>> (...)
>>>> +       zynq_ocmc->pool =3D devm_gen_pool_create(&pdev->dev,
>>>> +                                              ilog2(ZYNQ_OCMC_GRANU=
LARITY),
>>>> +                                              -1);
>>>
>>> Do this:
>>>
>>> #include <linux/sizes.h>
>>>
>>> zynq_ocmc->pool =3D devm_gen_pool_create(&pdev->dev,
>>>                                        ilog2(SZ_64K),
>>>                                        -1);
>>>
>>> And get rid of the #define for ZYNQ_OCMC_GRANULARITY
>>
>> ilog2 from 32 is different to ilog2 from ilog2 from 0x10000.
>=20
> Bah I misread the code, forget this comment.
>=20
> Maybe it's more like I wanted
>=20
> +#define ZYNQ_OCMC_BLOCK_SIZE   0x10000
>=20
> To be replaced with SZ_64K
>=20
> But it's a petty detail anyway.

I have fixed it.

>> Do you have any opinion regarding calling zynq_slcr_get_ocm_config()?
>>
>> Is it better to expose slcr this interface to drivers?
>> Or use regmap and read this value directly?
>=20
> Depends on what provides that call. The pattern I usually follow
> is to expose the mixed-registers range as a syscon device
> using drivers/mfd/syscon.c and then use one of the methods from
> <linux/mfd/syscon.h> to look up a reference to the regmap and
> use it to access misc registers.

I have tried it and I can just use it without any problem.
I have sent v5 with origin version but in cover letter there
is a code for that.


>> Also I do read for CONFIG_SMP case jump trampoline size - maybe
>> you can have better idea how this can be done.
>=20
> No I have no clue about that... :(

ok - fair enough. One option is to keep it as is. The second
option is to allocate any hardcoded size or size passed via DT.
But run-time detection is the best IMHO.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--2AsdAsqHF2xPXskKiCUTaaq0noPXHl39x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlR8eiQACgkQykllyylKDCGcpgCcDfe1o5NRLnIkE6pvyCEKFFV/
P8QAnRMffxdxjlrYP98UeYu9DPEMZ5N5
=5bYS
-----END PGP SIGNATURE-----

--2AsdAsqHF2xPXskKiCUTaaq0noPXHl39x--
