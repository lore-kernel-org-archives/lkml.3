Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaGBJGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:06:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:59507 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaGBJGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:06:45 -0400
Date: Wed, 2 Jul 2014 11:06:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 03/16] perf, x86: use context switch callback to flush
 LBR stack
Message-ID: <20140702090638.GU6758@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
 <1404118253-19532-4-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="onwk0SivC/dtQkFp"
Content-Disposition: inline
In-Reply-To: <1404118253-19532-4-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--onwk0SivC/dtQkFp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 04:50:40PM +0800, Yan, Zheng wrote:
> @@ -185,6 +185,23 @@ void intel_pmu_lbr_enable(struct perf_event *event)
>  		return;
> =20
>  	/*
> +	 * It is necessary to flush the stack on context switch. This happens
> +	 * when the branch stack does not tag its entries with the pid of the
> +	 * current task.

Did you mean to say: "This happens _because_ the branch stack does not
tag its entries with the pid of the current task." ?

> +	 */
> +	if (sched_in) {
> +		intel_pmu_lbr_reset();
> +		cpuc->lbr_context =3D ctx;
> +	}
> +}

--onwk0SivC/dtQkFp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTs8udAAoJEHZH4aRLwOS6/3EP/iPj0TAmtUaTX0x5er6rR/wh
dn4STUQkrzZwO66v5nN84EXVgYiblTHrIR+hFp2z8HbtJVOScdzaAFfUZ0CLsm8+
ndcX6RNQPqwVb+iHwmYzdOJTjv0AAl28g1eUslGk2OzyfhJv2BzWuwJz3BYs18qu
YjciD8Xv7/Pmj15adIQawWe60rM8qe+f79iELdkYTzwjqCUhBXJpSgQ13BVyP518
uLMVFz1+ZwPDLeTHOABgTY+V7KDPiC3So5twDZg5A8yfpc5GRoeKhtfHBJfMh/qd
GmcjhyLxXcz9Z5wVnqlqS6hkUYkQpVK0u4c9VLyiRGMATp3ariruMTmZHw0OUB0L
1e+x+nwa8R5zr4SucvhE64f/7PGlKC+H/Yn20OO2q2sO9eAHdLquso6n0kUf8hjd
hnOMdm6waxly8Loytot1K3bQdrEOcnp0JzfkOna2uQRyoqhLQZNxNMtTnmu7/zru
Yytw1p6u431CI4y7DC1sSvoxsBvwt/IrwfDPcmCBJMMfVOk4nnRteYv2uNsjeJrV
2OVvF4GZVjnEK1R+qTeOKDKs4igzECKhrK9KSYAs8bFxWlJoLMPpdHZKJm9UMxnX
GWjBkVk+2PPDrrM2tUXm8/VZTMMPy27EGhV3wwpsIHF2e72gxr+F+YiVBY6FqIsu
8UoOeWcPeoaekjouTylh
=oO4y
-----END PGP SIGNATURE-----

--onwk0SivC/dtQkFp--
