Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab3CGPvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:51:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12482 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282Ab3CGPvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:51:42 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=2F29XbyRvjsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=XGxxRI9yStEA:10 a=VwQbUJbxAAAA:8 a=9ghkyTzLHVOxahAqFJoA:9 a=QEXdDO2ut3YA:10 a=kBQFmkRr0Fnlf4M7fKsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130307153442.755353831@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 10:34:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH 0/2] [GIT PULL][3.9] tracing: Fix in snapshot API
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

The snapshot feature has been added in the 3.9 merge window. But after
playing with it some more, I've come to realize that it needs a
self documenting help (I had to look at the code a few times to remember
how to use it, or look in Documentation), and it also gives an awkward
error code if you go to clear the buffer and the buffer does not exist.

These two patches fix this issues, and I strongly suggest they go in
before snapshot is part of a major release.

The first patch gives the user a nice description to how to use snapshot:

     # tracer: nop
     #
     #
     # * Snapshot is freed *
     #
     # Snapshot commands:
     # echo 0 > snapshot : Clears and frees snapshot buffer
     # echo 1 > snapshot : Allocates snapshot buffer, if not already alloca=
ted.
     #                      Takes a snapshot of the main buffer.
     # echo 2 > snapshot : Clears snapshot buffer (but does not allocate)
     #                      (Doesn't have to be '2' works with any number t=
hat
     #                       is not a '0' or '1')

as well as the state of the snapshot buffer (freed or allocated).

The second patch, returns success on a reset of the buffer even if
the buffer wasn't allocated. Returning -EINVAL is just confusing.

These should go into mainline before 3.9 is released.

Thanks!

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: c9960e48543799f168c4c9486f9790fb686ce5a8


Steven Rostedt (Red Hat) (2):
      tracing: Add help of snapshot feature when snapshot is empty
      tracing: Do not return EINVAL in snapshot when not allocated

----
 kernel/trace/trace.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJROLeJAAoJEOdOSU1xswtM5r4H/0lSnTICIujVK9pCBCHXuRd3
CwRBlmf5T/kxFroMyXPlVmGJVdw9JU4VKmcCUctA4ZGuxYqe1AQ1MlEl7H0lgLJA
Tfavy/m+TQh2iBd1Gv2Y1zFs2c/2iWxseL0416pVy91owfgO6avVPR6vqcL5ylo0
63DvVEw5ELMOadDvkJjOABB+Xv5A+nFXFIrwDm0T6GZVeKruBhXc/ROI9u5NYaf6
1TSzIfwnLg0gctZqSZDr2Xl4GaYJ9FourVgvsIff6HOmLOP7beblz+/msCgYkSkC
yY9MZ8GbCgUAPAdcu3irENQOe4If4Ru+glPVgwBsNKQPvRjyb4Hn6YmpkTK0Xco=
=g6rV
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
