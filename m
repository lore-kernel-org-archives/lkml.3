Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbaEIKN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:13:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46726 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbaEIKNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:13:24 -0400
Date: Fri, 9 May 2014 12:13:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: Re: [PATCH 2/4] sched,numa: weigh nearby nodes for task placement on
 complex NUMA topologies
Message-ID: <20140509101317.GU30445@twins.programming.kicks-ass.net>
References: <1399569811-14362-1-git-send-email-riel@redhat.com>
 <1399569811-14362-3-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y9FGoQKSF2AxjRbT"
Content-Disposition: inline
In-Reply-To: <1399569811-14362-3-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y9FGoQKSF2AxjRbT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 08, 2014 at 01:23:29PM -0400, riel@redhat.com wrote:
> This patch does nothing on machines with simple NUMA topologies.

Was this:

> +	/*
> +	 * No need to calculate a score if the system has a simple NUMA
> +	 * topology, with no node distances between "local" and "far away".
> +	 */
> +	if (max_distance == LOCAL_DISTANCE)
> +		return 0;

Supposed to make that true?

It doesn't. That test is a !numa test, not a fully connected test.

--Y9FGoQKSF2AxjRbT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbKo9AAoJEHZH4aRLwOS67MsQAICJzM111KyHZulFZEPT0kVI
vsmtDmiShSITcxq6nMBOsSRaE6KmvGBSSg/KkT+1kCvP1nEPLrtjQD9/Ia5OjzTp
gt/QazhwG4tlA8zO2YtM9OX2zIwY7XA5X0eIebl/5OJ/eENwJn10nlIebN0zvLZf
8sDKmsBH7XUI0IJAPc9JhHnPqs0A663xTZbAC7dwj2hBW3UfFqQU6sPh52ndjbQZ
3SX5TfzKyWx3x/ZFl2sMKQ262gJlB//HNIaiVulESwmTgGtoYvXRPj2hCQrlfYxS
BiW2DCI5eoggLOcr2I3B+kKnGmIg/51mKIrkK3IiiDjcKtUIw45Eh/e5e0hpy1nd
AdmxN5mZ9tQH46ZQduBullLAuQLxzDpRB/1N1wpwiWID29Mf188CdellqF7u0gQs
5DxWm0+Ac9L9NOqcEuU+5dkh8msS28lVhnXiPexlOqFOcHdZ7ruMo8XJgE2O8WEd
eeQnCwOKPUPoG+KXsAl4FLhIwuIhUN2/3dyuKdQ/iSgi3y+DAZc9xYv49aR2ZwTT
K5b71hIOSIPhLQrepz48X6hxaQtox/7ef93N173lRVVnEFZ+4mD+XrV0EADcCz4u
Qn4aQOLfJe7Y2lSd+FMlNk7kTRb5bd2BxNku53lotpFiDSWXRRPtJVjn11rrUuHe
VjkwGn+z+Tus8jn1uBDR
=er7o
-----END PGP SIGNATURE-----

--Y9FGoQKSF2AxjRbT--
