Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaDDFwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 01:52:16 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:61830 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaDDFwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 01:52:11 -0400
Message-ID: <533E4884.1020907@monstr.eu>
Date: Fri, 04 Apr 2014 07:52:04 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: balbi@ti.com
CC: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, michals@xilinx.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH v2 1/2] usb: doc: udc-xilinx: Add devicetree bindings
References: <5a9b0116-246c-40a0-b894-3321c74648de@CH1EHSMHS007.ehs.local> <20140403145934.GE14162@saruman.home>
In-Reply-To: <20140403145934.GE14162@saruman.home>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ktmQKHiMnuAePgwjbCw4dTPXkD2C3IPII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ktmQKHiMnuAePgwjbCw4dTPXkD2C3IPII
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/03/2014 04:59 PM, Felipe Balbi wrote:
> On Thu, Apr 03, 2014 at 01:05:18PM +0530, Subbaraya Sundeep Bhatta wrot=
e:
>> Add devicetree bindings for Xilinx axi udc driver.
>>
>> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
>> ---
>> Changes for v2:
>> 	- replaced xlnx,include-dma with xlnx,has-builtin-dma
>>
>>  .../devicetree/bindings/usb/udc-xilinx.txt         |   20 +++++++++++=
+++++++++
>>  1 files changed, 20 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/usb/udc-xilinx.t=
xt
>>
>> diff --git a/Documentation/devicetree/bindings/usb/udc-xilinx.txt b/Do=
cumentation/devicetree/bindings/usb/udc-xilinx.txt
>> new file mode 100644
>> index 0000000..7c24fac
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/usb/udc-xilinx.txt
>> @@ -0,0 +1,20 @@
>> +Xilinx AXI USB2 device controller
>> +
>> +Required properties:
>> +- compatible		: Should be "xlnx,axi-usb2-device-4.00.a"
>> +- reg			: Physical base address and size of the Axi USB2
>> +			  device registers map.
>> +- interrupts		: Property with a value describing the interrupt
>> +			  number.
>> +- interrupt-parent	: Must be core interrupt controller
>> +- xlnx,has-builtin-dma	: if DMA is included
>=20
> isn't there a configuration register to tell you this ?

I have checked this with Sundeep and there is nothing like that in the HW=
=2E

>=20
>> +
>> +Example:
>> + 		axi-usb2-device@42e00000 {
>> +                        compatible =3D "xlnx,axi-usb2-device-4.00.a";=

>> +                        interrupt-parent =3D <0x1>;
>=20
> why isn't interrupt-parent a phandle ?

Just for the record: Using number here should be also fine because DTC
is converting it to numbers with linux,phandle and phandle.
[linux-next]$ dtc -O dts -I dtb /tftpboot/devicetree.dtb | less
=2E..
                ps7-scugic@f8f01000 {
                        #address-cells =3D <0x2>;
                        #interrupt-cells =3D <0x3>;
                        #size-cells =3D <0x1>;
                        compatible =3D "arm,cortex-a9-gic", "arm,gic";
                        interrupt-controller;
                        num_cpus =3D <0x2>;
                        num_interrupts =3D <0x60>;
                        reg =3D <0xf8f01000 0x1000 0xf8f00100 0x100>;
                        linux,phandle =3D <0x3>;
                        phandle =3D <0x3>;
                };

                ps7-scutimer@f8f00600 {
                        clocks =3D <0x2 0x4>;
                        compatible =3D "arm,cortex-a9-twd-timer";
                        interrupt-parent =3D <0x3>;
                        interrupts =3D <0x1 0xd 0x301>;
                        reg =3D <0xf8f00600 0x20>;
                };
=2E..

but anyway Sundeep with change it to any sensible value <&intc>;

Thanks for pointing to it,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--ktmQKHiMnuAePgwjbCw4dTPXkD2C3IPII
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM+SIQACgkQykllyylKDCH/yACfaGnZM5oUhMYf7zFW1sD6kcOn
DugAn0AxYyiQ3hxmyQ6RVUue6fm9HJxc
=ugKb
-----END PGP SIGNATURE-----

--ktmQKHiMnuAePgwjbCw4dTPXkD2C3IPII--
