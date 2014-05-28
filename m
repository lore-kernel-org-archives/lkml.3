Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbaE1IMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:12:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:41380 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaE1IMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:12:10 -0400
Date: Wed, 28 May 2014 10:12:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [RFC PATCH 7/7] perf, x86: drain PEBS buffer during context
 switch
Message-ID: <20140528081204.GQ11096@twins.programming.kicks-ass.net>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-8-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UJoEJyuH25+IoM96"
Content-Disposition: inline
In-Reply-To: <1401257890-30535-8-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UJoEJyuH25+IoM96
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 28, 2014 at 02:18:10PM +0800, Yan, Zheng wrote:
> Flush the PEBS buffer during context switch if PEBS interrupt threshold
> is larger than one. This allows perf to supply TID for events.

I have the distinct feeling you're doing this patch series the wrong way
around. It seems to me patch 5 completely breaks PEBS, patch 6 maybe
patches it up a bit, but only after this patch things work again
(maybe).

That's wrong.

--UJoEJyuH25+IoM96
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThZpUAAoJEHZH4aRLwOS6srgQAKmAtRGpNxSNCapIebXhli8j
nw8nlGWIuoyQYtVTv/JvC84Ua7CPOb2v6g5phPUM0ZoMc38IZGnPz6VpvOcBz2Ok
yGIi6MfaBejzbHdmlKx4k/tfbIFqCNx32BkylwK0KZwsVAiTXO7yhi5Bh4EKr3yW
2oXbxHqq/TqIMDtTZ4n4aNq4jmL+8Im0FsVr7biDpjKP+CRlNu1FxHebAfdaPT7M
syz+aE5ZZyCb/DSBZ0vlbr6O3tRZZPiJ8YRapeDGwWORKSZFiF0DPXkuEOO3LvLO
Im4G8pSByvLozhuZ8VddQs6HHVtmObhP4MIDxbFWwrxJg7m1/cRGQJFdrZH3ePW9
Y1GdZ5NQWkcW3hoOTjVoB4Hk63Vs2oSv9UuzlKPtDM0UyZyYTGnTEITmy3gigqHi
kDGeGC4aUF8cvrQNDzRVkCQmVkvKrWplQMyG0NWuQHvesXamxxuc0lTKUPobDEuf
ufQe9biLv5bw/k8Q9nGof8xKktNJ5jKxC7KP5IO6GPXuisZzbRhl9tbgOMUOegrH
OwwRgNuLZ1hlSBC/aTnRUm4WK+svOWz3nbIB+Pe8IvjhqSkFe6P34mE3pGR75UQI
mpXyYeF44H5ZzClyUDOb55gyX+NVZKIIhavARYl2gyPFBGiymP9/BVdvwSeZ4iUj
LQb35/QfFSG9UmCE3Je6
=gI11
-----END PGP SIGNATURE-----

--UJoEJyuH25+IoM96--
