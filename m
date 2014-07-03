Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaGCHjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:39:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59363 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531AbaGCHjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:39:04 -0400
Date: Thu, 3 Jul 2014 09:38:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        jason.low2@hp.com
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
Message-ID: <20140703073852.GV19379@twins.programming.kicks-ass.net>
References: <20140703023204.GN4453@dastard>
 <1404358268.23839.13.camel@buesod1.americas.hpqcorp.net>
 <20140703045933.GP4453@dastard>
 <20140703053911.GQ4453@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7Rldj+JZnTQmDdGi"
Content-Disposition: inline
In-Reply-To: <20140703053911.GQ4453@dastard>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7Rldj+JZnTQmDdGi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 03:39:11PM +1000, Dave Chinner wrote:
> There's another regression with the optimisitic spinning in rwsems
> as well: it increases the size of the struct rw_semaphore by 16
> bytes. That has increased the size of the struct xfs_inode by 32
> bytes.
>=20
> That's pretty damn significant - it's no uncommon to see machines
> with tens of millions of cached XFS inodes, so increasing the size
> of the inode by 4% is actually very significant. That's enough to go
> from having a well balanced workload to not being able to fit the
> working set of inodes in memory.
>=20
> Filesystem developers will do almost anything to remove a few bytes
> from the struct inode because inode cache footprint is extremely
> important for performance. We also tend to get upset and
> unreasonable when other people undo that hard work by making changes
> that bloat the generic structures embedded in the inode
> structures....

Jason Low actually did a patch, yesterday, to shrink rwsem back to its
old size (on 64bit).

--7Rldj+JZnTQmDdGi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtQiMAAoJEHZH4aRLwOS6KlAP/Rey63/pD3G/1DD/dwWFFjsF
r/bXngyDxabWTkIpG1Ra1nqf95IM9cDjmh/jeUdsZD52pT7EyH/EPEO2Sc32LTs8
5bFtsUlxLoypP9B1Ks+dnp6ABpVMg+1nr016atk7JjixYMacg5HfLPReNn0LzGcE
g/74/8DKWOSKRsXcKfsHvydD7lO53Ds9drVILl00TCHmyEipG//1ApUPupEzyhwe
69/bD24FNmsuNWKH22sKK7zWbHLVcXZM2sGbE7IxHjhDRIzdOkenexPc4HfWHZQ9
W7xwMQ+fmeSzoPqq9fr1cjiH8Q2WtoR0Vx2imjcNDmb6Ml5OxnYwB66T2BP2BYPA
C9HrVzD5OJnlpjCCvZEBdNsXbW4RJADyFQvomp+hdpxRIhpeR04fj5s0QbWV0z7V
gGEDS5elSrWikFK2ihQkj0MTQjwDUTxeR8YzJg0Zi4aV37kgovIsFnrM8EZDGFKw
OY91pUSEK1BEqvoagiyj6pBrIecmfeXr2XIJTjRonVjn8HSUnCXx3PULwFppVid3
fSZU6fzhwW4KgImiQE2JgWJE4giJJ3Q806+mmZ5bgd+pr6dBTBVX8hGrCgVyeNfR
eZfhY6oEgw5jArFeadH5hUKyS4M+CH29DNgl+4sRYmFJcLO0LniNafLdK8EW5QL9
tuSj2nzT/NElC7CzCFaq
=w6p4
-----END PGP SIGNATURE-----

--7Rldj+JZnTQmDdGi--
