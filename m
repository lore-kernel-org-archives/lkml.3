Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaBEJxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:53:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54096 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437AbaBEJxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:53:22 -0500
Message-ID: <1391593985.3003.48.camel@deadeye.wl.decadent.org.uk>
Subject: Re: perf trace: Initial beautifier for ioctl's 'cmd' arg
From: Ben Hutchings <ben@decadent.org.uk>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 05 Feb 2014 09:53:05 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-glzWdRYALBnOLVfmqYYX"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.239
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-glzWdRYALBnOLVfmqYYX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Commit 78645cf3ed32860a3e83b8e35aa469f5b844a4ba introduced a build
failure on powerpc and sparc as it redefines TCGETS.  TCGETS doesn't
actually appear to be used, but in any case these and many other
architectures give it a different value than 0x5401.  In fact they have
mostly different numbering of tty ioctls, in two different ranges (type
byte may be 0x54 or 0x74).

Please do this properly (actually use the macros!) or revert it.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-glzWdRYALBnOLVfmqYYX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUvIKAee/yOyVhhEJAQqd9hAAhiQyQx1aM91r8b70ZqBnTn0x1/Mk7NpJ
r/jtPK4lHeeJPq3DYuQtgk56tcNsfwXRCLEGPE07SKgrMj60vWyDWwc2ZGBharFB
OamojAQV0Vg41HoKwJDt8SYWrz0HAGJlFmOazw9lxE2PkiuwRXIEDF2bL3z7/EKp
JTkcW0xTSfBDk4EIowARZzUOWP6TTXQHf6IPwjNpc/VjOxfH5x3bZ4PqpWMeA6UY
3EJgO6QZ2X9KzDpEiN+aBEbAGe9gSAPKRzE8X9cmbLh8vPrrelXuV+ljETdUF5gu
bCREVbGRFiDZbk3VhH9pMjJhtPr9YbpniGlcL2747oqu9azawtYguFaQAq0qx/E2
5vmGt7/j7meMhIY+nW25dxcjunoWwnuu/fiHV+Al3WYni9Jeu7Wj/dk3bFghocUU
6HLRyuv8fsgeL49Oajr8aUmCAE4BmJSIecqeyvR3tVQASdMRCE5CXA8cPqSSON5t
zG6URswwpf4DUo5jlemrWYuHwd4VPw9dMOE8ycIWIIO0ev3mcKA4A2FMAeEMOw1r
jqkhtYb4dvLw3JVp7+eDJ4YVYemgvskqr1yKuYbpuVVHMbsR9FChUOeZO9vkjfO5
6K+8DftpWStILSlKCpg/U6tRGypL6W7vVwbzDxRL29D7UtBjuOphXJrrfvdXvSSe
09N4DNd5an0=
=XfOs
-----END PGP SIGNATURE-----

--=-glzWdRYALBnOLVfmqYYX--
