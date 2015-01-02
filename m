Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbbABXCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 18:02:11 -0500
Received: from smtp2-out.insa-rennes.fr ([193.52.94.25]:62789 "EHLO
	smtp2-out.insa-rennes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbbABXCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 18:02:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQFAIMip1QKBQEl/2dsb2JhbABchDCDBckhAoEdAQEBAQF9hA0BBSNVARAsFgsCAgkDAgECAUUGDQEFAgEBsk2UKQEBAQEBBQEBAQEBAQEbjxYKVweCaIFBBY9ggSeHDoJlghIhiykChBFugQSBPwEBAQ
Message-ID: <54A72360.3070807@supelec.fr>
Date: Sat, 03 Jan 2015 00:01:52 +0100
From: Laurent Georget <laurent.georget@supelec.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-man <linux-man@vger.kernel.org>
CC: linux-kernel@vger.kernel.org, Jeff Epler <jepler@unpythonic.net>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 1/2] adjtimex.2: Clarify the 'ppm scaling' used in struct
 timex
References: <54A2DEAD.2050708@supelec.fr>
In-Reply-To: <54A2DEAD.2050708@supelec.fr>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UPDWOLVpmI7GpWUiOVl9up5OVPcO3X6HF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UPDWOLVpmI7GpWUiOVl9up5OVPcO3X6HF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

this is the last version of a new series of patchs for adjtimex.2.
Please ignore all previous versions of this series.

This patch makes explicit and clarifies the unit used for fields "freq", =
"ppsfreq" and "stabil" in struct timex.
It closes a FIXME in the man page.

Reviewed-By: Jeff Epler <jepler@unpythonic.net>

---
 man2/adjtimex.2 | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/man2/adjtimex.2 b/man2/adjtimex.2
index 18823c8..ff4b23e 100644
--- a/man2/adjtimex.2
+++ b/man2/adjtimex.2
@@ -54,9 +54,8 @@ struct timex {
     long offset;      /* Time offset; nanoseconds, if STA_NANO
                          status flag is set, otherwise
                          microseconds */
-    long freq;        /* Frequency offset, as scaled PPM
-                         (parts per million) */
-.\" FIXME What is the scaling unit of timex.freq?  2^16 ?
+    long freq;        /* Frequency offset, in units of 2^-16 PPM
+                         (parts per million) (see NOTES below) */
     long maxerror;    /* Maximum error (microseconds) */
     long esterror;    /* Estimated error (microseconds) */
     int  status;      /* Clock command/status */
@@ -72,13 +71,13 @@ struct timex {
                          flag is set, otherwise microseconds */
     long tick;        /* Microseconds between clock ticks */
     long ppsfreq;     /* PPS (pulse per second) frequency
-                         (scaled PPM, read-only) */
+                         (2^-16 PPM (see NOTES), read-only) */
     long jitter;      /* PPS jitter (read-only); nanoseconds, if
                          STA_NANO status flag is set, otherwise
                          microseconds */
     int  shift;       /* PPS interval duration
                          (seconds, read-only) */
-    long stabil;      /* PPS stability (scaled PPM, read-only) */
+    long stabil;      /* PPS stability (2^-16 PPM (see NOTES), read-only=
) */
     long jitcnt;      /* PPS jitter limit exceeded (read-only) */
     long calcnt;      /* PPS calibration intervals (read-only) */
     long errcnt;      /* PPS calibration errors (read-only) */
@@ -343,6 +342,18 @@ and the caller does not have sufficient privilege.
 Under Linux, the
 .B CAP_SYS_TIME
 capability is required.
+.SH NOTES
+In struct
+.IR timex ,
+.IR freq ,
+.IR ppsfreq ,
+and=20
+.I stabil
+are PPM (parts per million) with a 16-bits fractional part, which means =
that a
+value of 1 in one of those fields actually means 2^-16 PPM, and 2^16=3D6=
5535 is=20
+1 PPM. This is the case for both input values (in the case of
+.IR freq )
+and output values.
 .SH CONFORMING TO
 .BR adjtimex ()
 is Linux-specific and should not be used in programs
--=20
2.0.4



--UPDWOLVpmI7GpWUiOVl9up5OVPcO3X6HF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlSnI2UACgkQRTidSplJch4WqwD6A43Qda9fY8oRJWcxWSwuLF14
YNwwa5wuKLhRahagyo4A/0cq8YjqfSmOjL7lRWA29HIqTm3CDM3SVmcGaIDy/h2O
=N0oL
-----END PGP SIGNATURE-----

--UPDWOLVpmI7GpWUiOVl9up5OVPcO3X6HF--
