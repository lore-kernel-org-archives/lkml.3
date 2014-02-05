Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaBEPwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:52:09 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:62764 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBEPwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:52:08 -0500
Message-ID: <52F25E22.6010801@monstr.eu>
Date: Wed, 05 Feb 2014 16:52:02 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Stephen Warren <swarren@nvidia.com>,
        James Hogan <james.hogan@imgtec.com>,
        Felipe Pena <felipensp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: zynq: Move of_clk_init from clock driver
References: <572af6e4eaaaa1c74ea62364f8fa7ac5834cc754.1391612175.git.michal.simek@xilinx.com> <4e03e3ec-2fc7-40fc-a2cc-4a6c64379559@CO1EHSMHS025.ehs.local>
In-Reply-To: <4e03e3ec-2fc7-40fc-a2cc-4a6c64379559@CO1EHSMHS025.ehs.local>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="1nr78CVnopbWfF5wwFx4q2RPlpjx7NuTc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1nr78CVnopbWfF5wwFx4q2RPlpjx7NuTc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 02/05/2014 04:41 PM, S=C3=B6ren Brinkmann wrote:
> On Wed, Feb 05, 2014 at 03:56:37PM +0100, Michal Simek wrote:
>> Move of_clk_init() from clock driver to enable
>> options not to use zynq clock driver.
>> Use for example fixed clock setting.
> What is the use-case? Zynq w/o this driver makes no sense, IMHO. And
> even if you wanna fake clocks, why would this driver prevent it? Just
> replace all the input clocks with different ones and don't care about
> what this driver does?

One case is supervisor for example.

>=20
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>> Based on http://www.spinics.net/lists/arm-kernel/msg298287.html
>> series
>>
>> ---
>>  arch/arm/mach-zynq/common.c | 1 +
>>  drivers/clk/zynq/clkc.c     | 2 --
>>  2 files changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c=

>> index 93ea19b..8df35f3 100644
>> --- a/arch/arm/mach-zynq/common.c
>> +++ b/arch/arm/mach-zynq/common.c
>> @@ -68,6 +68,7 @@ static void __init zynq_timer_init(void)
>>  	zynq_early_slcr_init();
>>
>>  	zynq_clock_init();
>> +	of_clk_init(NULL);
> Now you have two clock init functions...

If I have two clock init functions now, what I had before?
You were calling of_clk_init from zynq_clock_init.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--1nr78CVnopbWfF5wwFx4q2RPlpjx7NuTc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLyXiIACgkQykllyylKDCFPTgCfRm01UGvdQIGcS4jmnhoNBwqi
80cAniFxHKaG/UJWBvVmdJtxmFv303PK
=NmH0
-----END PGP SIGNATURE-----

--1nr78CVnopbWfF5wwFx4q2RPlpjx7NuTc--
