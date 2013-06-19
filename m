Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934235Ab3FSDrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 23:47:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52556 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933861Ab3FSDro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 23:47:44 -0400
Date: Wed, 19 Jun 2013 13:47:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the block tree with the cgroup tree
Message-Id: <20130619134733.fcb49f4df20ec60cf51d6588@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Jun_2013_13_47_33_+1000_O3Z.pyPrY.Kh1jbZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Jun_2013_13_47_33_+1000_O3Z.pyPrY.Kh1jbZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
include/linux/cgroup.h between commit f63674fd0d6a ("cgroup: update
sane_behavior documentation") from the cgroup tree and commit
9138125beabb ("blk-throttle: implement proper hierarchy support") from
the block tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/cgroup.h
index e92e647,09f1a14..0000000
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@@ -261,23 -269,15 +261,25 @@@ enum=20
  	 *
  	 * - Remount is disallowed.
  	 *
 +	 * - "tasks" is removed.  Everything should be at process
 +	 *   granularity.  Use "cgroup.procs" instead.
 +	 *
 +	 * - "release_agent" and "notify_on_release" are removed.
 +	 *   Replacement notification mechanism will be implemented.
 +	 *
 +	 * - rename(2) is disallowed.
 +	 *
 +	 * - cpuset: tasks will be kept in empty cpusets when hotplug happens
 +	 *   and take masks of ancestors with non-empty cpus/mems, instead of
 +	 *   being moved to an ancestor.
 +	 *
 +	 * - cpuset: a task can be moved into an empty cpuset, and again it
 +	 *   takes masks of ancestors.
 +	 *
  	 * - memcg: use_hierarchy is on by default and the cgroup file for
  	 *   the flag is not created.
+ 	 *
+ 	 * - blkcg: blk-throttle becomes properly hierarchical.
 -	 *
 -	 * The followings are planned changes.
 -	 *
 -	 * - release_agent will be disallowed once replacement notification
 -	 *   mechanism is implemented.
  	 */
  	CGRP_ROOT_SANE_BEHAVIOR	=3D (1 << 0),
 =20

--Signature=_Wed__19_Jun_2013_13_47_33_+1000_O3Z.pyPrY.Kh1jbZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwSnaAAoJEECxmPOUX5FEC1wP+wd/r0KElsYpxAw/ojU3uuos
R0KzJO51kkrU6GomVmCIJQlMjeIbsg0W2P0aGedCyuTPvN6vDoHqYOtzumrI5M+F
bdyh+q0zm5kIjLJtCCYMZsKssfIeckO6q94sC260z8eyLG7fdfLRNkatGXeXF4ZE
dii0FCbsMTderrPvbCxNlQjsRtXubgp4YOc3jBH7D8+UNYCJSKI2cZ8BagG8Jcqt
PNnIS/Jfu9stTx9J/1RQQI3gNcIjek4WsBrfq8Sit1CDbmCXHNEVxZd4LyUXCAFV
EW9GGDFSut1rUakBhD94Hb8iWdxEnriBSSmnvAmOE4nXiChhIrltYpbFmqwQlncE
cwML5LMDAF4XyApsuHLPubPnC+i9I49nWoHWQWrKpNPgNq+/h3hKEOijhGixnLys
lyXY3tlQCuC+OhumV7ZyKU128nrwpCg/Qh5SZ+bKRaPVSPxFsjDL7rZ4bNbSFj26
ug/tRQYSFWxgOEvO8qm1UPXA4sRF0fRT26lblxNYdAvZOZf3vq6NKkgxEp4g2iYw
Wpyeyg1rIDuXz6Vr7jTHA+VJylfM2iTTihPNJXo2YDFBW9CNq231+hKeDE/n1SWP
1PeixFgUbpErLvDUm4VVFQjuoXDR4fmCXfIYQvSiUOkwMTqQb9SSDt3ljaKjaOp2
zbz9QgmnNg0Di3GpuT9V
=bXEQ
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Jun_2013_13_47_33_+1000_O3Z.pyPrY.Kh1jbZ--
