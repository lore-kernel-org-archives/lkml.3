Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaIPK7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:59:37 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40808 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbaIPK7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:59:35 -0400
Message-ID: <54181810.1060105@monstr.eu>
Date: Tue, 16 Sep 2014 12:59:28 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Chen Gang <gang.chen.5i5j@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Paul Bolle <pebolle@tiscali.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: [PATCH] arch/microblaze/kernel/setup.c: Add default 'screen_info"
 for fixing compiling break
References: <541552B8.8020807@gmail.com>	<CAMuHMdU6adYoOafUZ2STZCeuQa3cU-_kD7FHW3x=Tq-O+aqrZw@mail.gmail.com>	<541559C2.8070703@gmail.com>	<5418019E.1010202@monstr.eu> <CAMuHMdWnZVi9rXzmOxsuwMeUcCvW_CH0bi_KuYiCNcp3JQHhLA@mail.gmail.com>
In-Reply-To: <CAMuHMdWnZVi9rXzmOxsuwMeUcCvW_CH0bi_KuYiCNcp3JQHhLA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="IcTgi5G8Dm65kxV8tEjpsmckQ8jrgqaww"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IcTgi5G8Dm65kxV8tEjpsmckQ8jrgqaww
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/16/2014 12:04 PM, Geert Uytterhoeven wrote:
> Hi Michal,
>=20
> On Tue, Sep 16, 2014 at 11:23 AM, Michal Simek <monstr@monstr.eu> wrote=
:
>> On 09/14/2014 11:02 AM, Chen Gang wrote:
>>> On 09/14/2014 04:45 PM, Geert Uytterhoeven wrote:
>>>> Hi Chen,
>>>>
>>>> On Sun, Sep 14, 2014 at 10:32 AM, Chen Gang <gang.chen.5i5j@gmail.co=
m> wrote:
>>>>> Add default one just like other architectures have done (e.g. cris,=

>>>>> score, sh ...), the related error with allmodconfig:
>>>>>
>>>>>     LD      init/built-in.o
>>>>>   drivers/built-in.o: In function `vgacon_save_screen':
>>>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x834d0): undefined re=
ference to `screen_info'
>>>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x834ec): undefined re=
ference to `screen_info'
>>>>>   drivers/built-in.o: In function `vgacon_resize':
>>>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83cdc): undefined re=
ference to `screen_info'
>>>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83d38): undefined re=
ference to `screen_info'
>>>>>   drivers/built-in.o: In function `vgacon_switch':
>>>>>   drivers/video/console/.tmp_vgacon.o:(.text+0x83f50): undefined re=
ference to `screen_info'
>>>>>   drivers/built-in.o:drivers/video/console/.tmp_vgacon.o:(.text+0x8=
407c): more undefined references to `screen_info' follow
>>>>>   make: *** [vmlinux] Error 1
>>>>
>>>> Can microblaze actually have VGA?
>>>>
>>>> If not, it's better to disable it.
>>>>
>>>
>>> Welcome the related microblaze maintainers ideas for it
>>
>> Is this is just about VGA or video console in general?
>> There is xilinx FB driver and other FB are around too.
>=20
> These days screen_info is only used by:
>   - vgacon,
>   - dummycon on ARM,
>   - a few fb drivers (efifb, intelfbdrv,sis, vesafb, and vga16fb).
>=20
> E.g. m68k doesn't have it.

ok. IRC I think I remember one non mainline FB driver which required it t=
oo.
It breaks nothing for me that's why no problem to apply it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--IcTgi5G8Dm65kxV8tEjpsmckQ8jrgqaww
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQYGBAACgkQykllyylKDCG0swCdFeAb6OM+mvXaaFk5ln7GX8Qb
m0wAnjO2EZMAQMBIq4KbQqivxnFJkFIZ
=tIrp
-----END PGP SIGNATURE-----

--IcTgi5G8Dm65kxV8tEjpsmckQ8jrgqaww--
