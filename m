Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaJEJO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 05:14:56 -0400
Received: from mout.web.de ([212.227.15.14]:54901 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbaJEJOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 05:14:51 -0400
Message-ID: <54310C04.5060008@web.de>
Date: Sun, 05 Oct 2014 11:14:44 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, linux-usb <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: uas: module not loaded automatically
References: <54303DF6.4050203@web.de> <54310A74.3090404@redhat.com>
In-Reply-To: <54310A74.3090404@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="McKpwgnWBnEu40kIScUUXHHAtRfxNcaIp"
X-Provags-ID: V03:K0:TfRSs2dZEOcl4rpA3WuQw85R8S49lnzUWQmCmluxXf76XxPigpw
 s53ULLr8jPNGaOdmZnjLwpgrH2nFOlbJfadAoYhhHapl7WzTSO+C2+ttIBDgJz6gmQSxnl5
 ku+jVPY6VMVRWMmXtpcf9VWDOqriGshhc4GUdKOvvL91aiCG3KGUOSllZjNtASQUmlh0ZiZ
 c3t2MZi999VGDQXjeRygw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--McKpwgnWBnEu40kIScUUXHHAtRfxNcaIp
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2014-10-05 11:08, Hans de Goede wrote:
> Hi,
>=20
> On 10/04/2014 08:35 PM, Jan Kiszka wrote:
>> Hi,
>>
>> my Delock external USB drive stopped working after updating from a
>> UAS-disabled distro kernel to latest 3.17-rc7 with UAS on. That UAS wa=
s
>> key became clear to me only after looking at storage_probe(): the devi=
ce
>> is ignored by usb-storage if it is UAS-capable. However, nothing cause=
s
>> uas.ko to be loaded when the drive is plugged here. How is this suppos=
ed
>> to work in the normal case?
>=20
> Is the uas.ko module installed, and was depmod run after installing it =
?

Definitely. Just retried after another depmod -a, and only modprobe uas
made it work.

>=20
> uas.c has the following:
>=20
>         { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_P=
R_BULK) },
>         { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_P=
R_UAS) },
>=20
> Which should make it load automatically on your device.

Should this match with what lsusb -v reports for the device? I have no
reference to a device with working UAS-probe.

Jan

>=20
> Regards,
>=20
> Hans
>=20
>=20
>>
>> lsusb of the device below.
>>
>> Jan
>>
>> ---
>>
>> Bus 001 Device 009: ID 174c:5136 ASMedia Technology Inc.
>> Device Descriptor:
>>   bLength                18
>>   bDescriptorType         1
>>   bcdUSB               2.10
>>   bDeviceClass            0 (Defined at Interface level)
>>   bDeviceSubClass         0
>>   bDeviceProtocol         0
>>   bMaxPacketSize0        64
>>   idVendor           0x174c ASMedia Technology Inc.
>>   idProduct          0x5136
>>   bcdDevice            1.00
>>   iManufacturer           2 Delock
>>   iProduct                3 42514
>>   iSerial                 1 200000000CB4
>>   bNumConfigurations      1
>>   Configuration Descriptor:
>>     bLength                 9
>>     bDescriptorType         2
>>     wTotalLength           85
>>     bNumInterfaces          1
>>     bConfigurationValue     1
>>     iConfiguration          0
>>     bmAttributes         0xc0
>>       Self Powered
>>     MaxPower              100mA
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       0
>>       bNumEndpoints           2
>>       bInterfaceClass         8 Mass Storage
>>       bInterfaceSubClass      6 SCSI
>>       bInterfaceProtocol     80 Bulk-Only
>>       iInterface              0
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x81  EP 1 IN
>>         bmAttributes            2
>>           Transfer Type            Bulk
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0200  1x 512 bytes
>>         bInterval               0
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x02  EP 2 OUT
>>         bmAttributes            2
>>           Transfer Type            Bulk
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0200  1x 512 bytes
>>         bInterval               0
>>     Interface Descriptor:
>>       bLength                 9
>>       bDescriptorType         4
>>       bInterfaceNumber        0
>>       bAlternateSetting       1
>>       bNumEndpoints           4
>>       bInterfaceClass         8 Mass Storage
>>       bInterfaceSubClass      6 SCSI
>>       bInterfaceProtocol     98
>>       iInterface              0
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x81  EP 1 IN
>>         bmAttributes            2
>>           Transfer Type            Bulk
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0200  1x 512 bytes
>>         bInterval               0
>>         Data-in pipe (0x03)
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x02  EP 2 OUT
>>         bmAttributes            2
>>           Transfer Type            Bulk
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0200  1x 512 bytes
>>         bInterval               0
>>         Data-out pipe (0x04)
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x83  EP 3 IN
>>         bmAttributes            2
>>           Transfer Type            Bulk
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0200  1x 512 bytes
>>         bInterval               0
>>         Status pipe (0x02)
>>       Endpoint Descriptor:
>>         bLength                 7
>>         bDescriptorType         5
>>         bEndpointAddress     0x04  EP 4 OUT
>>         bmAttributes            2
>>           Transfer Type            Bulk
>>           Synch Type               None
>>           Usage Type               Data
>>         wMaxPacketSize     0x0200  1x 512 bytes
>>         bInterval               0
>>         Command pipe (0x01)
>> Binary Object Store Descriptor:
>>   bLength                 5
>>   bDescriptorType        15
>>   wTotalLength           22
>>   bNumDeviceCaps          2
>>   USB 2.0 Extension Device Capability:
>>     bLength                 7
>>     bDescriptorType        16
>>     bDevCapabilityType      2
>>     bmAttributes   0x00000002
>>       Link Power Management (LPM) Supported
>>   SuperSpeed USB Device Capability:
>>     bLength                10
>>     bDescriptorType        16
>>     bDevCapabilityType      3
>>     bmAttributes         0x00
>>     wSpeedsSupported   0x000e
>>       Device can operate at Full Speed (12Mbps)
>>       Device can operate at High Speed (480Mbps)
>>       Device can operate at SuperSpeed (5Gbps)
>>     bFunctionalitySupport   1
>>       Lowest fully-functional device speed is Full Speed (12Mbps)
>>     bU1DevExitLat          10 micro seconds
>>     bU2DevExitLat        2047 micro seconds
>> Device Status:     0x0001
>>   Self Powered
>>



--McKpwgnWBnEu40kIScUUXHHAtRfxNcaIp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlQxDAgACgkQitSsb3rl5xTCJACguyGTBnfMSN9ffvQKvS/4Gzrk
dBQAoMvUN3YNxFgPG66vz2nyxvRCLq+r
=pkjZ
-----END PGP SIGNATURE-----

--McKpwgnWBnEu40kIScUUXHHAtRfxNcaIp--
