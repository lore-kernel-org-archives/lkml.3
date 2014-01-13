Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaAMEKD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 23:10:03 -0500
Received: from ozlabs.org ([203.10.76.45]:39094 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaAMEJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 23:09:59 -0500
Date: Mon, 13 Jan 2014 15:09:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: linux-next: manual merge of the workqueues tree with Linus' tree
Message-Id: <20140113150951.91b337d4b316f84001a51114@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Jan_2014_15_09_51_+1100_77q0qdykXRKfztXB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Jan_2014_15_09_51_+1100_77q0qdykXRKfztXB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
kernel/workqueue.c between commit 12997d1a999c ("Revert "workqueue: allow
work_on_cpu() to be called recursively"") from Linus' tree and commit
440a11360326 ("workqueue: Calling destroy_work_on_stack() to pair with
INIT_WORK_ONSTACK()") from the workqueues tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/workqueue.c
index b010eac595d2,fdeec6e9d025..000000000000
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@@ -4827,7 -4833,15 +4828,8 @@@ long work_on_cpu(int cpu, long (*fn)(vo
 =20
  	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
  	schedule_work_on(cpu, &wfc.work);
 -
 -	/*
 -	 * The work item is on-stack and can't lead to deadlock through
 -	 * flushing.  Use __flush_work() to avoid spurious lockdep warnings
 -	 * when work_on_cpu()s are nested.
 -	 */
 -	__flush_work(&wfc.work);
 -
 +	flush_work(&wfc.work);
+ 	destroy_work_on_stack(&wfc.work);
  	return wfc.ret;
  }
  EXPORT_SYMBOL_GPL(work_on_cpu);

--Signature=_Mon__13_Jan_2014_15_09_51_+1100_77q0qdykXRKfztXB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS02cTAAoJEMDTa8Ir7ZwV/SEQAIXoh4v0J36PBKHT5AgZUtfl
120iIyvBT9L54r/7/cQLqwpghuXVaV2kMpZ2kbHtOX0dRdR0/U6NjyrQc+6ooUSd
5itxhWoXN8y4yaSv0xAdN1j0iIKFrQtUZdF2nzDlVR7kYVa7sPMvdJdqC6AzRBby
WKAHqdUoxF7T/8OGVos5nLTRbBhoDm9v0jUKmTtWNj5rnwnB7M6x6zvZdODU3HFx
pHCmu6zhDcDYNx7/Sy21Mdr6NfHJc4uA4mxLU44uAnY+IgdgW9+7NajiLTRUuInK
ndqe1STBAlDFb1JP+aWgSu5rhx9YoY3Ikpo+QYqcLMli4mQmlWGUYCkMNuxnU7ij
yYEX74n9oxitNyWqOtJEQfEMyGokGC4Lj05SfcqnXPYGvDZlhFoCMPjTmJ7n6g7A
v7F8YRVlB+Ul+1bqwEMjDN5CRl4h/o4nUT0/yRiJLCizgRlA/7NEr8A1P5a96wmQ
/rn7BubrLLyF/v2QdlTegJEHH89bj5zTXmTpztqXyLJae0AtE2Fs03hKs8e2M5Js
fkiJOOjwJEiA1nrTPSrvzQEf+qVbI3K7s5P7txvkRRPZ8Oe/+wifUgMFZaq/okg8
fGTRgkG192CQt1KX/xxKcdJRZKahfW++GUUJj67SP6MMytTYMUYhqeeJ8d4Mj98z
yQv9vvF8pig7RYxNrjBr
=+a2d
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Jan_2014_15_09_51_+1100_77q0qdykXRKfztXB--
