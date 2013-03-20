Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216Ab3CTAUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:20:24 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:51429 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452Ab3CTAUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:20:23 -0400
Date: Tue, 19 Mar 2013 19:20:17 -0500
From: William Hubbs <w.d.hubbs@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, rob@landley.net, mpagano@gentoo.org,
        ryao@gentoo.org, gregkh@gentoo.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] init: fix name of root device in /proc/mounts
Message-ID: <20130320002017.GA2810@linux1>
References: <1359672699-23540-1-git-send-email-w.d.hubbs@gmail.com>
 <510AFCA1.5000700@zytor.com>
 <1360032141.12062.12@driftwood>
 <a6a99589-ac94-4cfc-a871-095431bfd8ef@email.android.com>
 <20130319222822.GA2338@linux1>
 <5148F1F7.7080706@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <5148F1F7.7080706@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2013 at 04:17:11PM -0700, H. Peter Anvin wrote:
> On 03/19/2013 03:28 PM, William Hubbs wrote:
> > The issue is that /dev/root appears in /proc/mounts if you do not
> > boot with an initramfs, but /dev/root is not a device node. In the
> > past, udev created a symbolic link from /dev/root to the
> > appropriate block device, but it does not do this any longer. Also,
> > devtmpfs does not create this symbolic link.
> >=20
> > This is causing bugs with software that depends on the existence
> > of /dev/root [2] for example.
>=20
> Seems okay to me, although even better would be to use the udev name
> of the device in question.

I'm not following what you mean.

The problem is that "/dev/root" should not be in /proc/mounts,
since there is always another entry that points to the root
file system.

William


--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlFJAMEACgkQblQW9DDEZTgeXACdEyNFrKVib9OBHvOqmUNpZ7tc
6ysAn0A4yNg8v0uBGOpYU3603hypEh5V
=zMga
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
