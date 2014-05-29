Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbaE2IBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:01:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:46682 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616AbaE2IBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:01:41 -0400
Date: Thu, 29 May 2014 10:01:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@intel.com>
Subject: Re: [RFC][PATCH 1/5] mm: Introduce VM_PINNED and interfaces
Message-ID: <20140529080134.GC30445@twins.programming.kicks-ass.net>
References: <20140526145605.016140154@infradead.org>
 <20140526152107.823060865@infradead.org>
 <538691FB.8060309@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CR5S1WJ1/E083K3u"
Content-Disposition: inline
In-Reply-To: <538691FB.8060309@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CR5S1WJ1/E083K3u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 09:48:43PM -0400, Rik van Riel wrote:
> On 05/26/2014 10:56 AM, Peter Zijlstra wrote:
>=20
> >  include/linux/mm.h       |    3 +
> >  include/linux/mm_types.h |    5 +
> >  kernel/fork.c            |    2=20
> >  mm/mlock.c               |  133 ++++++++++++++++++++++++++++++++++++++=
++++-----
> >  mm/mmap.c                |   18 ++++--
> >  5 files changed, 141 insertions(+), 20 deletions(-)
>=20
> I'm guessing you will also want a patch that adds some code to
> rmap.c, madvise.c, and a few other places to actually enforce
> the VM_PINNED semantics?

Eventually, yes. As it stands they're not needed, because perf pages
aren't in the pagecache and IB goes a big get_user_pages() and the
elevated refcount stops everything dead.

But yes, once we go do fancy things like migrate the pages into
UNMOVABLE blocks, then we need to have VM_PINNED itself mean something,
instead of it describing something.

But before we go down there, I'd like to get the IB bits sorted and
general agreement on the path.

--CR5S1WJ1/E083K3u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThuleAAoJEHZH4aRLwOS6DP8P/1IFis+qI+Cr3bWTHrHH9YYy
cF4qu8m9nR8yt1y2+N3ELAYXeJCq/ow8Jd115R/eUV1pdxYV5NuG9rukKA0klDOa
AEP49AS/8fSqGOvWuH4v4gnDQVjffGzGEf3LWGrIh0lSHARoXaMQ4bmxFCNWuaqA
gldnEIHGW3glWIkVSocrbSY0aSciCvHBErkUUTFe3QvMTa6fAcnbweE7Zc8tAzid
Wtjc7YH9SGBnQtQa8MrrMGFSg26FQgWivINyvohKyFGrHApydRO7HID2nvgwuARL
1MFsWlxR98EujGv7oi0Hf0A/F7ScdS4ZWUuI5uo7x6ZDZDXiy+BwdFDnRLyxDGdZ
NVk85K1YZLLZ0e8Ff48nB2xY0S5K9feIsudCGqX4ikZ+8he57c6DEDOyYXmFMjK+
/A17zL+yzYXWpDVSjRMFBG7dK0vevXJ6hjdk5cpm0oiZMz2pbwD6LDqTzK/L4t39
u5VA0uQyadbXGAuESz7qrS/hqTI7NlyNFbBCH3opLdp2DMoXhXIX9xxpTVNy4Ufs
yoNiuF+p8Gyazc+sjRTHnQIVW4pGWNrxiIS/9UJS2AYYpdHixOF9bivKCci1pg2i
i3L/szF9eq8ev+VwKkGcowmbcc5R1PQ3b8B92ntvaXsrVCugRfMWexAbrvKEZPB3
4+4zdsXqvhwGDa0QVwpW
=dCSI
-----END PGP SIGNATURE-----

--CR5S1WJ1/E083K3u--
