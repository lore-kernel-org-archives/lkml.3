Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3DQXY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 19:24:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52947 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3DQXY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 19:24:56 -0400
Date: Thu, 18 Apr 2013 09:24:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: PCI: Remove "extern" from function declarations
Message-Id: <20130418092444.a4d64d8a9b5f700ba2aae779@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Apr_2013_09_24_44_+1000_HoRVY3qf2Dd2WFx."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Apr_2013_09_24_44_+1000_HoRVY3qf2Dd2WFx.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

I just noticed this commit (f39d5b72913e "PCI: Remove "extern" from
function declarations") in the pci next branch.  Just wondering why you
would do such a thing.  It is a lot of churn in quite a few header files
and (in my opinion) goes the wrong way anyway.

It may not actually make any difference to the compiler for functions, but
for variables, it does.   A variable declared in a header file without
"extern" will effectively define it in every compilation that includes
the header file, one with "extern" will only produce references.

So, since, the global variables really should have the "extern", the
functions are now inconsistent with that.

It also means that when someone copies a function declaration to make a
"static inline" stub, the "extern" is a big hint for them to remember to
make the stub "static" - I have seen several occasions when this was not
done and that causes compilation failures (but usually only in the
configuration that the author did not bother to test).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__18_Apr_2013_09_24_44_+1000_HoRVY3qf2Dd2WFx.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRby88AAoJEECxmPOUX5FENoEP/1f+udRQ8Edap+MUyWWdrHXd
yTOOgcSFOgHPpTXnMiPPm31JmMHE6HppsFSps2ITJJ6687S2tvgW6i5BvEzDDY6g
mtg+1NOCkLwCPqW5oWV2Bp92B3q3YRzYKYGX3rBICjYQ4LvoMS9CdmBqDU1Ubu9O
r0Uvol1WrUHkOo3FVjz12Gs/kR9Han2m5gqvi0MTV7jwx5ijKyXtjHW3D5UYQHfi
jDvMNiLLFxLLD9I4le0FKSzM2Dktvjjj55s5o3lMeJmrLSUVdqTO4Ab5Olr3ypFu
qwk3W8VY1IHYYLnj0CmYttiJP5QCTmQBBhRdwoVImiEVfnNu+KsnStj9yI+fYitt
cn3QqQ7FkTmpTCI/wkuhM6dDaf3ac4LCQMTm+vrwioRaHEXq74DuSqTh3kGegaD/
W+J91S/r8KFFOxvXCLdj5cJUqB/cHwR28Ve8TW1MI7Z5vT6JH1X3YfQSnmByTH4w
zkor/bfnLDEyxcDexPCgAHNU1+P3LvmRShUsqRX8doyzHGH6poqteEGoKGoVcKzp
QWzeHRL6w0vT6zvWIn/c12+30h7PLfY4Q01VurYiOnjJfnrgPoUm8luHVvrpQdhv
Lo4UWPFaKHt63QMGW3YlJ/X2twEX4rz7zT5LXFYUoPXaaXtYizYBe1OePozPyzkd
xm7QT/t8eFGJq7F+w5S5
=iHpk
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Apr_2013_09_24_44_+1000_HoRVY3qf2Dd2WFx.--
