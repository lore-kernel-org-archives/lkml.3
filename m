Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3FZJ5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:57:51 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:55977 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3FZJ5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:57:50 -0400
Message-ID: <51CABB1B.6010704@monstr.eu>
Date: Wed, 26 Jun 2013 11:57:47 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet
 muxes
References: <1371509260-2340-1-git-send-email-soren.brinkmann@xilinx.com> <b79e12d1-dd4b-407c-b3c1-46d7d66292e8@CO1EHSMHS017.ehs.local>
In-Reply-To: <b79e12d1-dd4b-407c-b3c1-46d7d66292e8@CO1EHSMHS017.ehs.local>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2HGIEADEKKBFBGHCVQHME"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2HGIEADEKKBFBGHCVQHME
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/24/2013 05:58 PM, S=C3=B6ren Brinkmann wrote:
> ping?
>=20
> On Mon, Jun 17, 2013 at 03:47:40PM -0700, Soren Brinkmann wrote:
>> Zynq's Ethernet clocks are created by the following hierarchy:
>> 	mux0 ---> div0 ---> div1 ---> mux1 ---> gate
>> Rate change requests on the gate have to propagate all the way up to
>> div0 to properly leverage all dividers. Mux1 was missing the
>> CLK_SET_RATE_PARENT flag, which is required to achieve this.
>>
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> ---
>>  drivers/clk/zynq/clkc.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
>> index 515a573..089d3e3 100644
>> --- a/drivers/clk/zynq/clkc.c
>> +++ b/drivers/clk/zynq/clkc.c
>> @@ -365,8 +365,9 @@ static void __init zynq_clk_setup(struct device_no=
de *np)
>>  			CLK_SET_RATE_PARENT, SLCR_GEM0_CLK_CTRL, 20, 6,
>>  			CLK_DIVIDER_ONE_BASED | CLK_DIVIDER_ALLOW_ZERO,
>>  			&gem0clk_lock);
>> -	clk =3D clk_register_mux(NULL, "gem0_emio_mux", gem0_mux_parents, 2,=
 0,
>> -			SLCR_GEM0_CLK_CTRL, 6, 1, 0, &gem0clk_lock);
>> +	clk =3D clk_register_mux(NULL, "gem0_emio_mux", gem0_mux_parents, 2,=

>> +			CLK_SET_RATE_PARENT, SLCR_GEM0_CLK_CTRL, 6, 1, 0,
>> +			&gem0clk_lock);
>>  	clks[gem0] =3D clk_register_gate(NULL, clk_output_name[gem0],
>>  			"gem0_emio_mux", CLK_SET_RATE_PARENT,
>>  			SLCR_GEM0_CLK_CTRL, 0, 0, &gem0clk_lock);
>> @@ -387,8 +388,9 @@ static void __init zynq_clk_setup(struct device_no=
de *np)
>>  			CLK_SET_RATE_PARENT, SLCR_GEM1_CLK_CTRL, 20, 6,
>>  			CLK_DIVIDER_ONE_BASED | CLK_DIVIDER_ALLOW_ZERO,
>>  			&gem1clk_lock);
>> -	clk =3D clk_register_mux(NULL, "gem1_emio_mux", gem1_mux_parents, 2,=
 0,
>> -			SLCR_GEM1_CLK_CTRL, 6, 1, 0, &gem1clk_lock);
>> +	clk =3D clk_register_mux(NULL, "gem1_emio_mux", gem1_mux_parents, 2,=

>> +			CLK_SET_RATE_PARENT, SLCR_GEM1_CLK_CTRL, 6, 1, 0,
>> +			&gem1clk_lock);
>>  	clks[gem1] =3D clk_register_gate(NULL, clk_output_name[gem1],
>>  			"gem1_emio_mux", CLK_SET_RATE_PARENT,
>>  			SLCR_GEM1_CLK_CTRL, 0, 0, &gem1clk_lock);
>> --=20
>> 1.8.3.1
>>

Applied.

Thanks,
Michal




--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2HGIEADEKKBFBGHCVQHME
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHKuxsACgkQykllyylKDCE8pgCeMrtcoK5CBrrcKrjgfMyX6Bhq
23EAnRuME71kL8E8So+xc7JtdwnVwOte
=tf+k
-----END PGP SIGNATURE-----

------enig2HGIEADEKKBFBGHCVQHME--
