Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab3BEEUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 23:20:00 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:48759 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab3BEET7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 23:19:59 -0500
Date: Mon, 4 Feb 2013 22:19:53 -0600
From: William Hubbs <w.d.hubbs@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        mpagano@gentoo.org
Subject: Re: [PATCH] init: fix name of root device in /proc/mounts
Message-ID: <20130205041953.GA24029@linux1>
References: <1359672699-23540-1-git-send-email-w.d.hubbs@gmail.com>
 <510AFCA1.5000700@zytor.com>
 <1360032141.12062.12@driftwood>
 <a6a99589-ac94-4cfc-a871-095431bfd8ef@email.android.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <a6a99589-ac94-4cfc-a871-095431bfd8ef@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 04, 2013 at 06:54:32PM -0800, H. Peter Anvin wrote:
> The difference is that it used to be customary to have a /dev/root symlin=
k; iirc udev created one.  Devtmpfs does not (for largely valid reasons, bu=
t it does break some userspaces.)

Correct. The /dev/root symlink is not created any longer. If you boot
with an initramfs this path does not show up in /proc/mounts. If you
boot without one, however, it does.

This patch just makes the /dev/root path not show up at all in
/proc/mounts, regardless of whether an initramfs is used.

Thanks,

William

> Rob Landley <rob@landley.net> wrote:
>=20
> >On 01/31/2013 05:22:09 PM, H. Peter Anvin wrote:
> >> On 01/31/2013 02:51 PM, William Hubbs wrote:
> >> > On a system that does not use an initramfs, /dev/root was always
> >> > listed in /proc/mounts. This breaks software which scans =20
> >> /proc/mounts to
> >> > determine which file systems are mounted since /dev/root is not a =
=20
> >> valid
> >> > device name.
> >> >
> >> > This changes that processing so that "/dev/root" is only added to
> >> > /proc/mounts if a root device is not specified with the root=3D =20
> >> option on
> >> > the kernel command line.
> >> >
> >> > Signed-off-by: William Hubbs <w.d.hubbs@gmail.com>
> >>=20
> >> Let me also point out that most of the time, the kernel actually has
> >a
> >> udev device name for an actual device...
> >
> >So your software is broken by overmounts? /dev/root is just one example
> >=20
> >of this. (And you can specify a root=3D on the kernel command line and =
=20
> >have that be parsed by initramfs. I vaguely recall klibc does this...)
> >
> >For an example of how to parse this stuff, how about:
> >
> >   http://landley.net/hg/toybox/file/4ffb735aea59/toys/posix/df.c
> >
> >I.E. parse from the end of the list (most recent match is the =20
> >overmount), and eliminate synthetic filesystems. Note that code is from
> >=20
> >2006, other people have managed to cope all this time...
> >
> >Rob
>=20
> --=20
> Sent from my mobile phone. Please excuse brevity and lack of formatting.

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEQiGkACgkQblQW9DDEZTjLwwCgtfhvttEO+z0AU7FhpbqDMiC0
5FkAni/nU4hCPBIiBk6VRED7tVD8ViQO
=q0iY
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
