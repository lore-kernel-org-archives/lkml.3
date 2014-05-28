Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaE1ILF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:11:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:41371 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaE1ILD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:11:03 -0400
Date: Wed, 28 May 2014 10:10:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140528081053.GP11096@twins.programming.kicks-ass.net>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jrD2fTATTFYrkNk2"
Content-Disposition: inline
In-Reply-To: <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jrD2fTATTFYrkNk2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 02:18:09PM +0800, Yan, Zheng wrote:
> PEBS always had the capability to log samples to its buffers without
> an interrupt. Traditionally perf has not used this but always set the
> PEBS threshold to one.
>=20
> For the common cases we still need to use the PMI because the PEBS
> hardware has various limitations. The biggest one is that it can not
> supply a callgraph. It also requires setting a fixed period, as the
> hardware does not support adaptive period. Another issue is that it
> cannot supply a time stamp and some other options.=20

So the reason I've never done this is because Intel has never fully
explained the demuxing of pebs events.

In particular, the 0x90 offset (IA32_PERF_GLOBAL_STATUS). Intel once
confirmed to me that that is a direct copy of the similarly named MSR at
the time of the PEBS assist.

This is a problem, since if multiple counters overflow multiple bits
will be set and its (afaict) ambiguous which event is for which counter.

At one point it was said they'd fix this 0x90 offset to indicate which
counter triggered the event, but I've never heard back if this happened.

So until you can give an official Intel answer on how all this demuxing
is supposed to work and be correct this patch set isn't moving anywhere.

> To supply a TID it
> requires flushing on context switch. It can however supply the IP

On SNB+, previous to SNB it would need to have precise=3D=3D1. I've seen no
such logic in. Instead you seem to artificially limit it to SNB+, for no
apparent reason to me.

--jrD2fTATTFYrkNk2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThZoMAAoJEHZH4aRLwOS6Ij8P/06W34TH8nlIKq1z7sGP4Mt5
2ni+rwMecbLWOkO5TjA4mfhuzdq80cBuCWNf15rLmnkc7yrwgooRHXSrb46+O3YV
L8c1XgM6Qhyu2Hqvd6LGlnh/gcGISNPZHEvd14dakjonymgmTa2ZfYBJUYvBl10M
jC6iikEoPkesz9dkWIjZ6Gyujm7BIO6SrNPtST/Gnxabu+TgaS+wiEVeSrH7lv2r
CrP205PFoB6YP8S6btcXBi+Dj0Z5VYo8jz/gbO+LKJsNw/1pzxEuH1PjqrmRA5vv
7ge0tJFJy29p2zdrew7ZrPpT2TXQA0kox08xY5abYnTHuoWDE+6mYecdaEViOlnR
/g5YDBmB/jUNoyCCzdkVasEbENdAD+ItzjmyNgbsKSDejR2wjNaTKcpurB9yjCDD
Igz1RKrXi1Dq/KhvSOvCK++rBFNWGHyFhVdYT0vT/t5VyJ3DpQfNTYjeHoahGTwY
xxklLnv7FIcyQLV9QcHJagftsg2QGmMGgMs+YFvWazz/B1fHDQ0lfSyzlAR/4W4m
VCDIeijXRpvoqi9EP7UpbdqKqnN7s1imuIhzRO46zTKxDGi2L6zplsWmxbTJ3LCA
1QewND+LRc0hzDTidb/dVT6eEC5aWwvAmummjf00WIldN71yN5E+U6/jCvDssynz
sLT1bNE61MzVL1ujmwkq
=dQjZ
-----END PGP SIGNATURE-----

--jrD2fTATTFYrkNk2--
