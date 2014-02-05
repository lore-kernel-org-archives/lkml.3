Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaBEJx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:53:26 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54097 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701AbaBEJxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:53:22 -0500
Message-ID: <1391593996.3003.49.camel@deadeye.wl.decadent.org.uk>
Subject: Re: perf trace: Initial beautifier for ioctl's 'cmd' arg
From: Ben Hutchings <ben@decadent.org.uk>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 05 Feb 2014 09:53:16 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Mrn91yOR4uvzT4AHn4qi"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.239
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Mrn91yOR4uvzT4AHn4qi
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

--=-Mrn91yOR4uvzT4AHn4qi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUvIKDOe/yOyVhhEJAQoBBg/9E3vYS2KmvzsPMR6/wlz0BwxvelB6U7gR
hotU3bAwyjiYvMPAk7Vd5qyeXUxD2AiwE73EObTEQasvuJpg0fwhP7UqmATyc5uY
+HHdf82AQzw9Hh34IaeMmw0bSYiuKIz+pmn28LakLdskP0mBmDiwimvW0xHuI5Y9
LSOXdeRjvM1w9VSqr6HoxPJMINGSrXma5SrRyVCZ9tDpo+z1jrX8Zl4jannQxeBa
lWemVQrZE50MiS7BSAF84Vac+ykZM03wUm8LkZGfaA4CSAzcZuxf8aeVAJh2uj8k
ODiPep6ax4SjrfXqMtjJaeSbQj/djUlWx4nFzQQBVjl74ASP/ahYVBHDtIsWCaeF
AtiriLH2Wkf/YjdYv2nfDjY5BCbnFq6bo1rj4C82MFt1TMZE8u4TFomUI/0D+m9D
dh1vnS3BIc00ELYSdfh8CbL4nOyOCVtOyeP8f+6QtTYTXKsA6OjHpOp5LJ9eqBVh
mUB8qVcWUkdJrFqfpDJQtijkIBVyl2yOCY0WryxiUC3UNDZhEvJTc91UYTVzGi9G
EMWvOHCY8XE36Gmbb1Y+DngLeOpdEnXOVVkfvPdx9d+EIrYMPwfeMInAG5NFFUfq
hP+2zkpULhJpBlUlYdLKKQQGGM2DGe8mj52/J9nafp9EWPHD9lnKopA5orDZQRPC
V2a8W9y4VtQ=
=exrx
-----END PGP SIGNATURE-----

--=-Mrn91yOR4uvzT4AHn4qi--
