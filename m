Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbaIZKmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:42:09 -0400
Received: from ozlabs.org ([103.22.144.67]:41966 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167AbaIZKmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:42:07 -0400
Date: Fri, 26 Sep 2014 20:42:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: linux-next: build warning after merge of the akpm-current tree
Message-ID: <20140926204200.3e2175cc@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/jd3.swu3bv8WKJ4wmtv3GTe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jd3.swu3bv8WKJ4wmtv3GTe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

drivers/of/of_reserved_mem.c: In function 'of_reserved_mem_device_init':
drivers/of/of_reserved_mem.c:253:3: warning: 'return' with no value, in fun=
ction returning non-void [-Wreturn-type]
   return;
   ^
drivers/of/of_reserved_mem.c:259:3: warning: 'return' with no value, in fun=
ction returning non-void [-Wreturn-type]
   return;
   ^

Caused by commit 1a29544cc8c9 ("drivers: of: add return value to
of_reserved_mem_device_init").  This patch changed the return type of a
function but did not update any or the return statements in that
function.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/jd3.swu3bv8WKJ4wmtv3GTe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJUL9AAoJEMDTa8Ir7ZwV/ecQAI8BMSU1HwNrBCzpwhS0SK2+
5nb6o5GilDnKCus/Q3m/WxSuE3KFdG8rzstPMG4r3AgnAVacv4aXQUrmsE7oTAo/
n0I1HYG7v+l7+okWDPqh8ELShSr9zGBM5xZwwg/GGseN21JwxmWBe7yl9JcvjQYF
ZJBE61iP5wWQgoQ5qnKQaJKR+WML2T4z0uE53F2v8x3vlhYNVoAH4pUjmWZ3qjdf
M3PF1Genkb0v8dA3ul2BRCZekFqidOSpj0kaS0ObdkbqtFJWGJTlg8X3AXySJxiC
rhRc3ssM2aasaC0EgSOkOA0wzGfn452sqiVcyFGm5IA17Wi4ym9G8RcbIZWZdcHa
bjyOtjPVcOB3exfVQz9qxN+MSW7A+Fm0YP5V6/cRxfk1MGd5Kbbyw9sbHtxGKtAd
RbhMT8mkj46VdCLwJWg2IJ6oCgYlxFgNitGmc/5bUXbUbNhOxKNC5n9MHXrK55H4
8oHrICNWUiO8dU5hEM5fcQ+hE+Khx6l1uSIbYzpN+ChT5eGR/Hi1f7tPiocdnviv
2jnQz8qyj+t8vB1KfSDkl7bD52gWBzWQ9j7ybHCvyl98Qhyp6hZgIZD4jkzQlVFa
KFcfSD33UgBO62ncPTxkoctgC/YdJXHfKCpEpeyEI4etWnPar2zti6hNqZufSLJr
/xTY9kqbsiC7ilmgjDY6
=YeU2
-----END PGP SIGNATURE-----

--Sig_/jd3.swu3bv8WKJ4wmtv3GTe--
