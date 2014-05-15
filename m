Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbaEONaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:30:01 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaEON37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:29:59 -0400
Date: Thu, 15 May 2014 15:29:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] mm: filemap: Avoid unnecessary barries and waitqueue
 lookups in unlock_page fastpath v4
Message-ID: <20140515132945.GM13658@twins.programming.kicks-ass.net>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
 <1399974350-11089-20-git-send-email-mgorman@suse.de>
 <20140513125313.GR23991@suse.de>
 <20140513141748.GD2485@laptop.programming.kicks-ass.net>
 <20140514161152.GA2615@redhat.com>
 <20140514192945.GA10830@redhat.com>
 <20140515104808.GF23991@suse.de>
 <20140515132058.GL30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lYetfuAxy9ic4HK3"
Content-Disposition: inline
In-Reply-To: <20140515132058.GL30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lYetfuAxy9ic4HK3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 03:20:58PM +0200, Peter Zijlstra wrote:
> void __unlock_page(struct page *page)
> {
> 	struct wait_bit_key key =3D __WAIT_BIT_KEY_INITIALIZER(&page->flags, PG_=
locked);
> 	struct wait_queue_head_t *wqh =3D page_waitqueue(page);
> 	wait_queue_t *curr;

	if (!PG_waiters && !waitqueue_active(wqh))
		return;

> 	spin_lock_irq(&wqh->lock);
> 	list_for_each_entry(curr, &wqh->task_list, task_list) {
> 		unsigned int flags =3D curr->flags;
>=20
> 		if (curr->func(curr, TASK_NORMAL, 0, &key))
> 			goto unlock;
> 	}
> 	ClearPageWaiters(page);
> unlock:
> 	spin_unlock_irq(&wqh->lock);
> }
>=20
> Yes, the __unlock_page() will have the unconditional wqh->lock, but it
> should also call __unlock_page() a lot less, and it doesn't have that
> horrid timeout.
>=20
> Now, the above is clearly sub-optimal when !extended_page_flags, but I
> suppose we could have two versions of __unlock_page() for that.

Or I suppose the above would fix it too.

--lYetfuAxy9ic4HK3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdMFJAAoJEHZH4aRLwOS6ZukP+wVHsi0r2hjIyvHrenQGvz/X
r5VBqVsF601MvQvr9ZoswfC6y27cfNO59NGsmspwjmbmPXFkSGkZiHl4PI4AwVVY
8O8y63ZwnKZCIUgWBvYz0/QUpDd8M0QmimMV/TUR0H6b0/qiT1Wx90mQRnzAAmK0
OBlVyxKRS0Z1ZeCqNcjQvNUEUmw8DPdzIBnkJR+oD2lkXJBcqJNPijwjIK/3F9L4
6ggs22RhzphV2DQ5fv+g8fFoFWQFHrhOoxL8zqTUhR6u5+J6YfH7YcQIereaSqYV
yRiU/gpEKsl0KglXxnKTNz+BeXp9W3v69byHzx4D69VwfdcFfLvqTg5Uq3enchOd
wXetc2i1WQTimd5dTsLTVZ0xgWGJP0ist0C/ZF1nwrmhVLnnHr+5hCpK9sW1PThF
BPLHMkqideLZnk8IIL6AsLer+YQABWPnFWVkDce5MLkPMqXYAqVVyXJ/1FVU/X0b
a7LA6QLHSKhfB4rPQG/Cc2gLq2Af9+RWjIIcVj/tncVRjbWfSZ9HxPaHLz2U54ML
vhwz1iTPJNLtxUn9zXoCOwsIH4I5zLLrb5NxDNpIM1i1+EbqG2aSgO69iqjF5onp
M9IaizbdpOuGKb82jrXWY+JKMcZ2sgWZ9GdEFuF4CLt6rBdq3wgtYPnO4XD4c209
z3DBW8+Ivygi4soqDVCm
=jxIX
-----END PGP SIGNATURE-----

--lYetfuAxy9ic4HK3--
