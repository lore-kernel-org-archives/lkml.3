Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbaJEJbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 05:31:53 -0400
Received: from mout.web.de ([212.227.17.11]:63375 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaJEJbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 05:31:50 -0400
Message-ID: <54310FFF.10504@web.de>
Date: Sun, 05 Oct 2014 11:31:43 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, linux-usb <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: uas: module not loaded automatically
References: <54303DF6.4050203@web.de> <54310A74.3090404@redhat.com> <54310C04.5060008@web.de> <54310DF9.8070904@redhat.com>
In-Reply-To: <54310DF9.8070904@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="L1HsaMN1uqVkhqitSxm20B4UkgqJG0ksa"
X-Provags-ID: V03:K0:1vN8ItSL/mAtAshJbeYNV6msdamf6G1dBD9FVQxovxMLtub2/kJ
 cJ131kBGvccZnhjJ34v2wTBFc+mPiTNnsQEm0kdtEf+fMT22isx4XM8lGCdVwWCSwfJpCUb
 DS7BHS7iW0Ak0jJBFHpMwdl/QWpAlG3lQCcReIPuzcrPMHVns0AvvrWXwOagPzQmQbCNCNm
 Dn1P4HIePa3jDmcTRP/7w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L1HsaMN1uqVkhqitSxm20B4UkgqJG0ksa
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2014-10-05 11:23, Hans de Goede wrote:
> Hi,
>=20
> On 10/05/2014 11:14 AM, Jan Kiszka wrote:
>> On 2014-10-05 11:08, Hans de Goede wrote:
>>> Hi,
>>>
>>> On 10/04/2014 08:35 PM, Jan Kiszka wrote:
>>>> Hi,
>>>>
>>>> my Delock external USB drive stopped working after updating from a
>>>> UAS-disabled distro kernel to latest 3.17-rc7 with UAS on. That UAS =
was
>>>> key became clear to me only after looking at storage_probe(): the de=
vice
>>>> is ignored by usb-storage if it is UAS-capable. However, nothing cau=
ses
>>>> uas.ko to be loaded when the drive is plugged here. How is this supp=
osed
>>>> to work in the normal case?
>>>
>>> Is the uas.ko module installed, and was depmod run after installing i=
t ?
>>
>> Definitely. Just retried after another depmod -a, and only modprobe ua=
s
>> made it work.
>>
>>>
>>> uas.c has the following:
>>>
>>>         { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB=
_PR_BULK) },
>>>         { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB=
_PR_UAS) },
>>>
>>> Which should make it load automatically on your device.
>>
>> Should this match with what lsusb -v reports for the device?=20
>=20
> Yes, and it does, for both alt settings of your device:
>=20
>       bInterfaceClass         8 Mass Storage
>       bInterfaceSubClass      6 SCSI
>       bInterfaceProtocol     80 Bulk-Only
>=20
>       bInterfaceClass         8 Mass Storage
>       bInterfaceSubClass      6 SCSI
>       bInterfaceProtocol     98
>=20
> Where 98 =3D=3D USB_PR_UAS, seems you have an quite old lsusb if it doe=
s not

It says "007".

> know that though. Could it be the rest of your userspace is old too, an=
d is
> not smart enough to load all matching drivers, instead only loading the=
 first matching
> driver (which happens to be usb-storage) ?

OpenSUSE 13.1, all updates installed. Which components are involved?
udev - Version 208? Below is the udevadm monitor output.

Jan

PS: Let me know if I should carry this to a different list.


KERNEL[33578.169824] add      /devices/pci0000:00/0000:00:14.0/usb2/2-2 (=
usb)
ACTION=3Dadd
BUSNUM=3D002
DEVNAME=3D/dev/bus/usb/002/008
DEVNUM=3D008
DEVPATH=3D/devices/pci0000:00/0000:00:14.0/usb2/2-2
DEVTYPE=3Dusb_device
MAJOR=3D189
MINOR=3D135
PRODUCT=3D174c/5136/100
SEQNUM=3D3702
SUBSYSTEM=3Dusb
TYPE=3D0/0/0

KERNEL[33578.170171] add      /devices/pci0000:00/0000:00:14.0/usb2/2-2/2=
-2:1.0 (usb)
ACTION=3Dadd
DEVPATH=3D/devices/pci0000:00/0000:00:14.0/usb2/2-2/2-2:1.0
DEVTYPE=3Dusb_interface
INTERFACE=3D8/6/80
MODALIAS=3Dusb:v174Cp5136d0100dc00dsc00dp00ic08isc06ip50in00
PRODUCT=3D174c/5136/100
SEQNUM=3D3703
SUBSYSTEM=3Dusb
TYPE=3D0/0/0

UDEV  [33578.171899] add      /devices/pci0000:00/0000:00:14.0/usb2/2-2 (=
usb)
ACTION=3Dadd
BUSNUM=3D002
DEVNAME=3D/dev/bus/usb/002/008
DEVNUM=3D008
DEVPATH=3D/devices/pci0000:00/0000:00:14.0/usb2/2-2
DEVTYPE=3Dusb_device
ID_BUS=3Dusb
ID_MODEL=3D42514
ID_MODEL_ENC=3D42514
ID_MODEL_ID=3D5136
ID_REVISION=3D0100
ID_SERIAL=3DDelock_42514_200000000CB4
ID_SERIAL_SHORT=3D200000000CB4
ID_USB_INTERFACES=3D:080650:080662:
ID_VENDOR=3DDelock
ID_VENDOR_ENC=3DDelock
ID_VENDOR_FROM_DATABASE=3DASMedia Technology Inc.
ID_VENDOR_ID=3D174c
MAJOR=3D189
MINOR=3D135
PRODUCT=3D174c/5136/100
SEQNUM=3D3702
SUBSYSTEM=3Dusb
TYPE=3D0/0/0
USEC_INITIALIZED=3D578169821

KERNEL[33578.173903] add      /module/usb_storage (module)
ACTION=3Dadd
DEVPATH=3D/module/usb_storage
SEQNUM=3D3704
SUBSYSTEM=3Dmodule

KERNEL[33578.174036] add      /bus/usb/drivers/usb-storage (drivers)
ACTION=3Dadd
DEVPATH=3D/bus/usb/drivers/usb-storage
SEQNUM=3D3705
SUBSYSTEM=3Ddrivers

UDEV  [33578.174093] add      /devices/pci0000:00/0000:00:14.0/usb2/2-2/2=
-2:1.0 (usb)
ACTION=3Dadd
DEVPATH=3D/devices/pci0000:00/0000:00:14.0/usb2/2-2/2-2:1.0
DEVTYPE=3Dusb_interface
ID_VENDOR_FROM_DATABASE=3DASMedia Technology Inc.
INTERFACE=3D8/6/80
MODALIAS=3Dusb:v174Cp5136d0100dc00dsc00dp00ic08isc06ip50in00
PRODUCT=3D174c/5136/100
SEQNUM=3D3703
SUBSYSTEM=3Dusb
TYPE=3D0/0/0
USEC_INITIALIZED=3D8170188

UDEV  [33578.174319] add      /module/usb_storage (module)
ACTION=3Dadd
DEVPATH=3D/module/usb_storage
SEQNUM=3D3704
SUBSYSTEM=3Dmodule
USEC_INITIALIZED=3D578173906

UDEV  [33578.174448] add      /bus/usb/drivers/usb-storage (drivers)
ACTION=3Dadd
DEVPATH=3D/bus/usb/drivers/usb-storage
SEQNUM=3D3705
SUBSYSTEM=3Ddrivers
USEC_INITIALIZED=3D578174131



--L1HsaMN1uqVkhqitSxm20B4UkgqJG0ksa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlQxEAIACgkQitSsb3rl5xQy9ACbBGX5tG4y/BCJ2VITh2Hm+SrX
ztEAoK6AI7JNR2/nlt9YZ7T2raIrc4SF
=WkRp
-----END PGP SIGNATURE-----

--L1HsaMN1uqVkhqitSxm20B4UkgqJG0ksa--
