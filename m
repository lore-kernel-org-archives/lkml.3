Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaDDLRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 07:17:09 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52667 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaDDLRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:17:04 -0400
Message-ID: <533E94AB.6060400@monstr.eu>
Date: Fri, 04 Apr 2014 13:16:59 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Harini Katakam <harinikatakamlinux@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] devicetree: Add devicetree bindings documentation
 for Cadence SPI
References: <1396523431-14519-1-git-send-email-harinik@xilinx.com> <1396523431-14519-2-git-send-email-harinik@xilinx.com> <20140403213446.GB14763@sirena.org.uk> <CAFcVEC+mpHh_d2j6_sdhWS3d2KyXrDYUq6L6jO2Q=SS68Hda2g@mail.gmail.com> <CAMuHMdWvFT1kLpcYGSuNFs6qVTbn4S-9-rFV8jkJMAaS8xCDnQ@mail.gmail.com>
In-Reply-To: <CAMuHMdWvFT1kLpcYGSuNFs6qVTbn4S-9-rFV8jkJMAaS8xCDnQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Cdw5EfFCIsanNVDpkgvWw1A791LJUAXmi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Cdw5EfFCIsanNVDpkgvWw1A791LJUAXmi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/04/2014 10:09 AM, Geert Uytterhoeven wrote:
> Hi Harini,
>=20
> On Fri, Apr 4, 2014 at 5:00 AM, Harini Katakam
> <harinikatakamlinux@gmail.com> wrote:
>>>> +             num-cs =3D /bits/ 16 <4>;
>>>
>>> What's going on with the /bits/ - is this something that's required f=
or
>>> the property?
>>
>> The master->num-chipselect property is 16 bit but writing <4> here dir=
ectly
>> leads to 0 being read in of_property_read (because it's big endian).
>> Instead using of property read u32 and then copying, we decided to do =
this.
>> This was discussed on v2 between Michal and Rob:
>>>>>> +               num-chip-select =3D /bits/ 16 <4>;
>>>>
>>>> I was expecting you will comment this a little bit. :-)
>>>> Because all just reading this num-cs as 32bit and then
>>>> assigning this value to master->num_chipselect which is 16bit.
>>>
>>> Well, everyone else has that problem then. Obviously it takes a bit
>>> more care than just reading into a u32, but that is a kernel problem
>>> and not a problem of the binding.
>> They are not reading it directly with read_u32 but they are using
>> intermediate u32 value which is assigned to u16 which is fine.
>> This pattern is in most drivers(maybe all).
>> The point is if binding should or can't simplify driver code.
>> And from your reaction above I expect that it is up to driver
>> owner and binding doc how you want to do it.
>=20
> IMHO this "/bits/ 16" doesn't simplify the binding.
>=20
> As "num-cs" is a generic spi subsystem binding, it should not be
> restricted to 16 bits for the sake of a driver. As your hardware can dr=
ive 4
> chip selects, you could represent it in 3 bits (don't!).
>=20
> Simple integers are 32 bit in DT, so use a temporary.

No problem to keep it there to 32bit range. I really appreciate
that discussion we have about it.

Just a note: If "num-cs" is the part of generic spi subsystem binding
maybe it should be moved directly to spi core as is done for
example for timeout-sec in watchdog.
Also this should be listed in any Documentation/devicetree/bindings/spi/s=
pi.txt
file that this is generic spi binding.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--Cdw5EfFCIsanNVDpkgvWw1A791LJUAXmi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM+lKsACgkQykllyylKDCGkcQCfdTs4zmS2/AmvgdR8D1enuOs+
M8cAnR0cnWrNqc07g8kEGyf6Yx2UIIjx
=yFCi
-----END PGP SIGNATURE-----

--Cdw5EfFCIsanNVDpkgvWw1A791LJUAXmi--
