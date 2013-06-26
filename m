Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab3FZJ6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:58:01 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:34094 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3FZJ57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:57:59 -0400
Message-ID: <51CABB24.7010009@monstr.eu>
Date: Wed, 26 Jun 2013 11:57:56 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk/zynq/clkc: Add dedicated spinlock for the SWDT
References: <1371506626-3892-1-git-send-email-soren.brinkmann@xilinx.com> <fe16e203-47cf-4465-8a9d-3c3e516d2d5e@VA3EHSMHS028.ehs.local>
In-Reply-To: <fe16e203-47cf-4465-8a9d-3c3e516d2d5e@VA3EHSMHS028.ehs.local>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2QIDLEAGDSIAPNVJWXAIV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2QIDLEAGDSIAPNVJWXAIV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/24/2013 05:58 PM, S=C3=B6ren Brinkmann wrote:
> ping?
>=20
> On Mon, Jun 17, 2013 at 03:03:46PM -0700, Soren Brinkmann wrote:
>> The clk_mux for the system watchdog timer reused the register lock
>> dedicated to the Ethernet module - for no apparent reason.
>> Add a lock dedicated to the SWDT's clock register to remove this
>> wrong dependency.
>>
>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>> ---
>> I don't know how this slipped in...
>> Anyway, the fix depends on armsoc/zynq/clk.
>>
>> 	S=C3=B6ren
>>
>>  drivers/clk/zynq/clkc.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
>> index 5c205b6..515a573 100644
>> --- a/drivers/clk/zynq/clkc.c
>> +++ b/drivers/clk/zynq/clkc.c
>> @@ -71,6 +71,7 @@ static DEFINE_SPINLOCK(armpll_lock);
>>  static DEFINE_SPINLOCK(ddrpll_lock);
>>  static DEFINE_SPINLOCK(iopll_lock);
>>  static DEFINE_SPINLOCK(armclk_lock);
>> +static DEFINE_SPINLOCK(swdtclk_lock);
>>  static DEFINE_SPINLOCK(ddrclk_lock);
>>  static DEFINE_SPINLOCK(dciclk_lock);
>>  static DEFINE_SPINLOCK(gem0clk_lock);
>> @@ -293,7 +294,7 @@ static void __init zynq_clk_setup(struct device_no=
de *np)
>>  	}
>>  	clks[swdt] =3D clk_register_mux(NULL, clk_output_name[swdt],
>>  			swdt_ext_clk_mux_parents, 2, CLK_SET_RATE_PARENT,
>> -			SLCR_SWDT_CLK_SEL, 0, 1, 0, &gem0clk_lock);
>> +			SLCR_SWDT_CLK_SEL, 0, 1, 0, &swdtclk_lock);
>> =20
>>  	/* DDR clocks */
>>  	clk =3D clk_register_divider(NULL, "ddr2x_div", "ddrpll", 0,
>> --=20
>> 1.8.3.1

Applied.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2QIDLEAGDSIAPNVJWXAIV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHKuyQACgkQykllyylKDCGwjACfdZghj+EtV5R1KSpeATQNlVgL
Zn4AnRdr8ueHAn1aFdlb16cfaJ2tr75H
=DFGv
-----END PGP SIGNATURE-----

------enig2QIDLEAGDSIAPNVJWXAIV--
