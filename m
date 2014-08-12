Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbaHLIV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 04:21:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbaHLIVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 04:21:53 -0400
Date: Tue, 12 Aug 2014 10:21:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, oleg@redhat.com,
        rostedt@goodmis.org, umgwanakikbuti@gmail.com, tkhai@yandex.ru,
        tim.c.chen@linux.intel.com, mingo@kernel.org, nicolas.pitre@linaro.org
Subject: Re: [PATCH v4 4/6] sched: Remove double_rq_lock() from
 __migrate_task()
Message-ID: <20140812082120.GO9918@twins.programming.kicks-ass.net>
References: <20140806075138.24858.23816.stgit@tkhai>
 <1407312387.8424.40.camel@tkhai>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IR8qaqqzop2UneN1"
Content-Disposition: inline
In-Reply-To: <1407312387.8424.40.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IR8qaqqzop2UneN1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 06, 2014 at 12:06:27PM +0400, Kirill Tkhai wrote:
>=20
> Let's use ONRQ_MIGRATING instead.

I feel there should be a little more in the changelog; how about
something like:

Avoid double_rq_lock() and use ONRQ_MIGRATING for __migrate_task(). The
advantage is (obviously) not holding two 'rq->lock's at the same time
and thereby increasing parallelism.

The important point to note is that because we acquire dst->lock
immediately after releasing src->lock the potential wait time of
task_rq_lock() callers on ONRQ_MIGRATING is not longer than it would
have been in the double rq lock scenario.

> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>

--IR8qaqqzop2UneN1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6c6AAAoJEHZH4aRLwOS6jFsP/2W3LxrR2mIBdFsynUcgq/z2
BnxYKnirWVTGAN3H79PQ3lVihgzx4rNSbZ/N2jbQoePuAnnQtU2L0/Oh5OxpwyGa
i2OY42rYKp9Q6gxyC8Y06MBDSpNwHkAaBrQEj/16z7zJzMVEgBzj4MSwAgi4X5UJ
sqEHRKRUSMF6+ML1F+rRXjtgSYvDcN6oq1ciC/8EafTgYo2sLlYFQxJGVUQ0lNM0
UZbdJNwofhpVCNPCd3zp8paL2HGl7hcExWgO+z+Z35N8R9Xd8N6F6SdIBGWhGY2a
7xaqlvPXQokT5FZeGeDtoFb8YWZivKVX4tHPrCa1ramACczEorQeRPj/XVRquAq9
D+PUQ2bZQhk0GL1m6fmK6be3gAxlBe1RX+79FDeBpD4olnvns5RsBuVvl4G9Em0Z
QuDQzLZ3Bi+fvMb21QEneS6SpWKJgiOY98yzzoWtueV/O5CjPVjmdoMGftkPmfES
nNgFgJOJCnkfZVF3cfhnP//Fca9HN1l1nNt6Ym+xAwAebTp9beEYxrMBpprWEpmJ
U0ZI8AJv2ioACHtV6J3+t7WqAb4OUc+Zs3tFOlM3hGfTRD7y95Mk4ckuvYPSu9r5
/3ZnKeEBkzqxxjQCCU8hDilNFYbd77e+H5FiOCF334hL7IKdhVZzcYxbWWubYfWi
A3cFhRXyVByEgcWakiHD
=320P
-----END PGP SIGNATURE-----

--IR8qaqqzop2UneN1--
