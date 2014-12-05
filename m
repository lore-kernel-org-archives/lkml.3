Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbaLEKce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:32:34 -0500
Received: from ozlabs.org ([103.22.144.67]:34320 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaLEKcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:32:32 -0500
Date: Fri, 5 Dec 2014 21:32:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the access_once tree
Message-ID: <20141205213224.2dcc20e9@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Q3FJ9YRcM4CyEjyPzaEmysE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Q3FJ9YRcM4CyEjyPzaEmysE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christian,

After merging the access_once tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/linux/compiler.h:189:0,
                 from include/uapi/linux/stddef.h:1,
                 from include/linux/stddef.h:4,
                 from include/uapi/linux/posix_types.h:4,
                 from include/linux/fdtable.h:8,
                 from security/apparmor/domain.c:16:
include/linux/types.h:14:9: error: unknown type name '__kernel_fd_set'
 typedef __kernel_fd_set  fd_set;
         ^

And many more :-(

Presumably caused by commit b06f66134856 ("kernel: Provide READ_ONCE
and ASSIGN_ONCE") which added types.h into compiler.h, but I am not
sure.  It could be an interaction with something else in linux-next, of
course.

I have dropped the access_once tree for today, sorry.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Q3FJ9YRcM4CyEjyPzaEmysE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUgYm9AAoJEMDTa8Ir7ZwVwd4P/0tByEyD8iU3HKPjNhVUNPLt
+W3RPgJ/gAf61gWLfg3ViNOqRP++qDElt9C1xUeUAzCjgaFQUVlCeuP59lAUfV67
y/BgabCsyCJob84GPCinKZNKqKzvybRgqD4fZVZZsrvxgjSr+0FI+acQgRCX5LWE
JVtZtZ7Div3C0H0NKE7qmzs5CkqJpQu9hrjz7gKmK8+4597DZ5M37ZmU2bhAIZan
PGcT+2QJJWQvLTWM6vOdsIiGmLjKbPX0ZA0cZaa8Q8y/OuIp1YEf40VL2g2Ev2Tq
St5d+158YN2M8g0ttC1c2TmmcwPGCAwRBCtnY+IfQ8tcPiJKt2Vw5778m7u41H5+
9zLBn3bgsCIq9OQ3kJltlKsvcBCj8w65lkovXMuwuN2r6Hbm4RyKZ0dbflxpZhMs
NgLOxlcXgtYqYna2C6YlvUxa5o1x0ygUANN4ixJQOcw02KzpsgIT2GtxlS6qkqQ4
+6fmLxkZcf8QvSe9KcoR/ufg2ixdwAMDYkXC2q6cnv4A0KcoJC0PiC8Uwxe6BaSr
kNVf2Y9oTUGNDVF9+XyTPlHDtHb46N3n25huclLG8tGTxvMDGhzSToyyK8e8LNmz
rEjHGE7h7ifjfAJuYXxCQIkoHEyIRM0jm/zOdbgTZ/EmWKsAwOfO+9QqwRIlDhC5
X4PH04RKDE6Nu/cKXXN6
=MrX9
-----END PGP SIGNATURE-----

--Sig_/Q3FJ9YRcM4CyEjyPzaEmysE--
