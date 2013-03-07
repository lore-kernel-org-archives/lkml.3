Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab3CGPvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:51:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33495 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab3CGPvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:51:42 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=eCOiQ5sXoqQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xlrRK0PtstEA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=RvAG0AvA1teh-49V8cEA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=WasVbPsTDICKN0vNab8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130307155141.151718027@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 10:34:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH 2/2] tracing: Do not return EINVAL in snapshot when not allocated
References: <20130307153442.755353831@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Do-not-return-EINVAL-in-snapshot-when-not-al.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

To use the tracing snapshot feature, writing a '1' into the snapshot
file causes the snapshot buffer to be allocated if it has not already
been allocated and dose a 'swap' with the main buffer, so that the
snapshot now contains what was in the main buffer, and the main buffer
now writes to what was the snapshot buffer.

To free the snapshot buffer, a '0' is written into the snapshot file.

To clear the snapshot buffer, any number but a '0' or '1' is written
into the snapshot file. But if the file is not allocated it returns
-EINVAL error code. This is rather pointless. It is better just to
do nothing and return success.

Acked-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9e3120b..1f835a8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4167,8 +4167,6 @@ tracing_snapshot_write(struct file *filp, const char =
__user *ubuf, size_t cnt,
 	default:
 		if (current_trace->allocated_snapshot)
 			tracing_reset_online_cpus(&max_tr);
-		else
-			ret =3D -EINVAL;
 		break;
 	}
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJROLeNAAoJEOdOSU1xswtMR5oH/0lWVUodyoJ6f4RgqvzhUA77
OXMU+BPC2fMsP0ZA9WbH7q6dLvA4p7GsO+L5f1+p3yEFevgOtWe84IAT1nAXcWsE
wtr9+ywCAbVHz1qiwrksC+5sYsilOecrUmHQvWdnfBpWmzTeTvQfvSBl8NslzkAs
s0ZbF7esxiWA6Sp76PtmWqXzAdez3tCWj/Mg0drFDy5CoYC93lUTdbxshug7up/4
+HB/GG4/ll2ujNUWIxAC11IvrjPnCrMn1F1AE6pqCOA3y7hmdxA16HHTjgBASDF0
pI/p56G45VZU6EDRyYa4oKaBt+2Pbn0UPMylRWsokGkNFoPWSO7AMnKNlJvgWZI=
=Uq0d
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
