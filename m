Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaFBGZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 02:25:36 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35715 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaFBGZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 02:25:33 -0400
Message-ID: <538C18CC.6040105@monstr.eu>
Date: Mon, 02 Jun 2014 08:25:16 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Harini Katakam <harinik@xilinx.com>, "wim@iguana.be" <wim@iguana.be>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] watchdog: Add Cadence WDT driver
References: <1401185895-3677-1-git-send-email-harinik@xilinx.com> <20140529092106.GC24233@leverpostej> <53870129.5010505@monstr.eu> <20140529131940.GG24233@leverpostej>
In-Reply-To: <20140529131940.GG24233@leverpostej>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="BiKsBpnhxs5kiiEJnDCpQBMnWbjuGLFVp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BiKsBpnhxs5kiiEJnDCpQBMnWbjuGLFVp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/29/2014 03:19 PM, Mark Rutland wrote:
> On Thu, May 29, 2014 at 10:43:05AM +0100, Michal Simek wrote:
>> Hi Mark,
>>
>>>> +static struct of_device_id cdns_wdt_of_match[] =3D {
>>>> +       { .compatible =3D "xlnx,zynq-wdt-r1p2", },
>>>> +       { .compatible =3D "cdns,wdt-r1p2", },
>>>
>>> If these can currently be handled identically, why not just have
>>> "cdns,wdt-r1p2" in the driver and in your dts have:
>>>
>>> compatible =3D "xlnx,zynq-wdt-r1p2", "cdns,wdt-r1p2";
>>>
>>> If we need to distinguish the two for some reason later we can always=

>>> add the "xlnx,zynq-wdt-r1p2" string to the driver.
>>
>> I would prefer to have 2 compatible strings just because
>> of that we don't know what is different compare to origin cadence
>> version. We have done the same for spi-cadence.c that's why
>> it shouldn't be any problem to keep it as is.
>> Having zynq compatible property here and using it give us option
>> that if another SoC vendor come with new configuration or clean
>> cadence one we can simple handle it without changing compatible
>> property for us.
>=20
> Sure, we can have two documented strings. But as I mention for the
> moment the driver only needs to support the one string so long as a
> given dts has both. Then we can later distinguish the zynq variant (or
> any other) as necessary.

ok then. Let's use just "xlnx,zynq-wdt-r1p2" compatible string here
and remove "cdns,wdt-r1p2"

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--BiKsBpnhxs5kiiEJnDCpQBMnWbjuGLFVp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOMGMwACgkQykllyylKDCGpTgCeI7dlKUifRZbCVGPXZJ905Fb2
qfUAn0ReQS9Wp7Gz9Gfl9Mg/T3JbdEma
=pVbY
-----END PGP SIGNATURE-----

--BiKsBpnhxs5kiiEJnDCpQBMnWbjuGLFVp--
