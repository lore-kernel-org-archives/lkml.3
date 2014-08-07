Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbaHGDU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 23:20:26 -0400
Received: from ozlabs.org ([103.22.144.67]:57859 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbaHGDUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 23:20:24 -0400
Date: Thu, 7 Aug 2014 13:20:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stewart Smith <stewart@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the modules tree
Message-ID: <20140807132017.2ec9e2ad@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/m+wFdk.w6RaqEicndyYXp72"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/m+wFdk.w6RaqEicndyYXp72
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the modules tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/platforms/powernv/opal-elog.c:85:28: error: macro "__ATTR_RO" =
passed 2 arguments, but takes just 1
  __ATTR_RO(id, elog_id_show);
                            ^
arch/powerpc/platforms/powernv/opal-elog.c:85:2: error: '__ATTR_RO' undecla=
red here (not in a function)
  __ATTR_RO(id, elog_id_show);
  ^
arch/powerpc/platforms/powernv/opal-elog.c:87:32: error: macro "__ATTR_RO" =
passed 2 arguments, but takes just 1
  __ATTR_RO(type, elog_type_show);
                                ^

And it went down hill from there ...

Caused by commit ba987e9b8ab1
("arch/powerpc/platforms/powernv/opal-elog.c: fix world-writable sysfs
files").

I have used the modules tree from next-20140725 again for today.

There is still the error in
arch/powerpc/platforms/powernv/opal-dump.c ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/m+wFdk.w6RaqEicndyYXp72
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4vB2AAoJEMDTa8Ir7ZwVZtAP/0BcXxCbeAdQ2twrwRK7u3he
a5pqAoLBrMgBi6KWTc6NZ5OFfnhN+W3aJtCtqK1bxsPfX+OmDtNHg/mpU12LM6Nl
E3CkRQQUHFxhHgg9hBW0FwhjLNiUTYA7003zWj9iZXQJnIRXM5aV7r1QsWJHIQqY
5BtB1SPUOBhijxYic5ucx7gK//+KxL5WQTcRohYIIRk7HE3Fow0lisrmMIUo/TG1
Z+CELDm/xNLX2w4b+cKFZGQho8wBitWynOCxQDK1PakhV+i3O1XCUCDpITcB1BG5
bZjnN1Rb/5j+3VD9AKLCYJSWA90hw3NXjsgFKkcpw96IzeYHAlXSNzUqgR/EJPGr
ctS+FHVh1jG6C8+OKDuCw6AbeAfJSVxU2tLeXlnEILNvUMUAur6HyJEW5i4nLX7j
jFOV3gMeEEpdXrf7lDiSq8BHlKpiyOeDYKy2AX6wkOTiI0zjoPtyE7N/N5he8NAc
qUA7i+ixy3iVOecbwwG4oxC3MG781nDXfuzGU7fSdj7O4mzYeQ+SK/FXgFSLgajp
yJVtcbqCRsd2KN2tCUMALUCdhZh53+E3Dv/fTVuNxgqKUMrOOti8i/K5vqgJisrx
9kc616OWXYVOAKkS0gev3L3Rx+ZD3NlbHS4+MHrT2kKAaAq4P4VXlJTAOP4nDVB5
2rnYpSCmaBIn259ijgn9
=xjB7
-----END PGP SIGNATURE-----

--Sig_/m+wFdk.w6RaqEicndyYXp72--
