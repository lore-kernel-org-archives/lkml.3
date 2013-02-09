Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab3BIVdJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 16:33:09 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49795 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758694Ab3BIVdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 16:33:07 -0500
Date: Sat, 9 Feb 2013 15:32:59 -0600
From: William Hubbs <w.d.hubbs@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mpagano@gentoo.org, w.d.hubbs@gmail.com
Subject: Re: [PATCH] init: fix name of root device in /proc/mounts
Message-ID: <20130209213259.GA3699@linux1>
References: <1359672699-23540-1-git-send-email-w.d.hubbs@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <1359672699-23540-1-git-send-email-w.d.hubbs@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 04:51:39PM -0600, William Hubbs wrote:
> On a system that does not use an initramfs, /dev/root was always
> listed in /proc/mounts. This breaks software which scans /proc/mounts to
> determine which file systems are mounted since /dev/root is not a valid
> device name.
>=20
> This changes that processing so that "/dev/root" is only added to
> /proc/mounts if a root device is not specified with the root=3D option on
> the kernel command line.

I want to follow up on this patch since I haven't heard anything for a
while.

Again, the basic problem I am trying to address is that /dev/root is not
a valid device (there isn't a device node for it in devtmpfs and udev
doesn't create a symlink for it), so it should not appear in
/proc/mounts, but currently it does if you boot a system without an
initramfs.

Are there any more questions or concerns about this patch? If not, what
is the status for getting it, or another fix for this issue, committed?

Thanks much,

William


--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEWwIsACgkQblQW9DDEZTiQIQCgrAcYdwvQgfNBmoFXIe4JZlho
xUcAoLA4qDcBBAqfK4vEiBU0fOZYkSpq
=JmFN
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
