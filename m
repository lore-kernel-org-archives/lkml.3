Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966109Ab3DQLfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 07:35:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36887 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965979Ab3DQLe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 07:34:59 -0400
Message-ID: <516E88A9.9070200@ti.com>
Date: Wed, 17 Apr 2013 14:34:01 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Device driver memory 'mmap()' function helper cleanup
References: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
In-Reply-To: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig6DE05481E5D3066F0088B3D7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig6DE05481E5D3066F0088B3D7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2013-04-17 06:12, Linus Torvalds wrote:
> Guys, I just pushed out a new helper function intended for cleaning up
> various device driver mmap functions, because they are rather messy,
> and at least part of the problem was the bad impedance between what a
> driver author would want to have, and the VM interfaces to map a
> memory range into user space with mmap.
>=20
> Some drivers would end up doing extensive checks on the length of the
> mappings and the page offset within the mapping, while other drivers
> would end up doing no checks at all.
>=20
> The new helper is in commit b4cbb197c7e7 ("vm: add vm_iomap_memory()
> helper function"), but I didn't actually commit any *users* of it,
> because I just have this untested patch-collection for a few random
> drivers (picked across a few different driver subsystems, just to make
> it interesting).  I did that largely just to check the different use
> cases, but I don't actually tend to *use* all that many fancy drivers,
> so I don't have much of a way of testing it.

Should there be a similar helper that uses remap_pfn_range() instead of
io_remap_pfn_range()?

Some fb drivers use remap_pfn_range(), and I'm not sure if there could
be some side effects on some platforms if they are changed to use
io_remap_pfn_range(). At least mips and sparc seem to have their own
versions for io_remap_pfn_range().

 Tomi



--------------enig6DE05481E5D3066F0088B3D7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRboitAAoJEPo9qoy8lh71NJcP/imSW2cgY4607og/jO4eRBgf
TjfvVTxWgDUdvNory1IHUm48Jz5Ah26eW3K3/pOJ6Y7a0b1O0NJbx8LENlcXRH4J
SPu6zfMQcThrQdjago+F5BObjKk8r5Epj+zfuFtDip1kXNLbL9gXmypBQqotfUQt
c93ujhgVdVcVM56kN7Ix79XRHWoawvcOY1YKJR8Py5j0ZrObIq7MBai6nqCEEIDO
gIEQTDwU3EeauAGLVDESSqo7bkYHZCVnTigkjMKWk/NVw49wEzRjV153XKT19OMF
omRV7nDCg5RcvYD+4PyXNof9Cge7q7QoSW3iYLmzoMvPdk3LunsL4f5JGHB/eiQq
YQDQsXJIcCVjBVT0zq8boty2r82Wni/Jb7vB2k6+HlEK8mGn3eRFGZ0vQGIZvIKW
hGEfsVeGZfVQhHCHxM19afLIb1M+Ot1JPN6FkQbm7Ota1rjGDggIWlH41k8nIsc+
u7zQXQqt4NHV82NsR/CfBBYEfesAN7q3Pl4z0nxZxh0y1TJopjH3w9fmIs9j6umY
GBtRpuXJSgoeHeEJcttkC3UhD3jMh386aSgigtqKuINxVmMS5aITWYggUMiwgah8
tiPOYX/lyOjRk2aQ469OCTIgshYdIzIRyxf+mAE5P1pIcTfneYKtnYauRIHk+kpm
ehCDmzO+CZz5lOZXzOdl
=Vgop
-----END PGP SIGNATURE-----

--------------enig6DE05481E5D3066F0088B3D7--
