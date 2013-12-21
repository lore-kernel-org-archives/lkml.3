Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab3LVBbn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 20:31:43 -0500
Received: from ozlabs.org ([203.10.76.45]:55171 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099Ab3LVBbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 20:31:24 -0500
Date: Sun, 22 Dec 2013 00:58:19 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 03/14] mm, hugetlb: protect region tracking via newly
 introduced resv_map lock
Message-ID: <20131221135819.GB12407@voom.fritz.box>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1387349640-8071-4-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Content-Disposition: inline
In-Reply-To: <1387349640-8071-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2013 at 03:53:49PM +0900, Joonsoo Kim wrote:
> There is a race condition if we map a same file on different processes.
> Region tracking is protected by mmap_sem and hugetlb_instantiation_mutex.
> When we do mmap, we don't grab a hugetlb_instantiation_mutex, but,
> grab a mmap_sem. This doesn't prevent other process to modify region
> structure, so it can be modified by two processes concurrently.
>=20
> To solve this, I introduce a lock to resv_map and make region manipulation
> function grab a lock before they do actual work. This makes region
> tracking safe.

It's not clear to me if you're saying there is a list corruption race
bug in the existing code, or only that there will be if the
instantiation mutex goes away.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJStZ57AAoJEGw4ysog2bOSBdEQAOaAOMmUK8EGKd1tAgG6wpF9
UydrFqPy5nTreKrDrL3PwTR/EXfoK6+nnH99sh1QR19iPSpkA4sgmzKvHqCfHk31
fBC8ry6Ghc8yyUEVCcSjwZ0UIE9sGFD+9PFB+/uLe+XzsO+bsTOk88AJQ5qyDBP6
7FP1ECjP0DZaBWrLfUpSjZbYy8VWzjwHvLfy78C+syrflfaQ9DQEEtEdTI6ZJpmV
D7gT45jjuLvjuPIzSMk3d73GlkJxTlrNp2r3wF5nq+73i8OmG9MBL/NcvRWmvi59
ZxDTUPf8l34bqg8JdAIbzfRizeAPy1Wi5AXzqNs8eriJN8Esvq2mmtFm/1fTR8Hm
VyKrLoEYN6/N6wcBAZLuwrZNe++OfowUn9+GkCkG7QEGxaMDZlDtzT4Lup8qmRvB
tZlgujwR66m98keYa3a4CFlsnDiyfFiEvXg7Luwf419C4aH5sQlIRkHnxpv8v9Rz
F3BKM/hnQ+VcdYKa0N5BEMCgi3yebtfbtZ0+c0ksMdPfdzUoP8EWc+MkzhbJpzRx
mDOHOPm+nVWWgd3/hG88k/7a4/OEga+fYFaY/8UoJyL34Bi/iSRH/OnekiAi5DNi
Esb5rRmAOCGXuWzK5b7Z2svlWqj56g/KM4fk2yGpuUf68wcGTezBqOuX7LbbX30d
yxsXD8omoGoDjCzs99s/
=AvLd
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--
