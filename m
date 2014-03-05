Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbaCERxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:53:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42868 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaCERxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:53:21 -0500
Date: Wed, 5 Mar 2014 11:53:16 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: ecryptfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ecryptfs log spew from EINTR
Message-ID: <20140305175316.GA20812@boyd>
References: <53175BB0.1020107@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <53175BB0.1020107@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2014-03-05 09:15:28, Dave Hansen wrote:
> I have a little program that uses mmap() to copy files.  Essentially:
>=20
> 	addr1 =3D mmap(fd1);
> 	addr2 =3D mmap(fd2);
> 	memcpy(addr1, addr2, len);
>=20
> If these files are on ecryptfs and I interrupt the memcpy() with ^C, I
> consistently get this in dmesg:
>=20
> ecryptfs_decrypt_page: Error attempting to read lower page; rc =3D [-4]
> ecryptfs_readpage: Error decrypting page; rc =3D [-4]
>=20
> -4 is, of course -EINTR because of the ^C.  Should we be suppressing the
> message when we see EINTR?

Yes. In fact, eCryptfs shouldn't print a KERN_ERR message at all in this
situation. KERN_DEBUG at most. eCryptfs is too chatty in many cases.

I'd like to switch over to the pr_* functions and downgrade many log
messages to pr_debug() at that time.

Tyler

> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTF2SMAAoJENaSAD2qAscK2E4P/3CP73udYFc9WE3RNc5WAjra
FO/aRl5OXxmY7wSjQMexod9lQZnLd9uiLzXHcOnQ0462bpeG8i9mBWxOQKo6L0EA
MMw02I0dp+P2g24LPEIxsB33NeQ0o7uw00GQoZLQY9D5TJ2o9nK87k2skK86GbHn
KEtVk8WP9PImfbtpFTiDnEG+2w5weFMcHjFd15AvusyX0/0EFArxf+ToFzCNjEuS
rYkLyvJ3D5k2KwaOBecYKaxwLYOSm9JLYS1fIBkeJRYUGdpaXviCf2KPTErD0kml
1CF3Banfus0Xdbp8GTJYJOTrCAvbx1UsqE5dO7MLSwBlpemMtloD5EYXFWB3mIjI
fcY36+eHEfEJXo8rHbuvAYC/ajHj8t5eCti9NrQTstf3ff1Bkw2m6mzjqKe4OE1+
KWNvRYO6QT43zEvNH4/xyhHovzrMffiSwvzXsuOlTcW3eJXtv7YjvOxCyH47Sn3K
G68ZvwCCmn744i3PvQ51uNL01wPnaI9xZuYLrHaYvj1NsSYJnC8dceHic1XigksP
B69siPlGCmqyX6ip/bURIa6v3nLTDv3X/NgNP7ynuxPKSq1oGa7IxgBjmanz3aVx
DZlfT17HIJZpt+Pjvtvo0rkfmBKROnPbtKY3E6pRKY3sh4JInRO9bm7rPtdhGY7F
kFT4XtVuG8WZ1ih0zvsS
=IrLE
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
