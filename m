Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300Ab3CRCA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:00:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37058 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3CRCA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:00:27 -0400
Date: Mon, 18 Mar 2013 13:00:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the ftrace tree with Linus' tree
Message-Id: <20130318130014.bad6e49cd6d4a112050173de@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Mar_2013_13_00_14_+1100_4/ELQLVo_Qm+gsiu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Mar_2013_13_00_14_+1100_4/ELQLVo_Qm+gsiu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

Today's linux-next merge of the ftrace tree got a conflict in
kernel/trace/ftrace.c between commit b67bfe0d42ca ("hlist: drop the node
parameter from iterators") from Linus' tree and commit e1df4cb682ab
("ftrace: Fix function probe to only enable needed functions") from the
ftrace tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/trace/ftrace.c
index ab25b88,2577082..0000000
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@@ -3063,8 -3087,13 +3083,13 @@@ static voi
  __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *o=
ps,
  				  void *data, int flags)
  {
+ 	struct ftrace_func_entry *rec_entry;
  	struct ftrace_func_probe *entry;
+ 	struct ftrace_func_probe *p;
+ 	struct ftrace_hash **orig_hash =3D &trace_probe_ops.filter_hash;
+ 	struct list_head free_list;
+ 	struct ftrace_hash *hash;
 -	struct hlist_node *n, *tmp;
 +	struct hlist_node *tmp;
  	char str[KSYM_SYMBOL_LEN];
  	int type =3D MATCH_FULL;
  	int i, len =3D 0;

--Signature=_Mon__18_Mar_2013_13_00_14_+1100_4/ELQLVo_Qm+gsiu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRRnUuAAoJEECxmPOUX5FExY8P/38xdNuLSPYYbBYSurkPaOrc
Fgd8whb5TgYC5oSVqcrjqDWQ7OnWIu3bYVQnte/7Ur0aUL5J2CERNUpvNQtwVyuA
wfURfopqj6xB08CCTP1eEqP0FX7qwOHG8XR/PyCmXbZMSB0zEp2AohbKTeckC/NY
/WAuQxjQvEig8hZlKHRz96e38cBwAOghf2bX4JlC9vsgW2hsqNcJBmtc6w01DtlM
aSyJrb0AJ5e88C55XZx4K3J2AIFkwhWAYPanHZxivnqVxw6EWQNetGJktvAN8icx
EfiVfJ3d5B2NOe1tvau2vQZE8k2zsgdL5GUtMlhEIgaNz8QT027VAe50BCpOYZQL
Ko9jw177ExNZoypsD23BdKZbEweUzaj3h5rsbN1uQ1DOMItn6gYm++4NwlloOGGR
LUSrpfNKTntJqWGEkVK5bS0N6l3tZxSRBPR5NhSny9mg6taDCAEGbGBVrzLMMWO8
O7zfuVNNkuGJblA206CRGlwX1VS+WJh+FyjMMaWbBmP8Emfg2hW4JSq6DLMT9Fit
aimZMAYGNQhR4IepZJPapWOY52LhuZms+HW9Zwkl15U1WB1J9ziGC76RtkwWISiu
3fKEqZT7YxYpTT+Ht9R03vQQUHKkbYI4wRwbTZ4L9tT0Hy+xn7rIv6G+feWmazD8
wQi19guwuHpsMokVjcoQ
=SZE9
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Mar_2013_13_00_14_+1100_4/ELQLVo_Qm+gsiu--
