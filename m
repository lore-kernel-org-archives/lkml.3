Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3EaHjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 03:39:19 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:37123 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3EaHjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 03:39:13 -0400
Message-ID: <51A8539E.3000702@monstr.eu>
Date: Fri, 31 May 2013 09:39:10 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 2/3] video: xilinxfb: Do not use out_be32 IO function
References: <27e53d5633766ab0dc1ac492023d5a0d0199e3aa.1369906849.git.michal.simek@xilinx.com> <a15de155a3f32fc1416833df1b281db05d347541.1369906849.git.michal.simek@xilinx.com> <3808365.SOUxDqkW9J@wuerfel>
In-Reply-To: <3808365.SOUxDqkW9J@wuerfel>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2EAQEAPKAAQBWPFIJBOKV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2EAQEAPKAAQBWPFIJBOKV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/31/2013 12:04 AM, Arnd Bergmann wrote:
> On Thursday 30 May 2013 11:41:01 Michal Simek wrote:
>>   * To perform the read/write on the registers we need to check on
>>   * which bus its connected and call the appropriate write API.
>>   */
>> -static void xilinx_fb_out_be32(struct xilinxfb_drvdata *drvdata, u32 =
offset,
>> +static void xilinx_fb_out32(struct xilinxfb_drvdata *drvdata, u32 off=
set,
>>                                 u32 val)
>>  {
>>         if (drvdata->flags & PLB_ACCESS_FLAG)
>> -               out_be32(drvdata->regs + (offset << 2), val);
>> +               __raw_writel(val, drvdata->regs + (offset << 2));
>>  #ifdef CONFIG_PPC_DCR
>>         else
>>                 dcr_write(drvdata->dcr_host, offset, val);
>>
>=20
> This is probably missing barriers, and is wrong on systems on which
> the endianess of the device is different from the CPU.
>=20
> You already have an indirection in there, so I guess it won't hurt
> to create a third case for little-endian registers and add
> another bit in drvdata->flags, or make it depend on the architecture,
> if the endianess of the device registers is known at compile time.

The PLB_ACCESS_FLAGS is incorrectly named. It means BUS_ACCESS.
But I will find a way how to autodetect endianess directly on IP
as I have done it for uartlite and will send v3.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2EAQEAPKAAQBWPFIJBOKV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGoU54ACgkQykllyylKDCGGWwCfWeZ7MzVgmIK+ZdEihwY0RXjQ
0hMAnjL7HT82h2WCTLU3uhhT7gS5zCLm
=ZggY
-----END PGP SIGNATURE-----

------enig2EAQEAPKAAQBWPFIJBOKV--
