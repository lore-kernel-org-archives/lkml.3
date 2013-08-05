Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab3HEQVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:21:46 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47578 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab3HEQVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:21:42 -0400
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Peng Tao <bergwolf@gmail.com>, Kent Overstreet <koverstreet@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: next-20130805 - compile errors in drivers/staging/lustre/lustre/llite/file.c
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1375719606_1655P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Aug 2013 12:20:06 -0400
Message-ID: <6501.1375719606@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1375719606_1655P
Content-Type: text/plain; charset=us-ascii

Not sure how this train wreck happened - 'git log' shows the last patch to
touch include/linux/aio.h was some stuff of Kent's back in May, and 'git blame'
says the 2 lines of code that died were added on 2013-05-02.

It compiled when I build next-0730.

And yet, this morning, I get this building -0805:

  CC [M]  drivers/staging/lustre/lustre/llite/file.o
drivers/staging/lustre/lustre/llite/file.c: In function 'll_file_read':
drivers/staging/lustre/lustre/llite/file.c:1012:7: error: 'struct kiocb' has no member named 'ki_left'
  kiocb->ki_left = count;
       ^
drivers/staging/lustre/lustre/llite/file.c: In function 'll_file_write':
drivers/staging/lustre/lustre/llite/file.c:1071:7: error: 'struct kiocb' has no member named 'ki_left'
  kiocb->ki_left = count;
       ^
make[5]: *** [drivers/staging/lustre/lustre/llite/file.o] Error 1

Any ideas?  Only thing I can think of is that Kent's stuff went into some
tree in May, but only surfaced in linux-next in the last little bit...


--==_Exmh_1375719606_1655P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUf/QtgdmEQWDXROgAQKvNRAAth6vrgXH9xRD9dSqPjUcJEXfXq1fxnut
0VRqh7FKuGWeL0ERvPaya154BYNQ1b/HzOpVh2QApo7+gpMq1OD6BDkOCWeC+9Re
B2QFiC9YGH0HLq+WFOSA/UNu/+qWl373GpFWU7FbDYe/B+Mpgsj24Qb27zSb698T
FfWnExaCBcxmgYmdprL+3+ZsEz+shX9wff0vCMcd2P0UE9oIw6MmnRu1WedqxQLS
8mFMJBG0oLihayqPgapC5JpG75BQB57DfkBy+qjfP2gX2SqQSd/k3NNfZVcNzr3J
12wWi+L2w0DFZAUMXBblcbuBAgrfGo97tFNYSHt5eiZPmcWlXIBrUH0yFbE5A7Je
GGbxIVI4AQViZN0EqE8MihJpFniJfOmf0KeumQtBEdZf64baykEVuSnNk/j2E6kV
sa2DBTFd3ISdepVzDNvsO9bgScC+sUyKbj6Pt4FNC8/+vUen+2hAe9RoZMtpslHi
xijKUARbO82bqNWjtCRFaLYhE42aSlc95/Q/TpOGnY8YvnbSknbi64Pt318je7hE
Z+s0E5cmG4nmB2VdFPZMU4lE7+xrQ9xt6ZgY+aOkjXLAjczg3V1IFT5m3HXWGhtW
g1UwNKHq9xSI5rO6+K6/ReH4ZMgkKLp8yb2Y2bmq28Gn05Lpo0vGGRJNWsW+L1sp
pCfPb5s3IAs=
=mw7C
-----END PGP SIGNATURE-----

--==_Exmh_1375719606_1655P--
