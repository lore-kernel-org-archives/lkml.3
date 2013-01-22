Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab3AVVqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:46:46 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63966 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3AVVqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:46:44 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: balbi@ti.com
Subject: Re: [PATCH] usb: gadget: nokia: Add mass storage driver to g_nokia
Date: Tue, 22 Jan 2013 22:46:39 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-22-generic; KDE/4.9.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358650693-29971-1-git-send-email-pali.rohar@gmail.com> <201301221203.09264@pali> <20130122161721.GC10097@arwen.pp.htv.fi>
In-Reply-To: <20130122161721.GC10097@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10536885.W9X8GMx9Bz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201301222246.39765@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10536885.W9X8GMx9Bz
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 22 January 2013 17:17:21 Felipe Balbi wrote:
> Hi,
>=20
> On Tue, Jan 22, 2013 at 12:03:09PM +0100, Pali Roh=C3=A1r wrote:
> > On Monday 21 January 2013 09:05:06 Felipe Balbi wrote:
> > > Hi,
> > >=20
> > > On Sun, Jan 20, 2013 at 11:17:31AM +0100, Pali Roh=C3=A1r wrote:
> > > > On Sunday 20 January 2013 10:25:37 Felipe Balbi wrote:
> > > > > On Sun, Jan 20, 2013 at 03:58:13AM +0100, Pali Roh=C3=A1r=20
wrote:
> > > > > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > > >=20
> > > > > NAK for two reasons:
> > > > >=20
> > > > > a) the original Nokia kernel used a separate
> > > > > g_file_storage gadget to use Mass Storage mode, use
> > > > > that
> > > > >=20
> > > > > b) there is no commit log
> > > >=20
> > > > Reason why add mass storage mode to g_nokia is to avoid
> > > > switching between g_{file,mass}_storage and g_nokia and
> > > > to have one gadget driver for Nokia N900. It is better
> > > > to have usb network and mass storage mode in one driver
> > > > (and not to unload & load another).
> > > >=20
> > > > I tested this patch with 3.8-rc3 kernel on Nokia N900
> > > > and usb network with mass storage mode working without
> > > > problems.
> > >=20
> > > Doesn't matter, in this case this is something which nokia
> > > wrote to carry on their Maemo/MeeGo devices so unless
> > > someone from Nokia says this is how they want to use
> > > nokia.c from now on, I can't simply risk breaking all
> > > other users for your own convenience.
> >=20
> > Hello,
> >=20
> > you may know that Nokia not working on any linux Maemo/MeeGo
> > systems anymore. And also that Nokia devices needs own
> > patched kernel. Also g_nokia gadget is for Nokia N900 and
> > this device with original Maemo 5 system which was
> > supported by Nokia is locked for patched 2.6.28 kernel.
> > More drivers in 2.6.28 was not upstreamed, so running other
> > kernels will not work without problems. And waiting what
> > Nokia say is now irrelevant, because
>=20
> nonsense, many guys (including myself) have n900 booting
> mainline kernel.
>=20

Hi,

this sounds good. Do you use some n900 specified patches with=20
upstream kernel? There are more drivers which are not present in=20
mainline (like bluetooth, camera or ssi).

To reduce divergence I created git repo for n900 patches on=20
gitorious https://gitorious.org/linux-n900/linux-n900 where I=20
pushing needed patched for n900 hw (now based on 3.8-rc3)

I know only few people which hacking n900 with upstream kernel.=20
And all are on freenode #maemo-alternatives channel. Everybody=20
with some new upstream kernel is welcome.

Btw, now I have working kernel drivers for charging battery on=20
n900, so charging is solved.

> > N900 is at end-of-live cycle and Nokia not doing with linux
> > devices anymore. So I do not understand why current code
> > cannot be extended for more functionality. Because patch is
> > not signed by Nokia?
>=20
> If I let your change in, you could be breaking the folks who
> are still using n900 as their daily device. Remember that
> Mass Storage access to the media, prevents phone from using
> mass storage too and the way Maemo 5 was done is that it will
> unload mass storage when that's not being used.
>=20

This is not truth. I commited more patched to CSSU ke-recv maemo=20
daemon (which handle pcsuite/mass storage mode and mounting=20
MyDocs and SD card) and I know how it working. That daemon do not=20
unload g_file_storage driver when mass storage mode is=20
deactivated. Instead it will call "echo > /sys/something/lun"=20
which cause to disconnect mmc device from gadget. This working=20
fine, because gadget is loaded with removeable param. And because=20
there are some other problems with BME and maemo kernel, you need=20
to have loaded some gadget for proper wall charger detection in=20
BME. And maemo upstart daemon loading g_file_storage at boot time=20
with none mmc device. So this is not problem.

If you can see at my patch, it will create mass storage gadget=20
with removable param too. So block device can be=20
attached/deattached from gadget at runtime without problem. Also=20
when gadget is loaded nothing is attached.

> > There are more developers which playing with upstream kernel
> > on Nokia N900 and trying to use some modern linux
> > distribution on it. And who using upstream kernels on N900
> > also want some additional functionality which was not in
> > 2.6.28. And having mass storage in g_nokia is usefull.
>=20
> it makes no difference.
>=20
> > Also you can see that this patch simply adding new composite
> > gadget to exisitng driver. Nothing is removed, so original
> > code is compatible with these changes. If somebody still
> > want (for
>=20
> you could be breaking phone's own access to the memory card.
>=20

No, because by default is nothing attached to gadget.

> > some reason) to switching between g_nokia and g_file_storage
> > (ops, it was renamed to g_mass_storage, so now it is broken
> > on old Nokia systems...) it is still possible.
>=20
> no it's not, you can anyways make a symbolic link. Besides,
> before removing g_file_storage we waited quite some time.
>=20
> > And when I looked into nokia 2.6.28 kernel, they also
> > patched g_file_storage, so I think it is incompatible with
> > upstream too.
>=20
> it's patched only for strings.
>=20

Not exactly, when I looked at diff there was some other code and=20
comments with "hacks". But changes for this are irrelevant now...

> > So why to care about current API implementation in upstream
> > kernel (do not allow to add new functionality) which is
> > incompatible with Nokia patched kernel?
>=20
> Because I don't think g_nokia needs mass storage and because I
> want to remove all gadget drivers from kernel (keep only
> function drivers).

Ok, if you remove all gadget from kernel, this will break=20
compatibility for sure.

And what will be equivalent of g_nokia? Will there be some=20
"universal" composite gadget (which will have support for serial=20
port, mass storage and usb network)?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart10536885.W9X8GMx9Bz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlD/CL8ACgkQi/DJPQPkQ1IiugCfZ4pOnOC0vaPZLQldLFZ9qskG
0ZAAnjfph9Rr6/kjVADS9CwRR2qTWnkD
=Ouw7
-----END PGP SIGNATURE-----

--nextPart10536885.W9X8GMx9Bz--
