Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab3J3OXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:23:30 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:49444 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab3J3OX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:23:29 -0400
Message-ID: <5271165A.4050509@monstr.eu>
Date: Wed, 30 Oct 2013 15:23:22 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Michal Simek <michal.simek@xilinx.com>, Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mm: Fix ECC mem policy printk
References: <8986e8f1a3761e45a7927bdb0e54393c9155e6bf.1383137171.git.michal.simek@xilinx.com> <20131030130728.GA16735@n2100.arm.linux.org.uk>
In-Reply-To: <20131030130728.GA16735@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="h31faIHsV7BVcWGSG8oSGa1kpdXJF4TPC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--h31faIHsV7BVcWGSG8oSGa1kpdXJF4TPC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/30/2013 02:07 PM, Russell King - ARM Linux wrote:
> On Wed, Oct 30, 2013 at 01:46:18PM +0100, Michal Simek wrote:
>> Russell, Will: We discussed this at KS that will be good
>> to rephrase it or have different logic around this.
>> I am not sure if we can also test that this bit is
>> implemented by particular SoC or not.
>>
>> Maybe logic should be that if SoC uses this bit
>> that message is shown in origin format to declare
>> that ECC is enabled or disabled.
>> When SoC doesn't implement it then do not show this message.
>=20
> This is not quite what I meant - by making the change you have, you als=
o
> omit to print the data cache policy.
>=20
>> @@ -556,8 +556,9 @@ static void __init build_mem_type_table(void)
>>  		mem_types[MT_CACHECLEAN].prot_sect |=3D PMD_SECT_WB;
>>  		break;
>>  	}
>> -	printk("Memory policy: ECC %sabled, Data cache %s\n",
>> -		ecc_mask ? "en" : "dis", cp->policy);
>> +	if (ecc_mask)
>> +		pr_info("Memory policy: ECC enabled, Data cache %s\n",
>> +			cp->policy);
>=20
> 	pr_info("Memory policy: %sData cache %s\n",
> 		ecc_mask ? "ECC enabled, " : "", cp->policy);
>=20
> is more what I was suggesting.

If this is what you would like to see it there, I am fine with that too.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--h31faIHsV7BVcWGSG8oSGa1kpdXJF4TPC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJxFloACgkQykllyylKDCH88gCgjBpLZNwcxBMVvWor6CfneQk7
51IAmwTeE/v/DMQCSperzMqvhKOQ0vZO
=gx3S
-----END PGP SIGNATURE-----

--h31faIHsV7BVcWGSG8oSGa1kpdXJF4TPC--
