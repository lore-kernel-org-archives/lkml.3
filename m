Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaBCIp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:45:57 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:39538 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaBCIpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:45:53 -0500
Message-ID: <52EF573B.2000701@monstr.eu>
Date: Mon, 03 Feb 2014 09:45:47 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 10/10] watchdog: xilinx: Enable this driver for Zynq
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <f7bdfada576e93eaab8f6dc2ecd881da8f43911c.1391177880.git.michal.simek@xilinx.com> <52EBB897.6040300@roeck-us.net> <52EF3ECF.4010006@monstr.eu> <52EF52A8.4080400@roeck-us.net>
In-Reply-To: <52EF52A8.4080400@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="VxjsieEpO8aKvrtlcOSt3lKOdFSktdSJU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VxjsieEpO8aKvrtlcOSt3lKOdFSktdSJU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/03/2014 09:26 AM, Guenter Roeck wrote:
> On 02/02/2014 11:01 PM, Michal Simek wrote:
>> On 01/31/2014 03:52 PM, Guenter Roeck wrote:
>>> On 01/31/2014 06:18 AM, Michal Simek wrote:
>>>> Enable this driver for Zynq.
>>>> Move it to architecture independent Kconfig part.
>>>>
>>>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>>>> ---
>>>>
>>>> Build tested by zero day testing system.
>>>> ---
>>>>    drivers/watchdog/Kconfig | 22 +++++++++-------------
>>>>    1 file changed, 9 insertions(+), 13 deletions(-)
>>>>
>>>> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
>>>> index 9db5d3c..6120403 100644
>>>> --- a/drivers/watchdog/Kconfig
>>>> +++ b/drivers/watchdog/Kconfig
>>>> @@ -111,6 +111,15 @@ config WM8350_WATCHDOG
>>>>          Support for the watchdog in the WM8350 AudioPlus PMIC.  Whe=
n
>>>>          the watchdog triggers the system will be reset.
>>>>
>>>> +config XILINX_WATCHDOG
>>>> +    tristate "Xilinx Watchdog timer"
>>>> +    select WATCHDOG_CORE
>>>
>>> This needs to depend on HAS_IOMEM.
>>
>> Are you sure?
>> I have no problem to do this change.
>> Zero day testing system doesn't report any problem with it.
>>
>> I have checked dependencies and only score, tile and um has NO_IOMEM o=
ption
>> enables. And below in log is tile with allyesconfig that's why I belie=
ve
>> this driver has been also tested without any issue.
>>
>=20
> https://lkml.org/lkml/2014/1/31/123
>=20
> I would have assumed the same applies here, but if you are sure that it=
 doesn't I am fine.

I am not 100% sure because I didn't compile it myself for that 3 archs
but one was just fine.

Thanks,
Michal
--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--VxjsieEpO8aKvrtlcOSt3lKOdFSktdSJU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLvVzsACgkQykllyylKDCE1jQCfYJtdx7go5wLO7gHOvmHXyikZ
4mQAoJyWFRdWQSUy2ux/bJlXcks8iI8f
=uQJN
-----END PGP SIGNATURE-----

--VxjsieEpO8aKvrtlcOSt3lKOdFSktdSJU--
