Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3J3BsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 21:48:21 -0400
Received: from scrye.com ([75.148.32.185]:46503 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3J3BsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 21:48:20 -0400
Date: Tue, 29 Oct 2013 19:48:13 -0600
From: Kevin Fenzi <kevin@scrye.com>
To: AceLan Kao <acelan.kao@canonical.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Nikolai Kondrashov <spbnick@gmail.com>
Subject: Re: ELAN Touchscreen regression in recent 3.12 rc's? (USB)
Message-ID: <20131029194813.06873684@voldemort.scrye.com>
In-Reply-To: <CAFv23QmGeGMCVAJCQHv8oDk_ZrXHKsemP1MHnn+uaQQ5DKoFOA@mail.gmail.com>
References: <20131028150250.755b4cc8@voldemort.scrye.com>
	<CA+5PVA5hB9CcoxqWPvF1uJymKMtfyGJv9Tkkh8bxOdAmM-jKkQ@mail.gmail.com>
	<CAFv23QmGeGMCVAJCQHv8oDk_ZrXHKsemP1MHnn+uaQQ5DKoFOA@mail.gmail.com>
Organization: Scrye, INC
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA512;
 boundary="Sig_/Gs9X7bFC/w/8FDAeR3exUh9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Gs9X7bFC/w/8FDAeR3exUh9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Oct 2013 09:41:06 +0800
AceLan Kao <acelan.kao@canonical.com> wrote:

> Hi,
>=20
> It's hard to believe that those quirks will lead to the problem.
> And actually, there are 4 new commits introduced to -rc7, and 3 of
> them are quirks.
>=20
> % git log --pretty=3Doneline v3.12-rc6..v3.12-rc7 drivers/hid
> 86b84167d4e67372376a57ea9955c5d53dae232f HID: wiimote: add
> LEGO-wiimote VID ad0e669b922c7790182cf19f8015b30e23ad9499 HID: Fix
> unit exponent parsing again 684524d35fe8d13be1f2649633e43bd02c96c695
> HID: usbhid: quirk for SiS Touchscreen
> 8171a67d587a09e14a4949a81e070345fedcf410 HID: usbhid: quirk for
> Synaptics Large Touchccreen
>=20
> CC'd Nikolai, since his commit changes the protocol.

Oddly, after a while it seems to have decided to stay on:=20

[ 4021.819962] usb 2-7: Manufacturer: ELAN
[ 4021.820163] usb 2-7: ep 0x2 - rounding interval to 64 microframes, ep de=
sc says 80 microframes
[ 4021.828338] input: ELAN Touchscreen as /devices/pci0000:00/0000:00:14.0/=
usb2/2-7/2-7:1.0/input/input221
[ 4021.828801] hid-multitouch 0003:04F3:016F.00D3: input,hiddev0,hidraw1: U=
SB HID v1.10 Device [ELAN Touchscreen] on usb-0000:00:14.0-7/input0
[ 4023.903599] usb 2-7: USB disconnect, device number 86
[ 4024.198444] usb 2-7: new full-speed USB device number 87 using xhci_hcd
[ 4024.211102] usb 2-7: New USB device found, idVendor=3D04f3, idProduct=3D=
016f
[ 4024.211143] usb 2-7: New USB device strings: Mfr=3D4, Product=3D14, Seri=
alNumber=3D0
[ 4024.211177] usb 2-7: Product: Touchscreen
[ 4024.211197] usb 2-7: Manufacturer: ELAN
[ 4024.211489] usb 2-7: ep 0x2 - rounding interval to 64 microframes, ep de=
sc says 80 microframes
[ 4024.219707] input: ELAN Touchscreen as /devices/pci0000:00/0000:00:14.0/=
usb2/2-7/2-7:1.0/input/input222
[ 4024.220555] hid-multitouch 0003:04F3:016F.00D4:
input,hiddev0,hidraw1: USB HID v1.10 Device [ELAN Touchscreen] on
usb-0000:00:14.0-7/input0

and it's been working since then. So, only after 87 cycles...=20

Some kind of weird race condition?

kevin

--Sig_/Gs9X7bFC/w/8FDAeR3exUh9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJScGVgAAoJEEs3sNgP+7te2VIP/ig+7qbHtNGvGyr/pURWBTW1
VHp6BdFYh9ErjSbjSohEf6KA6EK1cyTrJzu0gTrlRfrgczQR+UiHjXJlU/PxgCaY
mYsqIWVLpA/yB+8uQLEMEBGdpwFUoab9tgcehLia7VeHbVrUkg/RhlgiYP8fCZXz
L9GnWjQBdZavUGPE+abvd5l7ZrYlsB+/KwglW4H1rEtIHVCJ6FvVAE2N7OfxeF1M
pw97HI/0xm3jvEeMLMn0LKs92fMlmkeqKBnaoZQec/q+QkdacvLT2g/ezBlg2wfR
83C4qiRhlAwMFpGAfQYdIlTBtqW5oTczQn3sVcF3j0KFSUj8EawTnPv+J5KFa7+d
Z23Cw3pg6U1ocrbasBucCElBadgShec6iNbBDcGvRq1IQUEbXcj8ep4BCVVKEmy0
YmrNECPOEJWFdB6y944x8GObv7DjfYeu5gxDihHxUZN0Lgh2rdCw5QaWI9RospTM
ZO/9nrNpXdGXQKaD1McWAtBvlfsd/hVNH+ydCkM4UxTSZeL4deTpPbFuFq+SpoM0
IgY3Q3Z9kCagREQbVg9AyXb6RetqilRMPOYQaVGx1tMTy8Bz32Utg+UwFsTxW1DW
vA9vf3+7agix4epHugM89PmN0mAHpg0vKizvBOXw3ATWGZBJ1huvUKlhjYWhFt/a
WSNTKRzvccNjZy8UHhas
=w7A4
-----END PGP SIGNATURE-----

--Sig_/Gs9X7bFC/w/8FDAeR3exUh9--
