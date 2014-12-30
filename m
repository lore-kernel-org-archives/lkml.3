Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbaL3RaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 12:30:22 -0500
Received: from smtp2-out.insa-rennes.fr ([193.52.94.25]:57665 "EHLO
	smtp2-out.insa-rennes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaL3RaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 12:30:21 -0500
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Dec 2014 12:30:20 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAGXdolQKBQEl/2dsb2JhbABchzXJSoEhAQEBAQF9hDZVATwWCwILAwIBAgFLDQEHAQG5D5RcAQEIAQEBAR6Pd4JvgUEFj2CBJ4wFg2OHZwKEEYMxAQEB
Message-ID: <54A2DEAD.2050708@supelec.fr>
Date: Tue, 30 Dec 2014 18:19:41 +0100
From: Laurent Georget <laurent.georget@supelec.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-man <linux-man@vger.kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] adjtimex.2: Add details about ADJ_FREQUENCY
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oVjXO5rKwBQrV7OKtOc0sbE9laaEH6alm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oVjXO5rKwBQrV7OKtOc0sbE9laaEH6alm
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

this is another patch for adjtimex(2) man page which fixes a FIXME by
giving the scaling unit of timex.freq and adds a detail about the value
expected by ADJ_FREQUENCY.

Laurent

diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
index 18823c8..2652fc6 100644
--- a/man2/adjtimex.2
+++ b/man2/adjtimex.2
@@ -55,8 +55,8 @@ struct timex {
                          status flag is set, otherwise
                          microseconds */
     long freq;        /* Frequency offset, as scaled PPM
-                         (parts per million) */
-.\" FIXME What is the scaling unit of timex.freq?  2^16 ?
+                         (parts per million) :
+                         the scaling unit of timex.freq is 2^16 usec =3D=

1000*2^16 nsec.
     long maxerror;    /* Maximum error (microseconds) */
     long esterror;    /* Estimated error (microseconds) */
     int  status;      /* Clock command/status */
@@ -106,6 +106,10 @@ Set time offset from
 .BR ADJ_FREQUENCY
 Set frequency offset from
 .IR buf.freq .
+The clock frequency must be comprised between -500000 and 500000 scaled
ns/s.
+If the given value is outside those bounds, it is silently truncated. Th=
is
+corresponds to values between -32768000 and 32768000 for
+.IR buf.freq .
 .TP
 .BR ADJ_MAXERROR
 Set maximum time error from


--oVjXO5rKwBQrV7OKtOc0sbE9laaEH6alm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlSi3scACgkQRTidSplJch65ggD+NyMFwhQV/ekRHYdnqqWyra3Y
SdK0LW6iI5kViwpqmZcBAKqLYo1p6JKgI25bx6bBa0DA6Clc8i5xm/33/AMieVcr
=WG8C
-----END PGP SIGNATURE-----

--oVjXO5rKwBQrV7OKtOc0sbE9laaEH6alm--
