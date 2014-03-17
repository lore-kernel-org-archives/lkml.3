Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbaCQNXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:23:08 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:35393 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489AbaCQNXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:23:05 -0400
Message-ID: <5326F72E.7010401@monstr.eu>
Date: Mon, 17 Mar 2014 14:22:54 +0100
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
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com> <CAL_JsqKacetGytGUJir7ky3qOgCy-3ny1pT_Bx4eCYV2wMgcTg@mail.gmail.com>
In-Reply-To: <CAL_JsqKacetGytGUJir7ky3qOgCy-3ny1pT_Bx4eCYV2wMgcTg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="bnFEqD74vhxnPfpNcloCjqowcFUGmafpM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bnFEqD74vhxnPfpNcloCjqowcFUGmafpM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Rob,

On 03/17/2014 01:47 PM, Rob Herring wrote:
> On Mon, Mar 17, 2014 at 7:05 AM, Harini Katakam <harinik@xilinx.com> wr=
ote:
>> Add driver for Cadence SPI controller. This is used in Xilinx Zynq.
>>
>> Signed-off-by: Harini Katakam <harinik@xilinx.com>
>> ---
>>  .../devicetree/bindings/spi/spi-cadence.txt        |   25 +
>=20
> We prefer binding docs in separate patch.

I have heard several times that also for binding review you need driver
to look if this binding make sense that's why Harini sent this together.
It means 2 emails instead of one.
But if you wish to have this in two files no problem to split it
but then I believe both should be copied to DT mailing list.


>>  drivers/spi/Kconfig                                |    7 +
>>  drivers/spi/Makefile                               |    1 +
>>  drivers/spi/spi-cadence.c                          |  804 +++++++++++=
+++++++++
>>  4 files changed, 837 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/spi/spi-cadence.=
txt
>>  create mode 100644 drivers/spi/spi-cadence.c
>>
>> diff --git a/Documentation/devicetree/bindings/spi/spi-cadence.txt b/D=
ocumentation/devicetree/bindings/spi/spi-cadence.txt
>> new file mode 100644
>> index 0000000..d25bc2d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/spi/spi-cadence.txt
>> @@ -0,0 +1,25 @@
>> +Cadence SPI controller Device Tree Bindings
>> +-------------------------------------------
>> +
>> +Required properties:
>> +- compatible           : Should be "cdns,spi-r1p6".
>=20
> One problem with using IP vendor info in the compatible string is an
> IP block typically has a variety of configuration options so the
> actual implementations may be very different. I would recommend adding
> a Xilinx compatible string as well even if you don't use it now.

It means xlnx,zynq-spi-r1p6 should be fine.

>=20
>> +- reg                  : Physical base address and size of SPI regist=
ers map.
>> +- interrupts           : Property with a value describing the interru=
pt
>> +                         number.
>> +- interrupt-parent     : Must be core interrupt controller
>> +- clock-names          : List of input clock names - "ref_clk", "pclk=
"
>> +                         (See clock bindings for details).
>> +- clocks               : Clock phandles (see clock bindings for detai=
ls).
>> +- num-chip-select      : Number of chip selects used.
>=20
> See Documentation/devicetree/bindings/spi/spi-bus.txt. Use "num-cs" her=
e.
>=20
>> +
>> +Example:
>> +
>> +       spi@e0007000 {
>> +               clock-names =3D "ref_clk", "pclk";
>> +               clocks =3D <&clkc 26>, <&clkc 35>;
>> +               compatible =3D "cdns,spi-r1p6";
>=20
> Nit. We usually put compatible first in the node.

Our device-tree generator sorts them that's why it is just like this
but not a problem to fix just in documentation.


>> +               interrupt-parent =3D <&intc>;
>> +               interrupts =3D <0 49 4>;
>> +               num-chip-select =3D /bits/ 16 <4>;

I was expecting you will comment this a little bit. :-)
Because all just reading this num-cs as 32bit and then
assigning this value to master->num_chipselect which is 16bit.

<snip>

>> +/* Macros for the SPI controller read/write */
>> +#define cdns_spi_read(addr)    readl_relaxed(addr)
>> +#define cdns_spi_write(addr, val)      writel_relaxed((val), (addr))
>=20
> Just use readl/writel directly.

There shouldn't be any problem to use these helper macros
and even I think this is better than using readl/writel directly
because you are more flexible if you want to change it to different
IO.

<snip>

>> +/**
>> + * cdns_spi_probe - Probe method for the SPI driver
>> + * @pdev:      Pointer to the platform_device structure
>> + *
>> + * This function initializes the driver data structures and the hardw=
are.
>> + *
>> + * Return:     0 on success and error value on error
>> + */
>> +static int cdns_spi_probe(struct platform_device *pdev)
>> +{
>> +       int ret =3D 0, irq;
>> +       struct spi_master *master;
>> +       struct cdns_spi *xspi;
>> +       struct resource *res;
>> +
>> +       master =3D spi_alloc_master(&pdev->dev, sizeof(*xspi));
>> +       if (master =3D=3D NULL)
>> +               return -ENOMEM;
>> +
>> +       xspi =3D spi_master_get_devdata(master);
>> +       master->dev.of_node =3D pdev->dev.of_node;
>> +       platform_set_drvdata(pdev, master);
>> +
>> +       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       xspi->regs =3D devm_ioremap_resource(&pdev->dev, res);
>> +       if (IS_ERR(xspi->regs)) {
>> +               ret =3D PTR_ERR(xspi->regs);
>> +               goto remove_master;
>> +       }
>> +
>> +       irq =3D platform_get_irq(pdev, 0);
>> +       if (irq < 0) {
>=20
> I believe this returns NO_IRQ which could be 0.
>=20
> s/</<=3D/

Are you sure regarding this?
NO_IRQ on ARM is -1.
And IRC irq =3D 0 should be just valid number.

But if you are right then others drivers have to fixed too.


>> +       return 0;
>> +}
>> +
>> +static SIMPLE_DEV_PM_OPS(cdns_spi_dev_pm_ops, cdns_spi_suspend,
>> +                        cdns_spi_resume);
>> +
>> +/* Work with hotplug and coldplug */
>> +MODULE_ALIAS("platform:" CDNS_SPI_NAME);
>=20
> Not sure, but I don't think this should be needed.

I don't know too.

Thanks for review,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--bnFEqD74vhxnPfpNcloCjqowcFUGmafpM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMm9y8ACgkQykllyylKDCFmlwCeMf+C+ERZGSfSJyxD2MNGJ17n
vCwAnjX+inZ+weyZbeW593UxcKLc/RMm
=m+Xi
-----END PGP SIGNATURE-----

--bnFEqD74vhxnPfpNcloCjqowcFUGmafpM--
