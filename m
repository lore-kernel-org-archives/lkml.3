Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbaBUNlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:41:16 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:45573 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349AbaBUNlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:41:11 -0500
Message-ID: <5307576F.5050506@monstr.eu>
Date: Fri, 21 Feb 2014 14:41:03 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Felipe Balbi <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local> <20140220182257.GF23217@saruman.home> <20140221120454.GD8783@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140221120454.GD8783@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4K9hd19ieCF9psUfsLkTHEfKqOPe1tte1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4K9hd19ieCF9psUfsLkTHEfKqOPe1tte1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On 02/21/2014 01:04 PM, Mark Rutland wrote:
>=20
> On Thu, Feb 20, 2014 at 06:23:13PM +0000, Felipe Balbi wrote:
>> Hi,
>>
>> On Wed, Feb 19, 2014 at 03:10:45PM +0530, Subbaraya Sundeep Bhatta wro=
te:
>>> This patch adds xilinx axi usb2 device driver support
>>>
>>> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
>>> ---
>>>  .../devicetree/bindings/usb/xilinx_usb.txt         |   21 +
>>>  drivers/usb/gadget/Kconfig                         |   14 +
>>>  drivers/usb/gadget/Makefile                        |    1 +
>>>  drivers/usb/gadget/xilinx_udc.c                    | 2045 ++++++++++=
++++++++++
>>>  4 files changed, 2081 insertions(+), 0 deletions(-)
>>>  create mode 100644 Documentation/devicetree/bindings/usb/xilinx_usb.=
txt
>>>  create mode 100644 drivers/usb/gadget/xilinx_udc.c
>>>
>>> diff --git a/Documentation/devicetree/bindings/usb/xilinx_usb.txt b/D=
ocumentation/devicetree/bindings/usb/xilinx_usb.txt
>>> new file mode 100644
>>> index 0000000..acf03ab
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/usb/xilinx_usb.txt
>>> @@ -0,0 +1,21 @@
>>> +Xilinx AXI USB2 device controller
>>> +
>>> +Required properties:
>>> +- compatible		: Should be "xlnx,axi-usb2-device-4.00.a"
>=20
> Is "axi-usb2-device" the official device name?

It is the name of IP which Xilinx have and we are using names in this for=
mat.


>>> +- reg			: Physical base address and size of the Axi USB2
>>> +			  device registers map.
>>> +- interrupts		: Property with a value describing the interrupt
>>> +			  number.
>=20
> Does the device only have a single interrupt?

I believe so.


>>> +- interrupt-parent	: Must be core interrupt controller
>=20
> Is this strictly necessary?

I am not sure what do you mean by that. If you mean that interrupt-parent=

can be written to the root of DTS file then we can setup system with more=

interrupt controllers that's why it is required.

If we can point to standard interrupt description then please point me to=

exact description you would like to see here and we can change it.


>>> +- xlnx,include-dma	: Must be 1 or 0 based on whether DMA is included=

>>> +			  in IP or not.
>=20
> Perhaps xlnx,has-builtin-dma would better describe this?

No opinion.

>>> +
>>> +Example:
>>> + 		axi-usb2-device@42e00000 {
>>> +                        compatible =3D "xlnx,axi-usb2-device-4.00.a"=
;
>>> +                        interrupt-parent =3D <0x1>;
>>> +                        interrupts =3D <0x0 0x39 0x1>;
>>> +                        reg =3D <0x42e00000 0x10000>;
>>> +                        xlnx,include-dma =3D <0x1>;
>>> +                };
>>> +
>>
>> you need to Cc devicetree@vger.kernel.org for this.
>=20
> Cheers Filipe; thanks for adding us to Cc :)
>=20

Sundeep with CC devicetree list in next patch version.

>>> +	/* Map the registers */
>>> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +	udc->base_address =3D devm_ioremap_nocache(&pdev->dev, res->start,
>>> +						 resource_size(res));
>>
>> use devm_ioremap_resource() instead.
>=20
> Also, res might be NULL. You should check that before dereferencing it.=


yes it is necessary for both cases with devm_ioremap_nocache
or with devm_ioremap_resource.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--4K9hd19ieCF9psUfsLkTHEfKqOPe1tte1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMHV3MACgkQykllyylKDCHqOwCfao0qJkjoyY6S8dnC28XVxE91
kjsAnAxYeusIlhc8ajPCcSpgeycytfjw
=EG7c
-----END PGP SIGNATURE-----

--4K9hd19ieCF9psUfsLkTHEfKqOPe1tte1--
