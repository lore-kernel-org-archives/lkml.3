Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531AbaDBXFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:05:15 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:43776 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933450AbaDBXFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:05:11 -0400
Message-ID: <533C97A3.8080104@archlinux.org>
Date: Thu, 03 Apr 2014 01:05:07 +0200
From: =?windows-1252?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: USB autosuspend causing trouble on Intel bluetooth (Linux 3.14)
References: <533C8F3C.6090306@archlinux.org> <922DC347-921E-4B82-9843-7758BD096854@holtmann.org>
In-Reply-To: <922DC347-921E-4B82-9843-7758BD096854@holtmann.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="No2FvojEB9v8PXVlVC8tLLw77Xg2RV5a5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--No2FvojEB9v8PXVlVC8tLLw77Xg2RV5a5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Am 03.04.2014 00:39, schrieb Marcel Holtmann:
> Hi Thomas,
>=20
>> The culprit is USB autosuspend. When I explicitly disable it (echo 'on=
'
>>> power/control), the mouse works fine again. However, due to the
>> aforementioned commit, I need to do this manually after every boot and=

>> every resume, because btusb keeps setting it back to 'auto'. I have
>> found no way of overriding this behaviour.
>=20
> what USB controller do you have your Bluetooth controller attached to. =
I had the same issue, but it went away when some of the xHCI host control=
ler fixes got merged. Some other reported issues with some USB 2 controll=
ers.

Thanks for replying to me here and on IRC. In order for nothing to get
lost, I am reposting what I mentioned on IRC here.

$ lspci|grep USB
00:14.0 USB controller: Intel Corporation Lynx Point-LP USB xHCI HC (rev =
04)
00:1d.0 USB controller: Intel Corporation Lynx Point-LP USB EHCI #1 (rev =
04)

$ lsusb -t
/:  Bus 03.Port 1: Dev 1, Class=3Droot_hub, Driver=3Dehci-pci/3p, 480M
    |__ Port 1: Dev 2, If 0, Class=3DHub, Driver=3Dhub/8p, 480M
        |__ Port 5: Dev 3, If 0, Class=3DChip/SmartCard, Driver=3D, 12M
/:  Bus 02.Port 1: Dev 1, Class=3Droot_hub, Driver=3Dxhci_hcd/4p, 5000M
/:  Bus 01.Port 1: Dev 1, Class=3Droot_hub, Driver=3Dxhci_hcd/9p, 480M
    |__ Port 6: Dev 2, If 0, Class=3DVendor Specific Class, Driver=3D, 12=
M
    |__ Port 7: Dev 5, If 0, Class=3DWireless, Driver=3Dbtusb, 12M
    |__ Port 7: Dev 5, If 1, Class=3DWireless, Driver=3Dbtusb, 12M
    |__ Port 8: Dev 4, If 0, Class=3DVideo, Driver=3Duvcvideo, 480M
    |__ Port 8: Dev 4, If 1, Class=3DVideo, Driver=3Duvcvideo, 480M

This looks like it is attached to the xhci controller.

Output from bluemoon is as follows:

Bluemoon configuration utility ver 5.16
Controller Version Information
Hardware Platform: 55
Hardware Variant: iBT 2.0 (0x07)
Hardware Revision: 1.0
Firmware Variant: BT IP 4.0 (0x01)
Firmware Revision: 8.0
Firmware Build Number: 2-3.2013
Firmware Patch Number: 51

> You can easily check by running the "Inquiry (LIAC)=94 test from tools/=
hci-tester. Problem is that some of the HCI events are not making it to t=
he host. They get delivered as soon as the device wakes up again. In this=
 test case it is the Inquiry Complete event. If you poke the controller a=
nd send a new command, the even will be magically dequeued.

I cannot figure out how to compile hci-tester. The Makefiles from
bluez.git won't build it.



--No2FvojEB9v8PXVlVC8tLLw77Xg2RV5a5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTPJejAAoJEChPw0yOSxolWgEQAIGKngCFJhV3AT35LGTxQgZl
ghzpG1yR364M6hvhsW92+ocUgAzV+LzENQYDmFMrYDkkx9daMB09oLN0xWdIX2n9
rXUqd0JAJGaO0iQ9oC+wmPIuTlIhW0ZXsrZfYH73gtKQctXeW3q+WWb8DNZjztV2
tk6NNfgoQLNXcpjAPOfMgoi8Vc80URum7s+xjHr4kvO4ZkDPm3GdRx3DSl6IVwsH
6RndGdKPBT5b1PhiH47ePx9/kWrFUfh3Pnl8I3/RJfiVVjLs8MigIODcUMq4DIo3
J5q6cTMFRAqztaLhkv6uZdoC6gqfYaL98stn0fBElV3oqjuSIf9RAYLMOiG7PI6v
Kmg9G9iHnzxTROYggLY83xZxtI/amEDq0qVAWKG2kap34lSbSELG1vDil75uliJl
LVCC49jaGOQBhp2SlrRuu20Gy8gsQR7Ygi4qeKsNX55T+o59yuhUMTv+BSmI8xoj
EC+jNB+e7yAgH58obXCvOVkIlvhPS6DG778BCOhSLgxidExjknCzEltMWAUqRVVK
tavaFS4s1/67Ml05hZpAY9kRKfE4loloBYeCNGrwyam+lXD75zRtqP00ed9RNyEi
WvbW85wvuPj6sZOiMdXoRgrdBh+GXy7cgKoHnTxfgtqlFiVybS3OSSouJ+/CnlTA
0PcEStMpMwddS2jlnAMH
=KwoM
-----END PGP SIGNATURE-----

--No2FvojEB9v8PXVlVC8tLLw77Xg2RV5a5--
