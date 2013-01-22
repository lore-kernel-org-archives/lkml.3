Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3AVLDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:03:18 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35767 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3AVLDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:03:17 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: balbi@ti.com
Subject: Re: [PATCH] usb: gadget: nokia: Add mass storage driver to g_nokia
Date: Tue, 22 Jan 2013 12:03:09 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-22-generic; KDE/4.9.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358650693-29971-1-git-send-email-pali.rohar@gmail.com> <201301201117.32096@pali> <20130121080506.GA8777@arwen.pp.htv.fi>
In-Reply-To: <20130121080506.GA8777@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2852207.8fKV1q5sr4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201301221203.09264@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2852207.8fKV1q5sr4
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 21 January 2013 09:05:06 Felipe Balbi wrote:
> Hi,
>=20
> On Sun, Jan 20, 2013 at 11:17:31AM +0100, Pali Roh=C3=A1r wrote:
> > On Sunday 20 January 2013 10:25:37 Felipe Balbi wrote:
> > > On Sun, Jan 20, 2013 at 03:58:13AM +0100, Pali Roh=C3=A1r wrote:
> > > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > >=20
> > > NAK for two reasons:
> > >=20
> > > a) the original Nokia kernel used a separate
> > > g_file_storage gadget to use Mass Storage mode, use that
> > >=20
> > > b) there is no commit log
> >=20
> > Reason why add mass storage mode to g_nokia is to avoid
> > switching between g_{file,mass}_storage and g_nokia and to
> > have one gadget driver for Nokia N900. It is better to have
> > usb network and mass storage mode in one driver (and not to
> > unload & load another).
> >=20
> > I tested this patch with 3.8-rc3 kernel on Nokia N900 and
> > usb network with mass storage mode working without
> > problems.
>=20
> Doesn't matter, in this case this is something which nokia
> wrote to carry on their Maemo/MeeGo devices so unless someone
> from Nokia says this is how they want to use nokia.c from now
> on, I can't simply risk breaking all other users for your own
> convenience.
>=20

Hello,

you may know that Nokia not working on any linux Maemo/MeeGo=20
systems anymore. And also that Nokia devices needs own patched=20
kernel. Also g_nokia gadget is for Nokia N900 and this device=20
with original Maemo 5 system which was supported by Nokia is=20
locked for patched 2.6.28 kernel. More drivers in 2.6.28 was not=20
upstreamed, so running other kernels will not work without=20
problems. And waiting what Nokia say is now irrelevant, because=20
N900 is at end-of-live cycle and Nokia not doing with linux=20
devices anymore. So I do not understand why current code cannot=20
be extended for more functionality. Because patch is not signed=20
by Nokia?

There are more developers which playing with upstream kernel on=20
Nokia N900 and trying to use some modern linux distribution on=20
it. And who using upstream kernels on N900 also want some=20
additional functionality which was not in 2.6.28. And having mass=20
storage in g_nokia is usefull.

Also you can see that this patch simply adding new composite=20
gadget to exisitng driver. Nothing is removed, so original code=20
is compatible with these changes. If somebody still want (for=20
some reason) to switching between g_nokia and g_file_storage (ops,=20
it was renamed to g_mass_storage, so now it is broken on old=20
Nokia systems...) it is still possible.

And when I looked into nokia 2.6.28 kernel, they also patched=20
g_file_storage, so I think it is incompatible with upstream too.=20
So why to care about current API implementation in upstream=20
kernel (do not allow to add new functionality) which is=20
incompatible with Nokia patched kernel?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2852207.8fKV1q5sr4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlD+ce0ACgkQi/DJPQPkQ1KimACcCvMpObAw6rEAaBMHVlLuYJG+
b9MAoKHmMd9JfIp7izVBL7aGPXH0rwKp
=77P3
-----END PGP SIGNATURE-----

--nextPart2852207.8fKV1q5sr4--
