Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaJFRzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 13:55:04 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:65358 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaJFRzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:55:01 -0400
Message-ID: <5432D76D.70004@monstr.eu>
Date: Mon, 06 Oct 2014 19:54:53 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: linux-arm-kernel@lists.infradead.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: zynq: Extend SLCR driver to read OCM configuration
References: <565908c2d70764e281d6a9b28d9599cea87823a3.1412595859.git.michal.simek@xilinx.com> <586ef67a22005316fd65cebbbd4019a8a2094e07.1412595859.git.michal.simek@xilinx.com> <30d758b569504e88a9b4a999f08be17b@BN1AFFO11FD055.protection.gbl>
In-Reply-To: <30d758b569504e88a9b4a999f08be17b@BN1AFFO11FD055.protection.gbl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="jMWP6AeG5EoHTRSbvW1OnCgR2vvKLAVFV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jMWP6AeG5EoHTRSbvW1OnCgR2vvKLAVFV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Soren,

On 10/06/2014 05:59 PM, S=C3=B6ren Brinkmann wrote:
> Hi Michal,
>=20
> On Mon, 2014-10-06 at 01:44PM +0200, Michal Simek wrote:
>> Get OCM configuration from SLCR.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>>  arch/arm/mach-zynq/slcr.c | 15 +++++++++++++++
>>  include/soc/zynq/common.h |  1 +
>>  2 files changed, 16 insertions(+)
>>
>> diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
>> index cb7c46165728..0c3e45090c09 100644
>> --- a/arch/arm/mach-zynq/slcr.c
>> +++ b/arch/arm/mach-zynq/slcr.c
>> @@ -27,6 +27,7 @@
>>  #define SLCR_A9_CPU_RST_CTRL_OFFSET	0x244 /* CPU Software Reset Contr=
ol */
>>  #define SLCR_REBOOT_STATUS_OFFSET	0x258 /* PS Reboot Status */
>>  #define SLCR_PSS_IDCODE			0x530 /* PS IDCODE */
>> +#define SLCR_OCM_CFG_OFFSET		0x910 /* OCM Address Mapping */
>>
>>  #define SLCR_UNLOCK_MAGIC		0xDF0D
>>  #define SLCR_A9_CPU_CLKSTOP		0x10
>> @@ -126,6 +127,20 @@ void zynq_slcr_system_reset(void)
>>  }
>>
>>  /**
>> + * zynq_slcr_get_ocm_config - Get SLCR OCM config
>> + *
>> + * Return:	OCM config bits
>> + */
>> +u32 zynq_slcr_get_ocm_config(void)
>> +{
>> +	u32 val;
>> +
>> +	zynq_slcr_read(&val, SLCR_OCM_CFG_OFFSET);
>> +
>> +	return val;
>> +}
>=20
> a different idea would be, instead of creating this specific API call
> for the OCMC to let the OCMC driver use regmap and making git a subnode=

> of the SLCR.
> In the long run that might be a better option otherwise we'll end up
> with a whole bunch of zynq_slcr_get_foo() calls for each driver that
> needs to read an SLCR register.

yes using regmap is also possible and I know that.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--jMWP6AeG5EoHTRSbvW1OnCgR2vvKLAVFV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQy13EACgkQykllyylKDCFO2QCeJ9Viw3R1YV014xBplS5hujeh
q24AoJL0zKJA5pyoKSAwM5OETfPppxwJ
=NfzA
-----END PGP SIGNATURE-----

--jMWP6AeG5EoHTRSbvW1OnCgR2vvKLAVFV--
