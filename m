Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3GJDvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 23:51:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44092 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3GJDvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 23:51:41 -0400
Date: Wed, 10 Jul 2013 13:51:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the ftrace tree with Linus' tree
Message-Id: <20130710135129.f4e0966747fc684a7294544f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Jul_2013_13_51_29_+1000_P77V2=+PPpM0GWCW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jul_2013_13_51_29_+1000_P77V2=+PPpM0GWCW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

Today's linux-next merge of the ftrace tree got a conflict in
kernel/panic.c between commit dcb6b45254e2 ("panic: add cpu/pid to
warn_slowpath_common in WARNING printk()s") from the  tree and commit
de7edd31457b ("tracing: Disable tracing on warning") from the ftrace tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/panic.c
index 9771231,4cea6cc..0000000
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@@ -399,9 -400,10 +400,11 @@@ struct slowpath_args=20
  static void warn_slowpath_common(const char *file, int line, void *caller,
  				 unsigned taint, struct slowpath_args *args)
  {
+ 	disable_trace_on_warning();
+=20
 -	printk(KERN_WARNING "------------[ cut here ]------------\n");
 -	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);
 +	pr_warn("------------[ cut here ]------------\n");
 +	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",
 +		raw_smp_processor_id(), current->pid, file, line, caller);
 =20
  	if (args)
  		vprintk(args->fmt, args->args);

--Signature=_Wed__10_Jul_2013_13_51_29_+1000_P77V2=+PPpM0GWCW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR3NpFAAoJEECxmPOUX5FEHy8P/2EwFI1r9KWoU8kQ/zR6Kyyg
6KFqLOOGX8OUVEQA6y/A8XUPpTyDgV0LsUtPHnzMzbJGvl8ADkLdNZ5hl1wOWYCY
NyKlHh9UHTr0XzVDMQxPzWVWFe3ZAvckT3hTtPJAZfEi7CMC2V49MJo1KKSpmf8Z
4+Gyoebx8uH1HJdHRyZ3tvxQC2FQroHLT7lKqjfn4XunMKXbp4CetV401SIWRBOQ
2uOCgqQe7yFly0+xAPRIw7t6z51DUsj8+pYnuSCM5VQbo5IWKKEquPR1K6oyA1iH
Y63lc2Z2R0tmsO/e1kn7lERhPenYhz9aFijjY+okhnOHZFKHgZ28lX6x/bvYwZBd
3OPm/PVJapnOiuzUVHr20XADDRZ9HimRvcqbZpP24Sr2z+/E5WYTmRg7qaUcLmTT
6AV1GZYPc0ivv0jSu8rkjBrUPfR3F7fu4+T/nEZi6qB2UuiSef/x1c+sT81K1o5Z
UH9sr2G+U20jVgboUHzn/pjMcvOCDkkPouLCedDKVOOp+06qj5T0yF4iWKZySisB
Q+/GLP4P3lJOsWiad2JMQa8h1z3cOBi192HGDNYGFsuoQXVzFh/e2A7LcH+tY7hb
cdntbr9dUHS++GDQ1wBajSzmWzRZRIF2pj1pD7GdA0woOrBYRg6k8dpL/RYAlftV
uXyBFFQTv9CqjwHsZYAi
=pHDl
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jul_2013_13_51_29_+1000_P77V2=+PPpM0GWCW--
