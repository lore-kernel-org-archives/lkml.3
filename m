Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3HDJsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:48:39 -0400
Received: from ozlabs.org ([203.10.76.45]:37394 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab3HDJsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:48:36 -0400
Date: Sat, 3 Aug 2013 20:43:02 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH 17/18] mm, hugetlb: retry if we fail to allocate a
 hugepage with use_reserve
Message-ID: <20130803104302.GC19115@voom.redhat.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375075929-6119-18-git-send-email-iamjoonsoo.kim@lge.com>
 <20130729072823.GD29970@voom.fritz.box>
 <20130731053753.GM2548@lge.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <20130731053753.GM2548@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2013 at 02:37:53PM +0900, Joonsoo Kim wrote:
> Hello, David.
>=20
> On Mon, Jul 29, 2013 at 05:28:23PM +1000, David Gibson wrote:
> > On Mon, Jul 29, 2013 at 02:32:08PM +0900, Joonsoo Kim wrote:
> > > If parallel fault occur, we can fail to allocate a hugepage,
> > > because many threads dequeue a hugepage to handle a fault of same add=
ress.
> > > This makes reserved pool shortage just for a little while and this ca=
use
> > > faulting thread who is ensured to have enough reserved hugepages
> > > to get a SIGBUS signal.
> >=20
> > It's not just about reserved pages.  The same race can happen
> > perfectly well when you're really, truly allocating the last hugepage
> > in the system.
>=20
> Yes, you are right.
> This is a critical comment to this patchset :(
>=20
> IIUC, the case you mentioned is about tasks which have a mapping
> with MAP_NORESERVE.

Any mapping that doesn't use the reserved pool, not just
MAP_NORESERVE.  For example, if a process makes a MAP_PRIVATE mapping,
then fork()s then the mapping is instantiated in the child, that will
not draw from the reserved pool.

> Should we ensure them to allocate the last hugepage?
> They map a region with MAP_NORESERVE, so don't assume that their requests
> always succeed.

If the pages are available, people get cranky if it fails for no
apparent reason, MAP_NORESERVE or not.  They get especially cranky if
it sometimes fails and sometimes doesn't due to a race condition.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlH83rYACgkQaILKxv3ab8a6mACeMcPoIM7Q8waoJo5GgwcXbXSf
XG4An3cwsVzfNm5tifu9JOOLiDzisiap
=dFyv
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
