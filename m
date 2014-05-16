Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbaEPKUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:20:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52554 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019AbaEPKUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:20:49 -0400
Date: Fri, 16 May 2014 12:20:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ben Segall <bsegall@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix exec_start/task_hot on migrated tasks
Message-ID: <20140516102043.GT30445@twins.programming.kicks-ass.net>
References: <20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lw/GBiv4LoRdT+hF"
Content-Disposition: inline
In-Reply-To: <20140515225920.7179.13924.stgit@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lw/GBiv4LoRdT+hF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 03:59:20PM -0700, Ben Segall wrote:
> task_hot checks exec_start on any runnable task, but if it has been
> migrated since the it last ran, then exec_start is a clock_task from
> another cpu. If the old cpu's clock_task was sufficiently far ahead of
> this cpu's then the task will not be considered for another migration
> until it has run. Instead reset exec_start whenever a task is migrated,
> since it is presumably no longer hot anyway.
>=20
> Signed-off-by: Ben Segall <bsegall@google.com>
> ---
>  kernel/sched/fair.c |    3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 28ccf50..9f8dfeb 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4544,6 +4544,9 @@ migrate_task_rq_fair(struct task_struct *p, int nex=
t_cpu)
>  		atomic_long_add(se->avg.load_avg_contrib,
>  						&cfs_rq->removed_load);
>  	}
> +
> +	/* We have migrated, no longer consider this task hot */
> +	se.exec_start =3D 0;

se->exec_start compiles loads better

--Lw/GBiv4LoRdT+hF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdeZ7AAoJEHZH4aRLwOS6ATsQAJHbEAkkUed5KzX0KYoYbDGD
tiYS59HOVidHXGVAThoYN97XIqkpO2hVtsCF6sNMWn1zwfBg6sJv2CFtTQDZPe40
7hAplKgJeWIzD65h1BwZrYmpF4sjaQpo/ftr/zScBI1P7GAJeElHWSywFE+dDx/W
l5h+ROt41noSfimPGeo8wYWWrBGHQzJjwQmOwgn0k5VZ2PH5Yr63bC4vXDtQNO5U
FJfn6CEu+Q0Ox8wvMTgnD7uhvnNIhre1yM8IWI1Xdv7BWTilk5CLraXLVLYbaVp5
xFQhZG5u+gxwYVgHgbhQEq3inweFi2sjeqmZjlmBZeCNCRH0JbFmAPPR0GceQYV4
5ueKXrzmTDche/OK6EgIpPkoDzyPvwVEoyfzv2r+q431R6+HjtMtBNiI5RGiAqo7
/ADW6fOjFKXZlDWKpGkbo2W2z9E0HSNDaLekKxO8YYl9cCFizW1d2r5nTMFXx+SU
agVzEkdjliiL4Gsre/+fF2nepm0rVTM0f4KvwIY6ZPW86+ecWjs8+zcN2MaTJYXg
GcGjT0SXcBE0VkndPaLcTClwjaoHf1V4JHr2BZ/LAtaqikMJmRn10p2G5GL9i8MO
lxrI0kiRKkhWKWR0ghMzwujI/lhqAoS6u0XQuUUHuWl6qjI7B+UJB7lbvGdaZpyr
HqqgWay/WIt54+VDRsFw
=yOpt
-----END PGP SIGNATURE-----

--Lw/GBiv4LoRdT+hF--
