Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3LTO57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:57:59 -0500
Received: from imp01.mtu.ru ([62.5.255.10]:46808 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab3LTO55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:57:57 -0500
X-Spam-Flag: NO
Message-ID: <52B45AEB.2060508@pavlinux.ru>
Date: Fri, 20 Dec 2013 18:57:47 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131118 Thunderbird/17.0.11
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12.5 CRASH/FREEZE
References: <52A9CC77.20904@linaro.org> <52AA1CC0.30307@pavlinux.ru> <20131220141008.GE10249@linutronix.de>
In-Reply-To: <20131220141008.GE10249@linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="AEubbuL1t5eJKN8bmIC5kjnp2jJE3aXDS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AEubbuL1t5eJKN8bmIC5kjnp2jJE3aXDS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

20.12.2013 18:10, Sebastian Andrzej Siewior =D0=BF=D0=B8=D1=88=D0=B5=D1=82=
:
> * Pavel Vasilyev | 2013-12-13 00:29:52 [+0400]:
>=20
>> On startup, if USB webcam (uvcvideo) attached in usb-hole
>>
>> NMI backtrace for cpu 0
>> CPU: 0 PID: 35 Comm: irq/43-xhci_hcd Not tainted 3.12.5-plx #6
>=20
>> [<c13aa59c>] xhci_queue_isoc_tx_prepare+0x39c/0x950
>> [<c139d35f>] xhci_urb_enqueue+0x22f/0x540
>> [<c1375745>] usb_hcd_submit_urb+0x65/0x280
>> [<c13777a0>] usb_submit_urb+0x170/0x3a0
>> [<c13e1ee8>] uvc_video_complete+0xb8/0xd0
>> [<c1374625>] __usb_hcd_giveback_urb+0x45/0xa0
>> [<c1374bd8>] usb_hcd_giveback_urb+0x38/0xf0
>> [<c13a84cf>] handle_tx_event+0x3af/0xda0
>> [<c13a9082>] xhci_irq+0x1a2/0x6c0
>> [<c13a95aa>] xhci_msi_irq+0xa/0x10
>> [<c1084c31>] irq_forced_thread_fn+0x21/0x70
>> [<c1085046>] irq_thread+0x106/0x220
>> [<c1057110>] kthread+0xd0/0xe0
>> [<c15083b7>] ret_from_kernel_thread+0x1b/0x28
>=20
> This looks like uvc is resubmitting the URB on completion. Nothing
> unusual. Howver it seems that then CPU gets stuck in
> xhci_queue_isoc_tx_prepare() for some reason. Could you try map c13aa59=
c

Same bug if attach to ehci hub.

ksoftird/0 process of loading the CPU upto 100%
Sometimes process irq17/0 - ehci_hcd  or xhci_hcd.
After taking the camera out of the socket, the load does not fall,
keyboard and console blocked


> to the source line? Something like
>   addr2lin -e xhci-hcd.ko -i c13aa59c
>=20
> should do the trick but of the module of this trace.
> What does the -plx stand for in localversion? Do you have any custom
> patches on your kernel?

No patches, just local flag.



--=20

                                                         Pavel.


--AEubbuL1t5eJKN8bmIC5kjnp2jJE3aXDS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCgAGBQJStFrrAAoJEPtok08Dny2hCGIQAMPwpx5II+muOaQzkVjBins5
c6c0DW+PsODwIqdMFzuYllk0apxJgm2o8P9v5diU3AulZKxd8PvspcrB4yGR9nSe
hRj78ZQpU0rvydXesnmn00scs8ixE2X43HRAfHREzyWqU09q7BnUUfxeLjYaDBsY
XrcwNQSVRWKi/D5ZnvdZJKfkl2PaTZ5iYcganUsL+9At6alPJh+YQWEKjsxKCiCu
Rd7p2Hmh0y0wE1C8JUpwdx+XtfHSBA5bDyuZt9WXOx+IrvjjabzNGAHuMf3M81Fc
aNsmEa0br/YD/dDKqL3a05wFj36reZqkU63/zYNryVBiww0SYYadvHbI8PGiH1Ic
ThoOd77J6im/ZwVe1eYwjkAN+JHYZqkGEEN6jR9zPfGlBUQAyOlsqjtBIb0U77sZ
OHptMTUajjm6V/7RQ6B9lxyELKDOm7AyXLZGyPGZim8RhnZ1vtzeLzU4pqHJ3HvH
tTWIeIyr+buCky45uccJV3+HOtGFCdXGQcjM4On5cm2N/sDdtX0fTUCql1naHTEt
v2hw8mroiZh6fQczBi9ywXRIaidqCBm/el0KS/BYYiMshf2uVhP9IHe2f/tZIVWN
NZ/wT0IJmS7k5Bzl2uKLWCaPnHCPur5VtmW8lhfD1o5JgVNAKwS7BzKz6o0G4OMW
fAD7yCzDPPUY+GZh8Wpf
=vgL6
-----END PGP SIGNATURE-----

--AEubbuL1t5eJKN8bmIC5kjnp2jJE3aXDS--
