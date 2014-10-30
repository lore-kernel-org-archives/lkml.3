Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaJ3EDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 00:03:16 -0400
Received: from ozlabs.org ([103.22.144.67]:53424 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaJ3EDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 00:03:14 -0400
Date: Thu, 30 Oct 2014 15:03:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20141030150304.3c8cb7d6@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/+eLneu1LV8sVaMOIiAdoM=H"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+eLneu1LV8sVaMOIiAdoM=H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

lib/show_mem.c: In function 'show_mem':
lib/show_mem.c:43:45: error: 'totalcma_pages' undeclared (first use in this=
 function)
  printk("%lu pages reserved\n", (reserved - totalcma_pages));
                                             ^

Caused by commit b4e3647bb59d ("lib/show_mem.c: adds cma reserved
information").  totalcma_pages exists nowhere except these added lines.

I have reverted that commit (and its following fix) for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/+eLneu1LV8sVaMOIiAdoM=H
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUUbh8AAoJEMDTa8Ir7ZwVvXgP/jDBMhrj4GNXzQi4mU2duWqV
h0kspZsYsTGQKmSwQiJ5pw3ykG9K+XmLTBfcnJvfuoxIQZydCVCGndvSU4kz3R2l
ubsqfAdBhDwJRfWyI99lzUAfZ6bicSZI1REOdRqL2D/JlwlTV4Tg576ICkmXCp9V
dmeW31qqhN0RVm+Qto6Ooe++ZmN5eMQz2tPAuWELBEU8UnCpqhAe/ok8tPAbbKWD
ODols1hdMxhUsIKY+mdhsYD5cnqsCPNInrF9dxz9MXId5ChoGkBMabxNOrovdD5a
LGdifYMMFUFNf1hfYA8rJJMfqpsJ9ZxDiBGWJziSK6tDGsRkw7gHnw4pUQc+/9ib
WHU/Ms985QIzzo8UYrTjhNjlNStSUlTqcPy/bmq75zJtvvsgtk4qrsTRN1kHyW+J
bjl83yxJMHnbJ11B22HZfmawO4HUMg/hv91+DJMWN/nB5fmOQnJqT2kZA33Notiv
ZU3L+o0PwlKMA4LBFOnzPN5iLkmnzGba5b5sHkdOzS69HDvQG5693+nCLEhj8ip8
GeJcr2GkNQOWsmY+YgwHxkJheUTZXvaHXVxhyHWYBR5tRn0EaUdqU8WSr4XJJaRd
o5kd8QrNvpzQLG/Sv3yAMmGPviOkoD8EotJ+Dq6yPzkpkjq13EeZsMqSnoSwPReS
0WxO+NTzkCYO9sJQQLsu
=5urM
-----END PGP SIGNATURE-----

--Sig_/+eLneu1LV8sVaMOIiAdoM=H--
