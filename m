Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab3CTVLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:11:32 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:41557 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3CTVLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:11:30 -0400
Date: Wed, 20 Mar 2013 16:11:25 -0500
From: William Hubbs <williamh@gentoo.org>
To: Rob Landley <rob@landley.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mpagano@gentoo.org, ryao@gentoo.org, gregkh@gentoo.org,
        torvalds@linux-foundation.org, w.d.hubbs@gmail.com, kay@vrfy.org
Subject: Re: [PATCH] init: fix name of root device in /proc/mounts
Message-ID: <20130320211125.GA26595@linux1>
References: <20130320002017.GA2810@linux1>
 <1363763000.15703.47@driftwood>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <1363763000.15703.47@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2013 at 02:03:20AM -0500, Rob Landley wrote:
> On 03/19/2013 07:20:17 PM, William Hubbs wrote:
> > On Tue, Mar 19, 2013 at 04:17:11PM -0700, H. Peter Anvin wrote:
> > > On 03/19/2013 03:28 PM, William Hubbs wrote:
> > > > The issue is that /dev/root appears in /proc/mounts if you do not
> > > > boot with an initramfs, but /dev/root is not a device node. In the
> > > > past, udev created a symbolic link from /dev/root to the
> > > > appropriate block device, but it does not do this any longer. =20
> > Also,
> > > > devtmpfs does not create this symbolic link.
> > > >
> > > > This is causing bugs with software that depends on the existence
> > > > of /dev/root [2] for example.
> > >
> > > Seems okay to me, although even better would be to use the udev name
> > > of the device in question.
> >=20
> > I'm not following what you mean.
> >=20
> > The problem is that "/dev/root" should not be in /proc/mounts,
> > since there is always another entry that points to the root
> > file system.
>=20
> What gave you that idea?
>=20
> wget http://landley.net/aboriginal/bin/system-image-i686.tar.bz2
> extract it and ./run-emulator.sh and in there:
>=20
> (i686:1) /home # cat /proc/mounts
> rootfs / rootfs rw 0 0
> /dev/root / squashfs ro,relatime 0 0
> proc /proc proc rw,relatime 0 0
> sys /sys sysfs rw,relatime 0 0
> dev /dev devtmpfs rw,relatime,size=3D63072k,nr_inodes=3D15768,mode=3D755 =
0 0
> dev/pts /dev/pts devpts rw,relatime,mode=3D600 0 0
> /tmp /tmp tmpfs rw,relatime 0 0
> /home /home tmpfs rw,relatime 0 0
>=20
> Userspace can totally determine what /dev/root points to, I made mdev =20
> do it in 2006 (udev started doing so shortly thereafter). Busybox git =20
> commit a7e3d052.:4

There are situations where it doesn't work though -- suppose that root
is btrfs for example.

Also, the other message that answered you is correct, the udev
maintainers say we should not be relying on /dev/root at all so to make
it work distro packagers have to add a rule themselves.

Kay,

if you are reading, canyou jump in and explain why /dev/root is a bad
idea?

Thanks,

William


--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlFKJf0ACgkQblQW9DDEZThJ9ACfYij6vbyUI4wdI365LAo3Qgl8
BtYAn0Ur31q+vawOpFhGf97Ppahks+gi
=8c7E
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
