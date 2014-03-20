Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbaCTLX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:23:26 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:40168 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaCTLXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:23:23 -0400
Message-ID: <532ACF9C.6030103@monstr.eu>
Date: Thu, 20 Mar 2014 12:23:08 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Harini Katakam <harinik@xilinx.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>
Subject: Re: [PATCH] SPI: Add driver for Cadence SPI controller
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com> <CAL_JsqKacetGytGUJir7ky3qOgCy-3ny1pT_Bx4eCYV2wMgcTg@mail.gmail.com> <5326F72E.7010401@monstr.eu> <CAL_JsqL9z_4T+cz425bHHpwx_dXaZjJEHwZKFCOibWYuWM4rkA@mail.gmail.com>
In-Reply-To: <CAL_JsqL9z_4T+cz425bHHpwx_dXaZjJEHwZKFCOibWYuWM4rkA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="fNuGFPnxXO2HpIKewsvkgWe5ODQjvNcOX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fNuGFPnxXO2HpIKewsvkgWe5ODQjvNcOX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/17/2014 08:00 PM, Rob Herring wrote:
> On Mon, Mar 17, 2014 at 8:22 AM, Michal Simek <monstr@monstr.eu> wrote:=

>> Hi Rob,
>>
>> On 03/17/2014 01:47 PM, Rob Herring wrote:
>>> On Mon, Mar 17, 2014 at 7:05 AM, Harini Katakam <harinik@xilinx.com> =
wrote:
>>>> Add driver for Cadence SPI controller. This is used in Xilinx Zynq.
>>>>
>>>> Signed-off-by: Harini Katakam <harinik@xilinx.com>
>>>> ---
>>>>  .../devicetree/bindings/spi/spi-cadence.txt        |   25 +
>>>
>>> We prefer binding docs in separate patch.
>>
>> I have heard several times that also for binding review you need drive=
r
>> to look if this binding make sense that's why Harini sent this togethe=
r.
>> It means 2 emails instead of one.
>> But if you wish to have this in two files no problem to split it
>> but then I believe both should be copied to DT mailing list.
>=20
> Yes, for 2 reasons:
> - To prepare for DT bindings to get merged to separate repo if we ever
> get there.
> - So DT maintainers can review/ack just the bindings.

ok. No problem to divide it.

>>>> +- reg                  : Physical base address and size of SPI regi=
sters map.
>>>> +- interrupts           : Property with a value describing the inter=
rupt
>>>> +                         number.
>>>> +- interrupt-parent     : Must be core interrupt controller
>>>> +- clock-names          : List of input clock names - "ref_clk", "pc=
lk"
>>>> +                         (See clock bindings for details).
>>>> +- clocks               : Clock phandles (see clock bindings for det=
ails).
>>>> +- num-chip-select      : Number of chip selects used.
>>>
>>> See Documentation/devicetree/bindings/spi/spi-bus.txt. Use "num-cs" h=
ere.
>>>
>>>> +
>>>> +Example:
>>>> +
>>>> +       spi@e0007000 {
>>>> +               clock-names =3D "ref_clk", "pclk";
>>>> +               clocks =3D <&clkc 26>, <&clkc 35>;
>>>> +               compatible =3D "cdns,spi-r1p6";
>>>
>>> Nit. We usually put compatible first in the node.
>>
>> Our device-tree generator sorts them that's why it is just like this
>> but not a problem to fix just in documentation.
>>
>>
>>>> +               interrupt-parent =3D <&intc>;
>>>> +               interrupts =3D <0 49 4>;
>>>> +               num-chip-select =3D /bits/ 16 <4>;
>>
>> I was expecting you will comment this a little bit. :-)
>> Because all just reading this num-cs as 32bit and then
>> assigning this value to master->num_chipselect which is 16bit.
>=20
> Well, everyone else has that problem then. Obviously it takes a bit
> more care than just reading into a u32, but that is a kernel problem
> and not a problem of the binding.

They are not reading it directly with read_u32 but they are using
intermediate u32 value which is assigned to u16 which is fine.
This pattern is in most drivers(maybe all).

The point is if binding should or can't simplify driver code.
And from your reaction above I expect that it is up to driver
owner and binding doc how you want to do it.

>>>> +/* Macros for the SPI controller read/write */
>>>> +#define cdns_spi_read(addr)    readl_relaxed(addr)
>>>> +#define cdns_spi_write(addr, val)      writel_relaxed((val), (addr)=
)
>>>
>>> Just use readl/writel directly.
>>
>> There shouldn't be any problem to use these helper macros
>> and even I think this is better than using readl/writel directly
>> because you are more flexible if you want to change it to different
>> IO.
>=20
> Then when I read the code I have to go lookup what they do while I
> know exactly what writel/readl do already. It is really the same
> reasons as why the kernel doesn't have register set and clear bits
> accessors.

I understand your reasons but on the other hand if we want to run
ARM-BE then using direct readl/writel functions is also not correct.
Mark proposed one solution and I will see how it looks like.


>>>> +       irq =3D platform_get_irq(pdev, 0);
>>>> +       if (irq < 0) {
>>>
>>> I believe this returns NO_IRQ which could be 0.
>>>
>>> s/</<=3D/
>>
>> Are you sure regarding this?
>> NO_IRQ on ARM is -1.
>> And IRC irq =3D 0 should be just valid number.
>>
>> But if you are right then others drivers have to fixed too.
>=20
> The definition varies by arch being 0 or -1, so drivers need to deal
> with both. The preference is 0 is NO_IRQ. It has been decreed by
> Linus. ARM is actually pretty close to being able to change NO_IRQ to
> 0.

I think that resolution was to completely remove NO_IRQ.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--fNuGFPnxXO2HpIKewsvkgWe5ODQjvNcOX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMqz50ACgkQykllyylKDCFYGwCdHcmNkwEAMug41uo8ycDshtbG
r3YAnRfWyCH4MbkZN1G2KDdbHOzq91WS
=XRI0
-----END PGP SIGNATURE-----

--fNuGFPnxXO2HpIKewsvkgWe5ODQjvNcOX--
