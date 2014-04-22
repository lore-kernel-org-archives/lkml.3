Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaDVB1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 21:27:01 -0400
Received: from pide.tip.net.au ([101.0.96.218]:50423 "EHLO pide.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbaDVB1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 21:27:00 -0400
Date: Tue, 22 Apr 2014 11:26:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20140422112653.bff070556db8f7d28187695a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Apr_2014_11_26_53_+1000_ci96lqytTXbjh=qD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Apr_2014_11_26_53_+1000_ci96lqytTXbjh=qD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/nfs/direct.c: In function 'nfs_direct_read_schedule_iovec':
fs/nfs/direct.c:382:4: error: implicit declaration of function 'vfree' [-We=
rror=3Dimplicit-function-declaration]
    vfree(pagevec);
    ^

Caused by commit 2703e4cd2d57 ("new helper: iov_iter_get_pages_alloc()").

I have used the vfs tree from next-20140417 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_Apr_2014_11_26_53_+1000_ci96lqytTXbjh=qD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVcViAAoJEMDTa8Ir7ZwVTRcP/1Tztv/XoVMTywX+pNuYhy3i
WF0kXEWRY00GvFEulvQ8tFUx0oE1mja8xc+1h6uqECa4wqCPljEGaYLd7WvYWh0i
qsn8xBQysXypvtcTvknZYbkUvL6HX4N2e1vm779Mm164rNj0BLudrRBXJgaH1PPR
OiXirz2Fdh1xZ65toymqN6BHL44C/vjwspWlLhmzDZQR0XlWzw0zD1YRTafL0e7a
hfn1YsTTT6NTrOZxKkZnc9cPRuMcGM00hUkIjSX8yyFQVYLjswxH/yRVBc62BFb5
6n176Bhq9/OgACaAptarUcEXtGU4d7lKMc+es7FknieTsmuYXd4ItB8xFFwZ6404
eafvNIIy5KjTm/iOL54hpQ6nsjfLGWEcXTLBF+v66lR/yQtVG1GVQ262un17+XP+
BQsqw9KbccbE5Oz7wYrQUUGVu83VYbsgVUoT95o43o4CBci6Fwt11u52eb2sLtC/
WHgg9nOj/wHwh9wfYLVq0VUIL502TNNxM2WwkdTt4qzNkpe34tulQqOUFb8ukBF4
8dkV5SWdoDLrLmclE17y83tjrh/ohEvMFYCaGaZJ0GGtCTZAc0X2jEzIV3t7YZdH
pDxIBMY0gzOGCldoSL1fh4jTH5dmnISBCcMeEscXbwHqWsGrcX94CAYRNqVlXScn
IAsjAGF3OVTjQNODti0t
=BduS
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Apr_2014_11_26_53_+1000_ci96lqytTXbjh=qD--
