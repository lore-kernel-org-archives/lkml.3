Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbaKRPRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:17:40 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45453 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbaKRPRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:17:37 -0500
Date: Tue, 18 Nov 2014 09:17:53 -0600
From: Felipe Balbi <balbi@ti.com>
To: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
CC: <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  usb: gadget: USB3 support to the legacy printer driver
Message-ID: <20141118151753.GB8223@saruman>
Reply-To: <balbi@ti.com>
References: <546A829A.8030106@linaro.org>
 <20141118003028.GA11280@saruman>
 <546B5578.8040809@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <546B5578.8040809@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 18, 2014 at 09:19:36AM -0500, Jorge Ramirez-Ortiz wrote:
> Hi Felipe/Greg
>=20
> Thanks for your comments on my previous attempt.
> I think I addressed them here.

no you haven't. Read Documentation/SubmittingPatches, read the mailing
list archives and you'll see your basic mistake.

> I added some logs of a run captured on a recent kernel, fixed the indenta=
tions,
> replaced the if/else with a switch statement and removed the copyright.
>=20
> Note that the tests seem to indicate a performance issue on the net2280 d=
river: the
> exact same tests using the usb338x.c driver from PLX allows for transfer =
speeds of 1Gbps.
>=20
> cheers
> Jorge
>=20
> File transfer test using g_printer on 10b5:3380
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The host will transfer a file to the device using the g_printer driver.
>=20
> 0) enable the net2280 on the g_printer:
> --------------------------------------
>=20
>         From 8e306693839a77bfe3411a842d4d20acb9dae9e3 Mon Sep 17 00:00:00=
 2001
>         From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
>         Date: Mon, 17 Nov 2014 22:31:59 -0500
>         Subject: [PATCH] use the 338x
>      =20
>         ---
>          drivers/usb/gadget/legacy/printer.c | 4 ++--
>          1 file changed, 2 insertions(+), 2 deletions(-)
>      =20
>        diff --git a/drivers/usb/gadget/legacy/printer.c
> b/drivers/usb/gadget/legacy/printer.c
>        index 456730b..ba919a0 100644
>        --- a/drivers/usb/gadget/legacy/printer.c
>        +++ b/drivers/usb/gadget/legacy/printer.c
>        @@ -99,8 +99,8 @@ static struct printer_dev usb_printer_gadget;
>      =20
>         /* Thanks to NetChip Technologies for donating this product ID.
>          */
>        -#define PRINTER_VENDOR_NUM     0x0525          /* NetChip */
>        -#define PRINTER_PRODUCT_NUM    0xa4a8          /* Linux-USB Print=
er Gadget */
>        +#define PRINTER_VENDOR_NUM     0x10B5       =20
>        +#define PRINTER_PRODUCT_NUM    0x3380       =20

you have no clue what these mean, do you ? How about reading the USB
specification of even http://www.beyondlogic.org/usbnutshell/usb1.shtml

Changing these will not cause you to use usb338x driver, you're just
using a vendor/product ID you don't own.

>      =20
>         /* Some systems will want different product identifiers published=
 in the
>          * device descriptor, either numbers or strings or both.  These s=
tring
>        --
>        1.9.1
>=20
>=20
> 1) Host logs:
> -------------
>=20
> [jramirez@miro ~]$ lsusb
> Bus 002 Device 006: ID 05ac:1303 Apple, Inc. iPod Shuffle 4.Gen
> Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 004 Device 007: ID 10b5:3380 Comodo (PLX?)
> Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
> Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 001 Device 005: ID 0403:6001 Future Technology Devices International,=
 Ltd FT232
> USB-Serial (UART) IC
> Bus 001 Device 003: ID 046d:0990 Logitech, Inc. QuickCam Pro 9000
> Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>=20
> [jramirez@miro ~]$ lsusb -s 004:007 -v
>=20
> Bus 004 Device 007: ID 10b5:3380 Comodo (PLX?)
> Couldn't open device, some information will be missing
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               3.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0         9
>   idVendor           0x10b5 Comodo (PLX?)
>   idProduct          0x3380
>   bcdDevice            3.18
>   iManufacturer           1
>   iProduct                2
>   iSerial                 3
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           44
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0xc0
>       Self Powered
>     MaxPower                2mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass         7 Printer
>       bInterfaceSubClass      1 Printer
>       bInterfaceProtocol      2 Bidirectional
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               0
>         bMaxBurst               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               0
>         bMaxBurst               0
>=20
> =20
> [jramirez@miro host.git (master%)]$ sudo ./usbhost file.wav
> [sudo] password for jramirez:
> Opening device 10B5:3380...
>=20
> Device properties:
>         bus number: 4
>          port path: 2 (from root hub)
>  device speed: 5000 Mbit/s (USB SuperSpeed)
>=20
> Reading device descriptor:
>             length: 18
>       device class: 0
>                S/N: 3
>            VID:PID: 10B5:3380
>          bcdDevice: 0318
>    iMan:iProd:iSer: 1:2:3
>           nb confs: 1
>=20
> Reading BOS descriptor: 2 caps
>     USB 2.0 extension:
>       attributes             : 06
>     USB 3.0 capabilities:
>       attributes             : 00
>       supported speeds       : 000F
>       supported functionality: 01
>=20
> Reading first configuration descriptor:
>              nb interfaces: 1
>               interface[0]: id =3D 0
> interface[0].altsetting[0]: num endpoints =3D 2
>    Class.SubClass.Protocol: 07.01.02
>        endpoint[0].address: 81
>            max packet size: 0400
>           polling interval: 00
>                  max burst: 00   (USB 3.0)
>         bytes per interval: 0000 (USB 3.0)
>        endpoint[1].address: 01
>            max packet size: 0400
>           polling interval: 00
>                  max burst: 00   (USB 3.0)
>         bytes per interval: 0000 (USB 3.0)
>=20
> Claiming interface 0...
>=20
> Reading string descriptors:
>    String (0x01): "Linux 3.18.0-rc5+ with net2280"
>    String (0x02): "Printer Gadget"
> Transfering: endpoint_out 1, size 61387314
>  - number of bulk transfers : 7494
>  - max user transfer size   : 8192 bytes
>  - max usb transfer size    : 1024 bytes
>=20
> 2) Device Logs:
> --------------
>=20
> [jramirez@dali ~]$ cat /proc/version
> Linux version 3.18.0-rc5+ (jramirez@localhost.localdomain) (gcc version 4=
=2E8.3
> 20140911 (Red Hat 4.8.3-7) (GCC) ) #1 SMP Mon Nov 17 21:59:22 EST 2014
>=20
>=20
> [   72.345683] net2280 0000:02:00.0: usb_reset_338x: Defect 7374 FsmValue=
 0xf0000000
> [   72.345706] net2280 0000:02:00.0: usb_reinit_338x: Defect 7374 FsmValu=
e f0000000
> [   72.345748] net2280 0000:02:00.0: irq 35 for MSI/MSI-X
> [   72.345798] net2280 0000:02:00.0: PLX NET228x/USB338x USB Peripheral C=
ontroller
> [   72.345801] net2280 0000:02:00.0: irq 35, pci mem ffffc90004960000, ch=
ip rev 00ab
> [   72.345803] net2280 0000:02:00.0: version: 2005 Sept 27/v3.0; dma enab=
led legacy mode
> [   86.630589] printer gadget: Printer Gadget, version: 2007 OCT 06
> [   86.630593] printer gadget: printer ready
> [   86.630599] net2280 0000:02:00.0: Operate Defect 7374 workaround soft =
this time
> [   86.630600] net2280 0000:02:00.0: It will operate on cold-reboot and S=
S connect
> [   86.630709] net2280 0000:02:00.0: ep0_start_338x: Defect 7374 FsmValue=
 10000000
> [   86.870669] net2280 0000:02:00.0: INFO: Defect 7374 workaround waited =
about
> [   86.875065] printer gadget: super-speed config #1: printer
> [   86.875077] printer gadget: Using interface 0
>=20
>=20
> [jramirez@dali device.git (master%)]$ sudo ./usbdevice
> Receiving file
>=20
> Transfer rate =3D> 462 Mbits/sec [57MB/sec]
>  - file size : 58 MB
>  - time      : 1.12 sec
>=20
>=20
> As mentioned above, using the usb338x driver from PLX instead of the net2=
280 from
> kernel.org, the effective file transfer rate increases 1Gbps.

do you want to debug that and find the culprit since you're already at
it ?

>=20
>=20
> 3) Patch:
> ---------
>=20
>=20
>=20
> From 9b5ee9330c5c02cf51328c350036c1dac998b732 Mon Sep 17 00:00:00 2001
> From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
> Date: Thu, 25 Sep 2014 16:17:20 -0400
> Subject: [PATCH 2/3] usb: gadget: add USB3 support to the printer driver
>=20
> Add SS descriptors to support the capabilities provided by USB3 controller
> drivers; unit tests run using a PLX 3380 [max transfer speed measured of =
1Gbps]
>=20
> This driver shall fallback to lower operating modes when the higher ones =
are
> not available.
>=20
> Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
> ---
>  drivers/usb/gadget/legacy/printer.c | 65 +++++++++++++++++++++++++++++++=
++----
>  1 file changed, 59 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/legacy/printer.c b/drivers/usb/gadget/leg=
acy/printer.c
> index 6474081..456730b 100644
> --- a/drivers/usb/gadget/legacy/printer.c
> +++ b/drivers/usb/gadget/legacy/printer.c
> @@ -208,6 +208,43 @@ static struct usb_descriptor_header *hs_printer_func=
tion[] =3D {
>      NULL
>  };
> =20
> +/*
> + * Added endpoint descriptors for 3.0 devices
> + */
> +
> +static struct usb_endpoint_descriptor ss_ep_in_desc =3D {
> +    .bLength =3D              USB_DT_ENDPOINT_SIZE,
> +    .bDescriptorType =3D      USB_DT_ENDPOINT,
> +    .bmAttributes =3D         USB_ENDPOINT_XFER_BULK,
> +    .wMaxPacketSize =3D       cpu_to_le16(1024),
> +};

all your tabs have been converted into spaces. Perhaps try:

	$ git help send-email

and figure out how to use that ?

--=20
balbi

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJUa2MhAAoJEIaOsuA1yqREp0YP9iOtcYAmVtggUPi4NaeZjSGc
oe8eGY/geauQk5snptEEpPu5GdW3nyoDMvMSzB5QdJAsfmgDP0tz++HfppGE6fRA
Bx+uxgi6N5rouHS+5Va5Zxq6+JS7ZDRal4X+GH884slv9xOrVFyHw4lHnU3asyUj
qLi3Fe76gvLcniHK4qItMsQSxXWUbqkBBdejUVV7jn7vNXOrBIXTU+3+2LNP1t92
Z3Y7v+NYI9oKIeI+K0mZwcShBessWjbpUqbYLMusyQdxB9yF0rjctwoAGRLf6t7A
B0CtGVBumJYRK2hZpA0ebhrQZp6ct2eRxnrblDb56qT3yEkQZbGiB+WQNyZvlyUF
SjxuxyuPGDlMAle8SGw71TlWmkHe1aaLDCN5y0nv2ek19O3vjxV3355xDZ501Yhi
sStj4kZp/DlaszujV/rrf2XKoJ1rbyrMqS/9pnTeN+0vpk2ocNP5cdN54G2W9ZIc
EWh6h5LTjPNSKMI1pk9p1CQf/vh3zLnMC+JK7Mv/wlGEXgmybESUs9OwoZwdkWgb
9IwYXZZ+e9EYP1FCV0smMf1PBBnHwtEWfJavZ5r44T9asbM6v70Si+SU9Mr2lop0
ATp4yqDqII97f3/0P+tPT34eA4A1FIWZZ2iMS5mYgHkM1UtUCZoW7onbpsAqhLi6
m9EIkSkov/bK+qIbtl0=
=Bfe9
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
