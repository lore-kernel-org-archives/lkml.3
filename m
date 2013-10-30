Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3J3OcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:32:14 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:33543 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab3J3OcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:32:12 -0400
Message-ID: <52711869.60703@monstr.eu>
Date: Wed, 30 Oct 2013 15:32:09 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mm: Fix ECC mem policy printk
References: <8986e8f1a3761e45a7927bdb0e54393c9155e6bf.1383137171.git.michal.simek@xilinx.com> <20131030130728.GA16735@n2100.arm.linux.org.uk> <5271165A.4050509@monstr.eu>
In-Reply-To: <5271165A.4050509@monstr.eu>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="0uLaPqgWKDPwpAd6CgX1jN0RMVwmFv20Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0uLaPqgWKDPwpAd6CgX1jN0RMVwmFv20Q
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/30/2013 03:23 PM, Michal Simek wrote:
> On 10/30/2013 02:07 PM, Russell King - ARM Linux wrote:
>> On Wed, Oct 30, 2013 at 01:46:18PM +0100, Michal Simek wrote:
>>> Russell, Will: We discussed this at KS that will be good
>>> to rephrase it or have different logic around this.
>>> I am not sure if we can also test that this bit is
>>> implemented by particular SoC or not.
>>>
>>> Maybe logic should be that if SoC uses this bit
>>> that message is shown in origin format to declare
>>> that ECC is enabled or disabled.
>>> When SoC doesn't implement it then do not show this message.
>>
>> This is not quite what I meant - by making the change you have, you al=
so
>> omit to print the data cache policy.
>>
>>> @@ -556,8 +556,9 @@ static void __init build_mem_type_table(void)
>>>  		mem_types[MT_CACHECLEAN].prot_sect |=3D PMD_SECT_WB;
>>>  		break;
>>>  	}
>>> -	printk("Memory policy: ECC %sabled, Data cache %s\n",
>>> -		ecc_mask ? "en" : "dis", cp->policy);
>>> +	if (ecc_mask)
>>> +		pr_info("Memory policy: ECC enabled, Data cache %s\n",
>>> +			cp->policy);
>>
>> 	pr_info("Memory policy: %sData cache %s\n",
>> 		ecc_mask ? "ECC enabled, " : "", cp->policy);
>>
>> is more what I was suggesting.
>=20
> If this is what you would like to see it there, I am fine with that too=
=2E

btw: passing ecc=3Don through command line will caused that "ECC enabled"=
 message
will be there even on systems which don't implement this bit.
It is just side effect for both these solutions.
Isn't there any easy way to test if this bit is implemented or not just b=
y setting
it up and clear it?

Thanks,
Michal
--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--0uLaPqgWKDPwpAd6CgX1jN0RMVwmFv20Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJxGGkACgkQykllyylKDCGoCgCfXbwbdSojLxaciM7hUyzEVzQN
CZgAnRHmMPd5P5nD2Ajn0UcwPQ7UeJga
=XjUt
-----END PGP SIGNATURE-----

--0uLaPqgWKDPwpAd6CgX1jN0RMVwmFv20Q--
