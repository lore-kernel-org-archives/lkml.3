Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423276Ab3FUH1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:27:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35665 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935525Ab3FUH1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:27:37 -0400
Date: Fri, 21 Jun 2013 17:27:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt (Red Hat) <rostedt@goodmis.org>,
        Alex Thorlton <athorlton@sgi.com>
Subject: linux-next: manual merge of the akpm tree with the ftrace tree
Message-Id: <20130621172724.abc40cf979e7e585f70090c9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Jun_2013_17_27_24_+1000_mMc/KGbH3E+r/8Sq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Jun_2013_17_27_24_+1000_mMc/KGbH3E+r/8Sq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
kernel/panic.c between commit de7edd31457b ("tracing: Disable tracing on
warning") from the ftrace tree and commit "panic: add cpu/pid to
warn_slowpath_common in WARNING printk()s" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/panic.c
index 4cea6cc,aaa0b7c..0000000
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@@ -400,10 -399,9 +400,11 @@@ struct slowpath_args=20
  static void warn_slowpath_common(const char *file, int line, void *caller,
  				 unsigned taint, struct slowpath_args *args)
  {
 +	disable_trace_on_warning();
 +
- 	printk(KERN_WARNING "------------[ cut here ]------------\n");
- 	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);
+ 	pr_warn("------------[ cut here ]------------\n");
+ 	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",  '
+ 		raw_smp_processor_id(), current->pid, file, line, caller);
 =20
  	if (args)
  		vprintk(args->fmt, args->args);

--Signature=_Fri__21_Jun_2013_17_27_24_+1000_mMc/KGbH3E+r/8Sq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRxABiAAoJEECxmPOUX5FELzkP/12ES/ZExGc4namkeDtDEKzF
axRouDm4yXqQlmLoaMMTYjCWj6yPGKoFktDnLsR+WE7fchT8iEpwIFJfSp427KyE
wdM0CZGfV3LaC91lCB54COFFvmZLPZoDFapGG8yjeX+hxY3k6/jDmuwzc4pVTYnv
GFxUTO5ynODdAnr0/Au0gWInjdmxqNs8MZXT/mULQumzQS6HBG51tzS80IIAZ3qM
FRUFCnahPMhYPR9A06TrQ6sw/Jp3Pso53RpAoALL4fmStDqL8pyITViQeqyn2V1z
KyFDWLkfgZnjERoT+oHjprDv3OJ6yGngHg3NI2C2++2dWYLKQuhI915o8P60jOP2
JSNFg4JFV4QQYWwsJW7vs46U+Tq0wWUR9mD80ZskTwvK3RV0PnFGVJwcBREEZ5xi
p3/gVM+Wz9i9WORBnJ0jbErELQnBUEduv9E3DAsQPNtuWY5kbcqhueogUWrZKSqb
NjqY0qMMD9cn/DGlx6m9Po6cMQXHq2yM1uwy6DSPAATvbm8pcOZzkAjCY2UHKtls
Uqj8z3gyAlYI/+v6UP832jYDJQmjk/+wcyEii+gVzL3UkvXXIwttlDtyAZfagT+U
N9pLrsXIrWp8fxJ8BhoPAvxW3hiOqa/n80cB9vEWRYyP7J4xpO8AcU94aJud8X7c
J17w+xjXw0kOMPmlad/z
=xtxf
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jun_2013_17_27_24_+1000_mMc/KGbH3E+r/8Sq--
