Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaHMIKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:10:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:43126 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaHMIKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:10:30 -0400
Date: Wed, 13 Aug 2014 10:10:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/3] perf, x86: Add INST_RETIRED.PREC_DIST workarounds
Message-ID: <20140813081017.GA9918@twins.programming.kicks-ass.net>
References: <1407894315-15928-1-git-send-email-andi@firstfloor.org>
 <1407894315-15928-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yLiyLTwUsq1iSSyX"
Content-Disposition: inline
In-Reply-To: <1407894315-15928-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yLiyLTwUsq1iSSyX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2014 at 06:45:15PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>=20
> On Broadwell INST_RETIRED.PREC_DIST cannot be used with any period
> that doesn't have the lowest 6 bits cleared. And the period
> should not be smaller than 128.
>=20
> Add a new callback to enforce this, and set it for Broadwell.
>=20
> This is erratum BDM57 and BDM11.

Urgh, this blows.

> +/*
> + * Broadwell:
> + * The INST_RETIRED.ALL period always needs to have lowest
> + * 6bits cleared (BDM57). It shall not use a period smaller
> + * than 100 (BDM11). We combine the two to enforce
> + * a min-period of 128.
> + */
> +static unsigned bdw_limit_period(struct perf_event *event, unsigned left)
> +{
> +	if ((event->hw.config & 0xffff) =3D=3D 0x1c0) {

ISTR we have actual proper defines for that.

> +		if (left < 128)
> +			left =3D 128;
> +		left &=3D ~0x3fu;
> +	}
> +	return left;
> +}

--yLiyLTwUsq1iSSyX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6x1pAAoJEHZH4aRLwOS6juQP/2zHdTJmlXbznqhJcFwf7JG7
4APmQpaGUoh7hthPYBiR4cMcwTbo4siht5B8p1WVBm2kxSQuC0La23cyNtw9oTtz
pt5WEu7PPyzQzEZH1ItsEE0SSD5DA485/QA9ZBqxnRzXYuodLKdlaCo/HADVXzd/
oy+4vrO3CVqwl5djGdhz9ISZZHgPhdT9Ep+kMG6jSOb2xtmUsxYhulqgp1upvq8Y
iUZjYE7HX6APnyeSEVeNlrbfdZ9qPq8ousownlayhomj6kY1+KR9wi7F0Cs/voDA
ePgfa05brkOPWml9LH0QJZL09a8ufruSBIuNPAM5vRc0z8atCQ0uKAA+qYeIBomm
+94PbRHQw5L1wS+0+EFM7TFr7MQiWSmvghTfchzeA30UwN1xhXd0vzR88bm6CQyt
CJwwMINTxFqlcGKnRVTAEBYSjKKyKFbD47T7FfNCIZUW9erUEU+x53+OGOzv3sxU
XuuFtKyhVGHIIHcMqZ+rVjWqCDdtoosS/dU2M20eTaQHmq7BxmnTsS3haIAVSDjO
MVf4kLPzzc7zpIDlmu8tGFIINZNFaIxHpHW6wkdK+1Q4ecwse4M00zEnSmdxnulp
/H0rv4p94D2k478Y49Ch0PBtStxQXPNRyOOKmykDqUzpSKQPUgQn1OivpZGQoujO
o7/MUugapWp08OAD0Vyj
=3Qjm
-----END PGP SIGNATURE-----

--yLiyLTwUsq1iSSyX--
