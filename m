Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaGBKOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:14:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:59863 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaGBKOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:14:39 -0400
Date: Wed, 2 Jul 2014 12:14:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 04/16] perf, x86: Basic Haswell LBR call stack support
Message-ID: <20140702101430.GW6758@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
 <1404118253-19532-5-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aIZgg+C+Ywwbs/9X"
Content-Disposition: inline
In-Reply-To: <1404118253-19532-5-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aIZgg+C+Ywwbs/9X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 04:50:41PM +0800, Yan, Zheng wrote:
> @@ -438,8 +451,11 @@ static int intel_pmu_setup_hw_lbr_filter(struct perf=
_event *event)
>  	reg =3D &event->hw.branch_reg;
>  	reg->idx =3D EXTRA_REG_LBR;
> =20
> -	/* LBR_SELECT operates in suppress mode so invert mask */
> -	reg->config =3D ~mask & x86_pmu.lbr_sel_mask;
> +	/*
> +	 * the first 8 bits (LBR_SEL_MASK) in LBR_SELECT operates
> +	 * in suppress mode so invert mask
> +	 */
> +	reg->config =3D mask ^ x86_pmu.lbr_sel_mask;

Where the comment made sense with the old code; it doesn't really with
the new..

--aIZgg+C+Ywwbs/9X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTs9uGAAoJEHZH4aRLwOS6zkkQAKJ5kiTXLJMlMOtdHyOqAGPO
eh7FuQpRf65UvnMZLNCYsIVco3BCPqQWunBmqSjeO69klQ3diOfYBxuhEuSey/dd
IFjM0r89ZTA0xYnmSz1P+YynjIB9mHnO8z8ceQifGmsoWEd5kkv2zjNLIzS4Jdeu
TuuBLA+bJZd9MDITCkDuJ71elITXWk/TmNPKPfjGVPjAfgG43L2ZIgQt78pT6PJM
D5bXo+6COEJtfl7sGnW5ZdMNMxnfAoJLbDSsyj/QMp5EkEKI5AnRXLA4E43tXJ5v
PWPqD7HwjToj+w6FteotUnY7jO4XxhSBsnUwMb+alcA69yo/VgP3kmAmPAAelngo
QlxovnPUdygBmMn7GJcfvCq/Jl7ZAfallmQEV/2UsT7gkjI6jhZKzIVdjeweoTPT
58FlP0cP5sFIs8jXBrYawcanrDQuF0/zLVeDI6eESr/swIGsSgzLRDK5MAItzd3V
nGr9n8KXHUSA3ntq+cZotC9EkAS3g+5YBPChy9qlQs1OlDiXUng7wI/jfIKlV9/e
ko7ymMN9NOUeuRqxTswHnxToRoa4tKuX9BMP0PC/rR0XeQSMHtAqrXHm7r/jAfTv
SBp+mhWFPf6S7jvtgtwNH9SHJZt4pDg0tGHcgWG8rs/665B0LAXT8+qid6z/2hGk
65CnF5ngZbVV3h1bE9Af
=/QNN
-----END PGP SIGNATURE-----

--aIZgg+C+Ywwbs/9X--
