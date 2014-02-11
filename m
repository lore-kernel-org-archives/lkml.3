Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaBKSOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:14:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbaBKSOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:14:16 -0500
Message-ID: <52FA686F.6070701@redhat.com>
Date: Tue, 11 Feb 2014 13:14:07 -0500
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, m@silodev.com, stable@vger.kernel.org,
        akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] ipc,mqueue: remove limits for the amount of system-wide
 queues
References: <11414.87.110.183.114.1391682066.squirrel@www.silodev.com>	 <1391803868.1099.23.camel@buesod1.americas.hpqcorp.net> <1391979963.1099.34.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1391979963.1099.34.camel@buesod1.americas.hpqcorp.net>
X-Enigmail-Version: 1.6
OpenPGP: id=0E572FDD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="MBX2lhCQMUiJIMABkDQEov32oLUSsjjaT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MBX2lhCQMUiJIMABkDQEov32oLUSsjjaT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2/9/2014 4:06 PM, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <davidlohr@hp.com>
>=20
> Commit 93e6f119 (ipc/mqueue: cleanup definition names and locations) ad=
ded
> global hardcoded limits to the amount of message queues that can be cre=
ated.
> While these limits are per-namespace, reality is that it ends up breaki=
ng
> userspace applications. Historically users have, at least in theory, be=
en able
> to create up to INT_MAX queues, and limiting it to just 1024 is way too=
 low
> and dramatic for some workloads and use cases. For instance, Madars rep=
orts:
>=20
> "This update imposes bad limits on our multi-process application. As ou=
r
> app uses approaches that each process opens its own set of queues (usua=
lly
> something about 3-5 queues per process). In some scenarios we might run=
 up
> to 3000 processes or more (which of-course for linux is not a problem).=

> Thus we might need up to 9000 queues or more. All processes run under o=
ne
> user."
>=20
> Other affected users can be found in launchpad bug #1155695:
> https://bugs.launchpad.net/ubuntu/+source/manpages/+bug/1155695
>=20
> Instead of increasing this limit, revert it entirely and fallback to th=
e
> original way of dealing queue limits -- where once a user's resource li=
mit
> is reached, and all memory is used, new queues cannot be created.
>=20
> Reported-by: m@silodev.com
> Cc: Doug Ledford <dledford@redhat.com>

Acked-by: Doug Ledford <dledford@redhat.com>

> Cc: Manfred Spraul <manfred@colorfullife.com>
> Cc: stable@vger.kernel.org # v3.5+
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  include/linux/ipc_namespace.h |  2 --
>  ipc/mq_sysctl.c               | 18 ++++++++++++------
>  ipc/mqueue.c                  |  6 +++---
>  3 files changed, 15 insertions(+), 11 deletions(-)



--MBX2lhCQMUiJIMABkDQEov32oLUSsjjaT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS+mhvAAoJELgmozMOVy/d+nAP/2EpHxHLNdJ5Ju+1Sl+trYc0
hNE7/dj4xBRTdlJk0//VxomEUM51U1n67iEYgXe95kCkpY5m/iRTDV3JBR/LtKKz
zMaTSUoR4OGa8T/rddIRP6hBMw8SgJU7i41MTfYcqlmh6z11wlRX9mem7EX3QO73
iQmP/1AnBpkdU+6UAsXuT0jVJ7pD5f5IS5syb9B6LzUkwq+AOeRW3umGaBU1wjXZ
I9YgiSNwma5anq5dbb9em79Yq2JAZp0Gcni0u2vAVzH/k8p4zAMvHod6xwHFFYQ4
kPygSHTHn+V0N7uhZS3Zpq+RDl0kTP33bLuZ9k2VfexYXzbcYVhfyhBIsO7tCf7u
tIlE+xxLZfBguQgL2YHyNoUwvJ0uqQrO21VpInGpeVj9lCTXqbZGNUyMI1HWN3c3
UCEEfgaDwtF7WmWlB9J3pdGnU+wkhYKuz9RLv26ifx45RRJRODO+o1Wq9OE5vR0+
nZeLXVljW4PEEaVNRqxaM16pD+lfe4rTl87Ue6CiUT6ATcshJqGwO6qjx7oRPUc4
1Ity2Eg1b657BguQZZ5LhUwUOSNghYRv1UxWy+cRdfeI7LJPH2AFETj1whNJc2fi
xuuSj2Flasx4FNbcNGTxM3nvjn3mnPROSo0pBDE2ZCr0wwuio/oH4R/TaniYwF/t
IaCd+6t/IMKL+M2xZAPM
=MZkE
-----END PGP SIGNATURE-----

--MBX2lhCQMUiJIMABkDQEov32oLUSsjjaT--
