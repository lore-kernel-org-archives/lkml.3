Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbaEIJyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:54:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:48330 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbaEIJyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:54:17 -0400
Date: Fri, 9 May 2014 11:54:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: Re: [PATCH 2/4] sched,numa: weigh nearby nodes for task placement on
 complex NUMA topologies
Message-ID: <20140509095414.GR30445@twins.programming.kicks-ass.net>
References: <1399569811-14362-1-git-send-email-riel@redhat.com>
 <1399569811-14362-3-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yJLks8MEB0SlUFSu"
Content-Disposition: inline
In-Reply-To: <1399569811-14362-3-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yJLks8MEB0SlUFSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 08, 2014 at 01:23:29PM -0400, riel@redhat.com wrote:
> +	/*
> +	 * No need to calculate a score if the system has a simple NUMA
> +	 * topology, with no node distances between "local" and "far away".
> +	 */
> +	if (max_distance == LOCAL_DISTANCE)
> +		return 0;

That's basically !numa and we shouldn't be getting here, so I think you
can make that a WARN_ON_ONCE().

--yJLks8MEB0SlUFSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbKXFAAoJEHZH4aRLwOS6XugP/1lelZNT0MfjCLQTFICTJ/I5
kplkfvkLAVeLGVzWeudPx+qtksl26WdeJ/9YFm/9EnD0Ok9Isxe9QHwkgdN5sQ5r
cnXq7nlZ5AueqMrkcwifaTubUc9kk4X53Fms96bMhqt0GrHmOFuPNsUpwKOV4148
ValbhFex8LSke6fuZGjKMZl+pY6RCzVSxj2+jyLix8iEYSlm25TWW5BMLBzHomzN
41QdymmUCrV6Z7xXldUngCvGQVB7fxNgIx9AMEe3h842D5bZ8ROowury6Eiy+Viy
Bn9pLOfMc2e+15KEM5+ie4AysFsagxVYPPVVdOMI0zZjMDLJZNCwBItD66MxDmLM
m6qvwhajn3lruJkvUrRhGypntoCguaZazx6LHM1e44epkzYiob0ff7I3tDWEFLRa
5JFyFPcH/rnAGMvPqFv0nBIxLErq/R8c4JHF9jSgsmvLw3RGoxtbQ+q6vtBeLEO+
RbUz/iBfHvr2fyfW7i4Wopl+XWrqdAM98KndZwaGimRA4TJcbnjewL1mMAGE87EW
NApJ8wZmqmKG6Qdh3cxkhBOlMj6d8vJSUa8UYNbtfUsOkPVF8pbb1/Q86gn3ZeLp
lrhvFSbDMTfL4r+WQ+zt/wQFC/jHhhYCYhn9VGd3SX83C/QLKNpT5SJKsQUX/G1j
TfrM7WYLzcMEYGOosoh8
=LWSg
-----END PGP SIGNATURE-----

--yJLks8MEB0SlUFSu--
