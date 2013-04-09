Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936046Ab3DIGaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 02:30:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39413 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092Ab3DIGaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 02:30:20 -0400
Date: Tue, 9 Apr 2013 16:30:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the ftrace tree with Linus' tree
Message-Id: <20130409163006.ed6b04b4a91d41b4633a4b4d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__9_Apr_2013_16_30_06_+1000_20OvoKQWRAUo30Lq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Apr_2013_16_30_06_+1000_20OvoKQWRAUo30Lq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

Today's linux-next merge of the ftrace tree got a conflict in
kernel/trace/trace.c between commit 2930e04d00e1 ("tracing: Fix race with
update_max_tr_single and changing tracers") from Linus' tree and commits
2b6080f28c7c ("tracing: Encapsulate global_trace and remove dependencies
on global vars") and 45ad21ca5530 ("tracing: Have trace_array keep track
if snapshot buffer is allocated") from the ftrace tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/trace/trace.c
index 7ba7fc7,829b2be..963491a
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@@ -744,11 -904,8 +904,11 @@@ update_max_tr_single(struct trace_arra
  		return;
 =20
  	WARN_ON_ONCE(!irqs_disabled());
- 	if (!current_trace->allocated_snapshot) {
 -	if (WARN_ON_ONCE(!tr->allocated_snapshot))
++	if (!tr->allocated_snapshot) {
 +		/* Only the nop tracer should hit this when disabling */
- 		WARN_ON_ONCE(current_trace !=3D &nop_trace);
++		WARN_ON_ONCE(tr->current_trace !=3D &nop_trace);
  		return;
 +	}
 =20
  	arch_spin_lock(&ftrace_max_lock);
 =20

--Signature=_Tue__9_Apr_2013_16_30_06_+1000_20OvoKQWRAUo30Lq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRY7VuAAoJEECxmPOUX5FE3dsP/3F1n36Goux2tCf8PJTQegQH
XbDLe1xz9WfBdbELxR9AuYwMMux0UVvHOqHunZhpmXQrH+UEwJp/oQDhhFdTYm+k
68lvc74R0S9jG/F1ZTi90KH7sd2OUolcPRqbbWISTLWpr3GS30RIc7TbhkVlX6jS
/NKBrKhp/9lGPAidjhhvkDMniyAE1ehPD60nV0hqmF4nXkUFqOmFKQQQ454S0/nA
cy9nr7zrhBQTLEr7H2DF+1/acNkSH0MseJoi0axKGa57K1x5Psy8iEMpgycK2A6c
CA9gvCaF8qcClmby1xS9mgKhna2eNein+/6oTD1+VDTr0wbD+PMTc1KDou+U8M5J
AkgAcAGIZkuDFLEvsy945kI1eBhEyPJf45Mipd7dbS1y0eqhjcWy41Dv8AXEnDUN
IxIPAGB3+zVRKWiIhryzStAo1sptLXe0OEZXTSSi42SwPvF9UWgmeV/KUj48O19l
f6haaI0KbucSzgb6VpNskTYl4YkRg3BAOAhNaClvB85EDgSTfi0JDxc21xwDkTki
xaAPKIWUkh+uOLLZsdnOF93bNrZbuIrTvInzSlv3hV0BNi7YW8LijS711eGK3eUY
UzXjVlHsz7wGgDyOlu9e4R/rS5b6MDqUyN12wSXGibNwMvaQpVl+CpIeGPUv0TOa
GRsxtkveukC+lpKta8tW
=CkcP
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Apr_2013_16_30_06_+1000_20OvoKQWRAUo30Lq--
