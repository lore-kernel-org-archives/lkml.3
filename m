Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227Ab3CMVvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 17:51:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57604 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273Ab3CMVvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 17:51:39 -0400
Date: Thu, 14 Mar 2013 08:51:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Artem Savkov <artem.savkov@gmail.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, viakernel.org@htj.dyndns.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH] workqueue: missing idr_preload_end() in
 worker_pool_assign_id()
Message-Id: <20130314085136.13358830385003e4263ec1f4@canb.auug.org.au>
In-Reply-To: <20130313175745.GA22267@htj.dyndns.org>
References: <1363197092-4832-1-git-send-email-artem.savkov@gmail.com>
	<20130313175745.GA22267@htj.dyndns.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__14_Mar_2013_08_51_36_+1100_H0t7JhU9pYDKZvDq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Mar_2013_08_51_36_+1100_H0t7JhU9pYDKZvDq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Wed, 13 Mar 2013 10:57:45 -0700 Tejun Heo <tj@kernel.org> wrote:
>
> (cc'ing Stephen and linux-next)
>=20
> Hello, Artem.
>=20
> On Wed, Mar 13, 2013 at 09:51:32PM +0400, Artem Savkov wrote:
> > Added missing idr_preload_end() call in worker_pool_assign_id().
> > Without it preemption stays disabled resulting in lots of "scheduling w=
hile
> > atomic" BUGs during boot.
> ...
> > Introduced in "workqueue: convert to idr_alloc()"
>=20
> That patch doesn't use idr_preload().  It looks like the issue is
> introduced during linux-next merge of wq/for-3.10 and idr patches in
> -mm.  Stephen, can you please add idr_preload_end() to the merge
> patch?

Oops, sorry about that.  I assume it needs to be added just after the
spin_unlock_irq() but still inside the loop?

> Once the idr patches land in Linus' tree, I'll resolve the conflict
> from wq tree side.

Or you could do what Linus prefers and just tell him how to resolve the
conflict and thereby avoid a back merge or rebase (or provide him with a
separate branch that does the back merge with resolution in addition to
the unmerged branch to pull).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__14_Mar_2013_08_51_36_+1100_H0t7JhU9pYDKZvDq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQPToAAoJEECxmPOUX5FEHbEQAIIAZQPxa2emylgYs/goO4hW
4UqMoHnhaIwTUXD22inUWRMwSH4srZAVwMKqhMqtmB0WV/zxU1dUErr8gvAD+oTU
VUmkpOKLmNy6EduyidfyaPbiw/dQKAn3dMufwc++6fg1ytyHcSJgJYVPnz+UZ4A7
rSIOqir+NUkuA9eY1bmZ1EcXgaqRjOqMmNZSeQPNDiKEpG0bjqsCTkaK8IpAiQCC
xdQPVE9PsoKcT7vvoTdHxDuC5wQ9AWUgjx5ZYHNLvmTsJmxO29INoX3rPSY1Oh+p
S9xoGuxTEN/H1y7PDUDxdNEVhn84yAL+SSe2nNOOEJQXvEybqgFOy20/t++VXBc1
U06P0+eFUPnebsKdnonIpus0TlvDf1AAaa62y5VhbrEfRywFuJOD8isEub5RlkqT
JGxyMKyubLibDUwsHR+MIWFYMWwHNMblcQL82lUfu4h1x5uRW6pFucZveFdX5xGY
cHIG0q3BSyi1gDKIcXbuZFhdagWQ0g5uIYfwfSpPdHJimU6haBE3FaZNOBuQ1t5f
z65GYhdmw5ebN6wOF0b1ZAMTzOF/HvgY0CmjpdUWkgSUkM6RboTyS01Cto4tCuKQ
11V6JYzIAWVdGvdv51GADY+WFdfs2A1j7YmTDEs5TJnuR1sbXfWbzdIL0UGkFKl1
OIeTg0FonbHEs6qAdyPt
=YHY1
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Mar_2013_08_51_36_+1100_H0t7JhU9pYDKZvDq--
