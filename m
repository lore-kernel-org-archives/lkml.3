Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaIHHCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 03:02:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38346 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaIHHCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 03:02:53 -0400
Date: Mon, 8 Sep 2014 09:02:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 02/22] perf: Add AUX area to ring buffer for raw data
 streams
Message-ID: <20140908070242.GS19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-3-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwupbN87Vo8OarNr"
Content-Disposition: inline
In-Reply-To: <1408538179-792-3-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wwupbN87Vo8OarNr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 03:35:59PM +0300, Alexander Shishkin wrote:
> From: Peter Zijlstra <peterz@infradead.org>
>=20
> This patch introduces "AUX space" in the perf mmap buffer, intended for
> exporting high bandwidth data streams to userspace, such as instruction
> flow traces.
>=20
> AUX space is a ring buffer, defined by aux_{offset,size} fields in the
> user_page structure, and read/write pointers aux_{head,tail}, which abide
> by the same rules as data_* counterparts of the main perf buffer.
>=20
> In order to allocate/mmap AUX, userspace needs to set up aux_offset to
> such an offset that will be greater than data_offset+data_size and
> aux_size to be the desired buffer size. Both need to be page aligned.
> Then, same aux_offset and aux_size should be passed to mmap() call and
> if everything adds up, you should have an AUX buffer as a result.
>=20
> Pages that are mapped into this buffer also come out of user's mlock
> rlimit plus perf_event_mlock_kb allowance.
>=20
> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> ---

> +void rb_free_aux(struct ring_buffer *rb, struct perf_event *event)
> +{
> +	struct perf_event *iter;
> +	int pg;
> +
> +	if (rb->aux_priv) {
> +		/* disable all potential writers before freeing */
> +		rcu_read_lock();
> +		list_for_each_entry_rcu(iter, &rb->event_list, rb_entry)
> +			perf_event_disable(iter);
> +		rcu_read_unlock();

Hmm, I cannot remember this from the last time; and its not explained
why this was added.

This would change semantics between munmap of a buffer with and without
AUX bits in.=20

> +
> +		event->pmu->free_aux(rb->aux_priv);
> +		rb->aux_priv =3D NULL;
> +	}
> +
> +	for (pg =3D 0; pg < rb->aux_nr_pages; pg++)
> +		free_page((unsigned long)rb->aux_pages[pg]);
> +
> +	kfree(rb->aux_pages);
> +	rb->aux_nr_pages =3D 0;
> +}

--wwupbN87Vo8OarNr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDVSSAAoJEHZH4aRLwOS6VuYQAJgSXdIATW2N2PgSpLslHyxI
aWvJneb049InLpXvmbeN+bqXgRUG99yuxgyaVu8r1Pkhak5jwXqpEph5+fnaBttY
A/6ZklFXlNOQb7LVmSyrRCChu8O1eiVH/HtBm0EiuvrI8nphxum5QpWkeOj1nBTH
F/3JzrGroQeKX2EaSUSj51pw4EKLb5PlwI3+wz52Eu9FyoxRCizUwK5HAy2KedsL
TfLRfEvjBQu0y/jjLpxZBx4zYC+J+137vXdZewtZ0dF6RM/j7GhPylyA1tx2JrDn
au8VAf6VLZLs2Xfgc4v9OP9E4AkEh1yPKGuHWNI0cgSYa+NDP3kmN4H3wLQkAsck
u0PvC3a2S+6cAx55mH/ke+kQ8Ua02b9jEcvJhP6f2vaRQKPVibFwIU6LSOaH7lys
ZQuC3gY6MbarGRADo7EotJNA+neMb4qcVGK30BCS2OcOwZDUiSrYdE9EH/D09Lpn
/q4Rm/of8sca8EaAw6qdTEscoX8PcVcJosTTINk1oCYzJgrD7IIPxHj+4FkxGKux
qbxU54NQCnOuJw72MDzBOPcBM/RWSjD9MfDr9zT9Lsqthu9O39PGmDotxB6mbGii
KoI/WnZjJfdbiVNoXtY5FPfgX51s7+uj9qEqU04J8dZMfzywQtinff66GrS7GmtJ
y0WnT9AC9hIPt+KAKCsP
=61rC
-----END PGP SIGNATURE-----

--wwupbN87Vo8OarNr--
