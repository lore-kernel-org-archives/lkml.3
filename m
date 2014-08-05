Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaHEN3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:29:00 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50292 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbaHEN27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:28:59 -0400
Date: Tue, 5 Aug 2014 15:28:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2 v6] locking/selftest: Support queued rwlock
Message-ID: <20140805132837.GA19379@twins.programming.kicks-ass.net>
References: <1406659999-13974-1-git-send-email-Waiman.Long@hp.com>
 <1406659999-13974-3-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iOW3YyawJKyeVshs"
Content-Disposition: inline
In-Reply-To: <1406659999-13974-3-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iOW3YyawJKyeVshs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 02:53:19PM -0400, Waiman Long wrote:
> The queued rwlock does not support the use of recursive read-lock in
> the process context. With changes in the lockdep code to check and
> disallow recursive read-lock, it is also necessary for the locking
> selftest to be updated to change the process context recursive read
> locking results from SUCCESS to FAILURE for rwlock.
>=20
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  lib/locking-selftest.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
> index 872a15a..9a33688 100644
> --- a/lib/locking-selftest.c
> +++ b/lib/locking-selftest.c
> @@ -267,19 +267,19 @@ GENERATE_TESTCASE(AA_rsem)
>  #undef E
> =20
>  /*
> - * Special-case for read-locking, they are
> + * Special-case for read-locking, they are not
>   * allowed to recurse on the same lock class:
>   */
>  static void rlock_AA1(void)
>  {
>  	RL(X1);
> -	RL(X1); // this one should NOT fail
> +	RL(X1); // this one should fail
>  }
> =20
>  static void rlock_AA1B(void)
>  {
>  	RL(X1);
> -	RL(X2); // this one should NOT fail
> +	RL(X2); // this one should fail
>  }

Maybe I wasn't clear; but I meant you should extend the lock tests to
cover the full qrwlock semantics.

That means we also need tests like:

	RL(X1);
	IRQ_ENTER();
	RL(X2);
	IRQ_EXIT();

To fully validate that in_interrupt exception to fairness etc..

--iOW3YyawJKyeVshs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT4NwFAAoJEHZH4aRLwOS6AJYQAKLgwSExmza+rJH4eoMUh7GW
kx3AlMjzJHCpwhAP614yJSjohI9HKCO7PhgP07/cLz6cEXL1Cc8GjbJtlb3c9ad0
dIh29oRHzX6BfQk1EVBWatVznBsao7f4wZN1oPb9W1ZRwRbJL+xJdlCS/mxi4EbO
rECuHHlert2wIZo9M189smIMEjTmxEbnSoDav3qDbZxjOpb/KBColvwrYhJ//VoZ
kTbtXJ7XLtBy0s+qTVEKq1PYMGivQZ40+pOLrOI7jTlOb/9UgG2oJvhte3+6QIQ9
fDHVHNj0dHaBnzQTm3tyjqYoDPjiWwizGo6QHl982HSrJQ9vObEyNS/nxerYza4e
3gfBLoShdOugbQwnzpKu9OAsfAQDnZzuDwGCWYmoo7axYtMsyiTqxoacn6/1vo+e
vKHfTxcYZMuu862gdRhc3497Nk/35sTb/CZ1aPHnSf9B/yQnldKCNoJnP1yqaFfC
MPYAvQh9SYi/AaTOqlEhs4YKDLRMBqOEQNSJX4vj3WnEu0FefS9TVnWMx2KHwhdA
KL8mDk6An/SV2onRD3/YdzQwpvp/eectRdBG4XhC/JvsFlu0McJOGlClINn+vnwc
4mrKoMqtEZ2s5rPWwnY0LLv+kO0MRAa+fawJLE2z04KBDCcCMOZ/RNfO2nrjHIO1
c7qsNM2s68HaQa7dN314
=A489
-----END PGP SIGNATURE-----

--iOW3YyawJKyeVshs--
