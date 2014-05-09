Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaEIJx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:53:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:48316 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaEIJx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:53:27 -0400
Date: Fri, 9 May 2014 11:53:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: Re: [PATCH 2/4] sched,numa: weigh nearby nodes for task placement on
 complex NUMA topologies
Message-ID: <20140509095324.GQ30445@twins.programming.kicks-ass.net>
References: <1399569811-14362-1-git-send-email-riel@redhat.com>
 <1399569811-14362-3-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hNweOTLwwbnii4NA"
Content-Disposition: inline
In-Reply-To: <1399569811-14362-3-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hNweOTLwwbnii4NA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 08, 2014 at 01:23:29PM -0400, riel@redhat.com wrote:
> +		/*
> +		 * For nodes with distances in-between LOCAL_DISTANCE
> +		 * and max_distance, we count the faults on those nodes
> +		 * in proportion to their distance, using this formula:
> +		 *
> +		 * max_distance - node_distance
> +		 * -----------------------------
> +		 * max_distance - LOCAL_DISTANCE
> +		 */
> +		if (task)
> +			faults = task_faults(p, node);
> +		else
> +			faults = group_faults(p, node);
> +
> +		score += 1000 * faults *
> +				(max_distance - distance) /
> +				(max_distance - LOCAL_DISTANCE);

OK that makes sense, except I would suggest you use a power-of-two scale
factor :-)

--hNweOTLwwbnii4NA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbKWUAAoJEHZH4aRLwOS6ABUP/0Cd7usK5MHlvGTZC7e01hEs
h2UI3EKvVel2D5AWD0f45GAAATEUbDgkw+Fb2SMHxUasUpOcVyxW0j1OYpRFr0HU
8xNsBQX6xlwW+mB0kcyGl3Vsms6iaUq1DgREsav4JNDj+NivOXQHVUpxs9zbUZlf
68LRzzJhodt0qRCg81w+52WaNmvIENJKG+AdY6MrSNZ4bscUPfY+LxyucrlryzWZ
q+JtCNBa3Gni8x9ATqm+H51NLDrpcDMYc1JWL18Ss80Adhq2spbxy3eqF5EurXxi
9zdSEZ/3N+diPTF7oabI+X3j4Dy9wzZI5Vo1T/hJS6ncJPegZ/7TPlaQGQXOOX5U
oUNm9vXoUHnvKbH0eShZ7lv4kBmItMs44W382mrT/ibhMIS0MLWfOmBv+PKDpV0u
dvhk6kNrt5Rzty1wqGhYOWATVzQ6GOjb8USmRjGlF/PETR4Xwd9T5m0gpEJs6fUq
OL/TPTiywMtlJlj39CSnD/EXy8b/cmg8YUkTRIn6b4JnyxlIY/wR3UaJRIhVXms4
LiNf3FqRWNPvCE2obBVzz63ft/Ag+4maii82mf6iO6EUAW5lAaKV4pM+Hcb7BgKg
sWaJXt9w8jrFeFzicJkqn6DmN9TGa0bSbXATI4LtcrDQTmGvkBGrkGoMF49k68uN
dXctMO+Bxu5SuHYfZUBY
=EGCo
-----END PGP SIGNATURE-----

--hNweOTLwwbnii4NA--
