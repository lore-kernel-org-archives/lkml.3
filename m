Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaBEJZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:25:45 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:63856 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbaBEJZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:25:39 -0500
Message-ID: <52F20387.3090709@monstr.eu>
Date: Wed, 05 Feb 2014 10:25:27 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-doc@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 09/10] watchdog: xilinx: Add missing binding
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <3121595.GbLMuGPlvA@wuerfel> <4c4539fe-e810-4c0a-9a01-c1e4c67ea661@AM1EHSMHS007.ehs.local> <201402042027.15898.arnd@arndb.de>
In-Reply-To: <201402042027.15898.arnd@arndb.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="9CvXGtd7m7EJr2XSCF9fHIMotVRmFlMFF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9CvXGtd7m7EJr2XSCF9fHIMotVRmFlMFF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/04/2014 08:27 PM, Arnd Bergmann wrote:
> On Monday 03 February 2014, Michal Simek wrote:
>> On 02/03/2014 04:32 PM, Arnd Bergmann wrote:
>>> On Monday 03 February 2014 16:13:47 Michal Simek wrote:
>>>> Intention wasn't to fix binding but document current one
>>>> which is in mainline for a long time.
>>>
>>> Ok, I see.
>>>
>>>> Apart of this - yes, wdt-enable-once is nowayout and wdt-interval sh=
ould be timeout
>>>> is seconds, and clock-frequency should go out and use CCF for gettin=
g clock.
>>>
>>> Could we make a common binding then, and document that the xilinx
>>> watchdog can optionally provide either one?
>>
>> Do you mean to have 2 DT bindings?
>>
>> This binding is used from 2011-07.
>> It means it was generated for all hw designs at least from this time.
>> I would say from DT usage on Microblaze because it is not special case=

>> in our dt generator.
>=20
> I certainly wasn't suggesting to break the binding, quite the contrary.=

> What I tried to say is that the properties look like they should be
> useful for different kinds of watchdogs, not just xilinx, so it would
> be good to have a common definition using generic strings.
>=20
> The xilinx driver would definitely have to keep supporting the traditio=
nal
> property names, but it could also support the generic names in the
> future.

No problem with to do in future.

>> xlnx,XXX are XXX parameters which you have to setup in tools
>> and get synthesized. This is valid for all xilinx IPs. We have full
>> IP description by generating xlnx,XXX parameters directly from tools
>> because we know all variants which can happen.
>>
>> Just back to your previous post:
>> "I'm not sure about the enable-once flag, which seems to just map to t=
he
>> "nowayout" watchdog option that is not a hardware feature at all"
>> this is hw feature which you can select in tools because this is fpga.=
 :-)
>=20
> Ah, so you mean the properties are not settings that the driver
> programs into the hardware, but they are hardware properties that the
> driver reports to user space?

yes, they are hardware properties which you can choose based on your
configuration. Every user just decides if this watchdog can be started ju=
st
once and how long it takes in synthesis time. There is no option to progr=
am
this by software.

I am not quite sure what you mean by reports to user space.
If you mean to get timeout through ioctl for example - then yes it is wor=
king
through standard watchdog ioctl interface and timeout is calculated
from hardware setup.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--9CvXGtd7m7EJr2XSCF9fHIMotVRmFlMFF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLyA4gACgkQykllyylKDCEZoQCgi5g0gXSqx8GgQYPNhgWgtOD9
UNwAn2SKlTzD/1cVVKg6yYjlPzzJMVjK
=0iPJ
-----END PGP SIGNATURE-----

--9CvXGtd7m7EJr2XSCF9fHIMotVRmFlMFF--
