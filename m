Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030406Ab3FTWSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 18:18:18 -0400
Received: from mailgw02.dd24.net ([193.46.215.43]:38620 "EHLO
	mailgw02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030350Ab3FTWSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 18:18:17 -0400
Subject: Re: support for Intel Atom based QNAP LEDs/buttons/buzzer in Linux?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20130620214207.GA12922@kroah.com>
References: <1371259861.12984.6.camel@heisenberg.scientia.net>
	 <1371687272.30351.13.camel@heisenberg.scientia.net>
	 <20130620025900.GA21820@kroah.com>
	 <1371763706.5197.6.camel@fermat.scientia.net>
	 <20130620214207.GA12922@kroah.com>
Content-Type: multipart/signed; micalg="sha1"; protocol="application/x-pkcs7-signature"; boundary="=-ST2CjALrLu8NRNmZeLyk"
Date: Fri, 21 Jun 2013 00:18:05 +0200
Message-ID: <1371766685.5197.35.camel@fermat.scientia.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ST2CjALrLu8NRNmZeLyk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Oh and one more thing:

The QNAP driver seems to be able to do much more than just
LEDs/HDD-LEDs/buzzers/buttons... at least their symbols imply such,
like:
#define QNAP_IOCTL_SATA_UP      0x0100
#define QNAP_IOCTL_SATA_DOWN    0x0200
#define QNAP_IOCTL_ESATA_UP     0x0300
#define QNAP_IOCTL_ESATA_DOWN   0x0400
#define QNAP_IOCTL_SATA_ERR     0x0500
#define QNAP_IOCTL_ETH_UP       0x0600
#define QNAP_IOCTL_ETH_DOWN     0x0700
#define QNAP_IOCTL_BOND_UP      0x0800
#define QNAP_IOCTL_BOND_DOWN    0x0900
#define QNAP_IOCTL_USB_DRV_RELOAD 0x0a00
#define QNAP_IOCTL_USB_SET_POLL_INTV 0x0b00

#define MD_RESYNCING				0x20
#define MD_RESYNCING_DONE			0x21
#define MD_RESYNCING_SKIP			0x22
#define MD1_REBUILDING				0x23
#define MD1_REBUILDING_DONE			0x24
#define MD1_REBUILDING_SKIP			0x25
#define MD1_RESYNCING				0x26
...

and much more (see drivers/qnap/pic.h of their kernel bundle).


I'm not sure whether it would be really a good idea for the end user to
use all these... the "normal" kernel drivers seem to handle all that
just fine.
Same applies for the cooling fan... there are PIC commands to control
it... (with my TS 569 Pro,... that didn't even work from within the
native QNAP firmware)... but fancontrol from lm-sensor already works
fine (any much more granular)... so I guess people should use that...
and it's not needed to add suport for that as well.



When you look at the model that I have (the TS-569 Pro[0]):
http://www.qnap.com/upload/album/24/m_929_20120726112135_59189.png

- The LCD already works, is a A125 device and controllable via an UART.
- The power button already works (normal ACPI button device)

- The buzzer does not yet work.
- With respect to the LEDs... from the native QNAP firmware I was able
to control the left-most one[1] (below the QNAP logo) and the ones
labelled STATUS[2] and USB[3].
- I'm not sure whether one can control the HDD-LEDs at all (but I'd hope
so[4])
- The other 3 buttons (in the image labelled COPY, ENTER, SELECT) do all
not work.



qcontrol (on some ARM based QNAPs) does a bit more and also allows to
set EuP mode and WOL...

One thing that could be interesting was, if it were possible really
power down SATA ports... could perhaps be QNAP_HDERR_ON(nr) /
QNAP_HDERR_OFF(nr)... or QNAP_SATAn_UP / QNAP_SATAn_DOWN ... but that's
just blind guessing.

Best wishes,
Chris.



[0]
http://www.qnap.com/useng/index.php?lang=3Den-us&sn=3D862&c=3D355&sc=3D526&=
t=3D692&n=3D9904
[1] These are the QNAP_PIC_POWER_LED_* in their code.
[2] These are the QNAP_PIC_STATUS_* in their code.
[3] These are the QNAP_PIC_USB_LED_* in their code.
[4] There is IOCTL_HD_ERROR_LED_SEND_MESSAGE and int
set_hd_error_led_on(int, int) in their code, which could be that.
[5] QNAP_PIC_WOL_* and QNAP_PIC_EUP_*

--=-ST2CjALrLu8NRNmZeLyk
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIQ/jCCBXUw
ggNdoAMCAQICAwEBgjANBgkqhkiG9w0BAQUFADBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwG
A1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290
MB4XDTEyMDcyMzE0NTY0NVoXDTE0MDcyMzE0NTY0NVowfDEhMB8GA1UEAxMYQ2hyaXN0b3BoIEFu
dG9uIE1pdHRlcmVyMSQwIgYJKoZIhvcNAQkBFhVjYWxlc3R5b0BzY2llbnRpYS5uZXQxMTAvBgkq
hkiG9w0BCQEWIm1haWxAY2hyaXN0b3BoLmFudG9uLm1pdHRlcmVyLm5hbWUwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQCq/4X3Urm/IHCIYUyqPrBN6FZ2pmd8V5epPyDlveqtdYvLBLNy
gP3G3KhGoCA4Jf49KYGmbqk+F7fVWcG1zcdwEx7itKJyj39nYf2HWXogxUSfKFptbOgpsTcEWuxg
ka2EkJuErTvYbwCEKT7mn4v6ScuFBc3Q+Hswlt1jbqjczi+OxcU1skvxM5jGjzRwYPUsiHZJRkWp
ogbbhNWZNbwXiMPln380TAlryRAr5UE0dSe1dg1qHhF6HSNKwaer0+Dcd/goL4XQhHxCAGZKfCK0
wVRf1SeEsS9FDGMMjW2b6HpHF+OVXuagjrxSWHttx0+Ez/PZDXpeZpjXatzzmlJFAgMBAAGjggEm
MIIBIjAMBgNVHRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlm
aWNhdGUgZm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzBABgNVHSUE
OTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQBgjcKAwQGCisGAQQBgjcKAwMGCWCGSAGG+EIE
ATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUHMAGGFmh0dHA6Ly9vY3NwLmNhY2VydC5vcmcwRAYD
VR0RBD0wO4EVY2FsZXN0eW9Ac2NpZW50aWEubmV0gSJtYWlsQGNocmlzdG9waC5hbnRvbi5taXR0
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


--=-ST2CjALrLu8NRNmZeLyk--

