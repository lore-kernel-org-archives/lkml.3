Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100Ab3FCGcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 02:32:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51588 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3FCGcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 02:32:00 -0400
Date: Mon, 3 Jun 2013 16:31:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, chanho.min@lge.com,
        Kamil Debski <k.debski@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Arun Kumar K <arun.kk@samsung.com>
Subject: Re: Regression introduced by commit
 "lib/bitmap.c: speed up bitmap_find_free_region"
Message-Id: <20130603163145.f51c89410bd223d74e9b4fb9@canb.auug.org.au>
In-Reply-To: <20130531120542.87e2056dc7c129e72b83f2af@linux-foundation.org>
References: <CAK9yfHyZH3DSg2ZLbPN2bjQppWZSMR+2hQE+OU76eqSJoWAWGA@mail.gmail.com>
	<20130531120542.87e2056dc7c129e72b83f2af@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Jun_2013_16_31_45_+1000_rf_yh9vmq2Crl9wc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Jun_2013_16_31_45_+1000_rf_yh9vmq2Crl9wc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 31 May 2013 12:05:42 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Fri, 31 May 2013 12:15:10 +0530 Sachin Kamat <sachin.kamat@linaro.org>=
 wrote:
>=20
> > While testing MFC decoder on Exynos machines, I encountered some
> > memory allocation errors due to failure of dma_alloc_coherent().
> > File: drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c Line: 38.
> >=20
> > Git bisect pointed me to the following commit as the first bad commit
> > (linux-next tree of 20130531):
> >=20
> > commit 3d5272d9b289cd0930b2ea9984406d757a72f4dd
> > Author: Chanho Min <chanho.min@lge.com>
> > Date:   Thu May 23 10:37:28 2013 +1000
> >     lib/bitmap.c: speed up bitmap_find_free_region
> >=20
> > Reverting this (and the commit 197e1cf7
> > ("ib-bitmapc-speed-up-bitmap_find_free_region-fix") ) fixes this
> > issue.
> >=20
> > Looks like some regression has been introduced by the above patch?
>=20
> Thanks.  I dropped the patches for now, to minimise linux-next
> breakage.  Hopefully we'll be able to identify and fix this at a later
> time.

I removed those 2 patches from the akpm tree in linux-next today as well.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__3_Jun_2013_16_31_45_+1000_rf_yh9vmq2Crl9wc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRrDhVAAoJEECxmPOUX5FEVG4P/2mw6aSlwqcCKmwyS1bpIuz2
tQhNO2Q9gUFHKuXxSRvZkdLIKgiV0MTy7EJquJGopVuROM8JR4L1kOdm8FWEtsWD
UzTTlnLq5qwmwlaJuYWmQHt6FIbJLndBV71XWM5KlXWQDLqqL7kiaPEDVaZ2I11/
l5G30l7+KraBXt5olkSk4cb3KVHvhNeNSKQHRAzzbPdqgEO6AtQ14oHli+Sf+KLu
K5crQkWhBc21ocxvzjEA22Fh0bYjoaZ/MKwCJwB0JZA/lG66sNM55Gn6GRG8ABjU
9DbTdzGL7cp6xTryc8XAztO8BKYkX+QiBU+4cvaFbECVq6bNpENKO9llhG3wTm3f
/iXa/JUySMx2K8zJyF8mby6uYYjJksMXgKscRMx7cFkI0Dxr3AKOCMMRB90EKFWf
I8A5c5AaIyQQfXRaBLIWX3AOAt1ayFEKFKey19fuS7EhQrV54P+47OGQ03xb7cAN
C4PjoyRNXS3EHi3GpmgytshYsEBk4iltAPN21OQfSvXGOxru5egwelD6YWzJI+3I
AcAut0O+PUmpVya0ntJYW2WWi6GYLMa5mxRkiV1WL5ZIzQLP3d3mqsdfEQKyQaCe
AL5QSuPgroiFBMffEdwqSK3BWUsSmv7TVLiUobM3bwK4i6KCvt4ltr/z7DmZUQSU
ppLB2vgKnXHNJ4F98glB
=AXf1
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Jun_2013_16_31_45_+1000_rf_yh9vmq2Crl9wc--
