Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab3GBAya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 20:54:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45412 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3GBAy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 20:54:28 -0400
Date: Tue, 2 Jul 2013 10:54:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the powerpc tree
Message-Id: <20130702105415.8579055c3539bbb3e3cacfbc@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Jul_2013_10_54_15_+1000_6lmMRLOZs4.YIL2+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Jul_2013_10_54_15_+1000_6lmMRLOZs4.YIL2+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the powerpc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

fs/pstore/ftrace.c: In function 'pstore_ftrace_call':
fs/pstore/ftrace.c:47:6: warning: passing argument 7 of 'psinfo->write_buf'=
 makes integer from pointer without a cast [enabled by default]
      sizeof(rec), psinfo);
      ^
fs/pstore/ftrace.c:47:6: note: expected 'size_t' but argument is of type 's=
truct pstore_info *'
fs/pstore/ftrace.c:47:6: error: too few arguments to function 'psinfo->writ=
e_buf'

Caused by commit 6bbbca735936 ("pstore: Pass header size in the pstore
write callback").

I have used the version from next-20130701 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Jul_2013_10_54_15_+1000_6lmMRLOZs4.YIL2+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR0iS8AAoJEECxmPOUX5FE/BEP/iW7+HjyytorMyGWIT7qo5VC
FqEX9wRwTGe63tTRZ/c9fds9ARm+LFruMB8az+WFbLHEloV+I0ESp3SHbVa9X4FC
LZb3HdxjY5HRfR15tc/xwu/dRhsLVt2hyds4u3D6gsT2c+XDMWSEZlakeeUph1+z
fShfX4S8zE//J10scU6OoYm+9dLEY1uT6pL7v2PYD5GpywX557mhtqXdroeYNmE8
POmGmHsYZoSuJBkZW/287EC66uUHG0TUUXNMf4282NDQsjpmuiXbWfvMIESNw/6v
+X8mKiR/7ZxZqFebG+5cjiiXdhTbIbecF8D4+AMQR3lAKXy6jh8EY3hnzGN0N56g
ltPOnSvhS4R6hjX0+6Ff0cI8YOwCrOdEqyzJVexYjSI2xNjiRRlOob94E8Tvqzi/
eTMvBN4NUnM6Ooz4IZjMpLEmiKHw8bfBXeBcq8Utvx4N8d2gFAFZgCrDdOpYOeU+
vdaAQWS8J1fleMpi5JJDDaA/XPfqBZbIekqzFfnjVwu2NX8vfMHR37Re0HoEAIw2
EZsfEFRlUR6CjGA+KcqWx1SVGemuZ8wXsevu14LgbUS2sMiaI5iX/DfpU548oW3D
KWkbWYax9lMc8ib/UKGDDHy4OCpl+vz6wJkKtuLvv95uQpzqngrPWHAz+XvPGF+A
m8+Rmh7sZ2hs5yaCq9so
=qlRT
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Jul_2013_10_54_15_+1000_6lmMRLOZs4.YIL2+--
