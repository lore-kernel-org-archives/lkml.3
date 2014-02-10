Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbaBJHD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:03:57 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:42307 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaBJHD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:03:56 -0500
Message-ID: <52F879CF.8080906@monstr.eu>
Date: Mon, 10 Feb 2014 08:03:43 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/10] watchdog: xilinx: Convert driver to the watchdog
 framework
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <52F7DF2F.5060001@roeck-us.net>
In-Reply-To: <52F7DF2F.5060001@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="DpxClkbQkmgeo552XHnWWFOWLNPnBjoDG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DpxClkbQkmgeo552XHnWWFOWLNPnBjoDG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/09/2014 09:03 PM, Guenter Roeck wrote:
> On 01/31/2014 06:18 AM, Michal Simek wrote:
>> - Remove uneeded headers, fops functions
>> - Use xilinx_wdt prefix in start/stop/keepalive functions
>>    and in new structures
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>=20
> Hi Michal,
>=20
>>   static int xwdt_probe(struct platform_device *pdev)
>>   {
>>       int rc;
>> @@ -314,7 +184,7 @@ static int xwdt_probe(struct platform_device *pdev=
)
>>                       "xlnx,wdt-enable-once", NULL);
>>       if (tmptr =3D=3D NULL) {
>>           pr_warn("Parameter \"xlnx,wdt-enable-once\" not found in dev=
ice tree!\n");
>> -        xdev.nowayout =3D WATCHDOG_NOWAYOUT;
>> +        watchdog_set_nowayout(&xilinx_wdt_wdd, true);
>=20
> Sure you want to set this to always true instead of using WATCHDOG_NOWA=
YOUT ?

I have checked it and
option CONFIG_WATCHDOG_NOWAYOUT - Disable watchdog shutdown on close

with this part in the header

100 #ifdef CONFIG_WATCHDOG_NOWAYOUT
101 #define WATCHDOG_NOWAYOUT               1
102 #define WATCHDOG_NOWAYOUT_INIT_STATUS   (1 << WDOG_NO_WAY_OUT)
103 #else
104 #define WATCHDOG_NOWAYOUT               0
105 #define WATCHDOG_NOWAYOUT_INIT_STATUS   0
106 #endif

enable once is hardware option and it means when this option is setup in
hw you can't stop watchdog. That's why I think that setting up true
instead of WATCHDOG_NOWAYOUT is correct.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--DpxClkbQkmgeo552XHnWWFOWLNPnBjoDG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlL4edAACgkQykllyylKDCHhBACgi+cnCGDk7DtyIBFrliDzuA4b
H/0An2t2HUIpyz3HNx0FB9+E/tHkjx7j
=YDI7
-----END PGP SIGNATURE-----

--DpxClkbQkmgeo552XHnWWFOWLNPnBjoDG--
