Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaHOStY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:49:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43397 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaHOStX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:49:23 -0400
Date: Fri, 15 Aug 2014 20:49:11 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>,
        Robert Nelson <robertcnelson@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: Random MAC address on my BeagleBone White
Message-ID: <20140815184911.GJ17027@pengutronix.de>
References: <20140815134221.08c546a0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wHh0aNzodMFDTGdO"
Content-Disposition: inline
In-Reply-To: <20140815134221.08c546a0@gandalf.local.home>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:38:10 up 42 days,  5:14, 22 users,  load average: 0.21, 0.10,
 0.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wHh0aNzodMFDTGdO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

On Fri, Aug 15, 2014 at 01:42:21PM -0400, Steven Rostedt wrote:
> Hi,
>=20
> I'm using my BeagleBone White to debug some ftrace code and with the
> help from people like Robert Nelson I was finally able to boot it and
> test my kernel.
>=20
> But I'm still having some other issues. The most annoying one is that
> the new kernel assigns some random MAC address to my NIC and I can't
> give my board the proper IP address via DHCP.
>=20
> Seems there was talk about adding this via the device tree, but it was
> rejected because U-Boot can do it. The problem I have is that U-Boot
> doesn't!
>=20
> I downloaded the latest U-Boot from git://git.denx.de/u-boot.git (Is
> that the right place?) and had to tweak it so that I can boot a kernel
> via tftp and still use the filesystem on the SD card.
>=20
> When I place the 3.2 kernel that came with the board on my tftp server,
> all works fine. I get the same MAC addr each boot and things just work.
> But if I place the 3.16 kernel that I build on the tftp server, I get
> some random MAC address, and then a dynamic IP to go with it :-(
>=20
> This is in my dmesg:
>=20
> [    2.304970] cpsw 4a100000.ethernet: Random MACID =3D 8a:fc:f5:aa:b6:e1
>=20
> I can also see in the file arch/arm/boot/dts/am33xx.dtsi:
>=20
>=20
>                         cpsw_emac0: slave@4a100200 {
>                                 /* Filled in by U-Boot */
>                                 mac-address =3D [ 00 00 00 00 00 00 ];
>                         };
>=20
> Well, it's not filled in by U-Boot.
>=20
> My question to all of you is, how do I fix this? I need a static mac
> addr.
>=20
> One way is that I might have to update that file myself with a temp
> patch, but I think that's a hack and not something worth doing.
>=20
> What's the proper way to have the board always come up with the same
> MAC addr?

The am335x SoC already has 4 registers which contain two unique vendor
MAC addresses, so they should be used automatically instead of a random
one.

As you mentioned above, I sent a series to read and use those addresses
in the linux kernel. There were some problems with the series which I
fixed to send a new version of the series, but I didn't send it yet. I
will try to resend it tomorrow and Cc you. It would be great if you
could test it.

As far as I know, barebox also works with the beaglebone white and it
should set the correct MAC address as well. So if you need the same IP
address in linux as in the bootloader, you could try barebox.

Best Regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--wHh0aNzodMFDTGdO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7lYnAAoJEEpcgKtcEGQQca8QAIlV/dJjLRzKhJE/DJxYGwTu
EAMLQizt18T4qhOhn/P4YOqBh4GA5gOuvKD4IlOSj97HVqmMxD3pC9kLfiqi8nH7
o6lwb7w/bNMr/bKLWeKmcZeAE7pW3SUL/Ktwo0mJPYYXVY+5DNTAMhb10OXeXzFT
j8LOQJV0YTTpVrRMf0QxruE50ZhuMkECUsQpF5elkXwDXMazgq3YFqqQQADwrglC
E1ACzM4KNS7i3Hwt7pMxP14crGikoc/ZNTHY4bGtVU/voF4Z8OtllHhsn3OqROBJ
bEoBi8K+7ZrTqod0qQQ+edvl/lyhT/f10La8DFGQdA7zQDLP4/Bl/HGBuxj8l1Ye
4lZbpDuE4TJb/pElkcriGwtm1atpJnz9/W5slXcyChO9C+wSniRbMvjcGiIxwlQa
W3qcBkxnyv4v+FbrFdGRzK6LyJjSNPnmBjnN53GqV2nSVN/jzGrezIVXtZgWzeTR
bIoDLBQo8b6SdJInKJSzT+7wsuDjJ1I9txKKNuIm7kqCy+CQXw+KPAB9JIRS40WM
SXPkKcjpXdEloBcpgMa13A5/FqiLXjuX2YAysXc6W+5+SEFCvZb9/a3GW/9zIjPh
Ou2ydNHJdffC2At9CAhL7iYKj7yV2ZqKQzSeD2+/TmjcSCZdQg8wPnZyRFRrAOJQ
ZST6mZuG2yWSBoRmcRSh
=R3zR
-----END PGP SIGNATURE-----

--wHh0aNzodMFDTGdO--
