Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaE1Pf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:35:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:43422 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaE1Pf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:35:56 -0400
Date: Wed, 28 May 2014 17:35:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, eranian@google.com
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140528153548.GY11096@twins.programming.kicks-ass.net>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
 <20140528081053.GP11096@twins.programming.kicks-ass.net>
 <20140528145831.GH29957@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QC2OnzLPmgM3Ncx9"
Content-Disposition: inline
In-Reply-To: <20140528145831.GH29957@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QC2OnzLPmgM3Ncx9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 07:58:31AM -0700, Andi Kleen wrote:
> > In particular, the 0x90 offset (IA32_PERF_GLOBAL_STATUS). Intel once
> > confirmed to me that that is a direct copy of the similarly named MSR at
> > the time of the PEBS assist.
>=20
> That is correct.
>=20
> >=20
> > This is a problem, since if multiple counters overflow multiple bits
> > will be set and its (afaict) ambiguous which event is for which counter.
>=20
> When a PEBS counter overflows it clears its respective GLOBAL_STATUS bit
> automatically.

That's an ambiguous statement; did you mean to say a PEBS enabled
counter will not raise its bit in GLOBAL_STATUS on counter overflow?

Because if it does raise it, but then clears it again, its raised for a
short while and might be observed.

Anyway, you've still not entirely explained the full life cycle of those
bits in excruciating detail, please do so now.

Also, try and get it included in the SDM.

> > So until you can give an official Intel answer on how all this demuxing
> > is supposed to work and be correct this patch set isn't moving anywhere.
>=20
> FWIW a patch signed off by intel.com is an official Intel statement.

Is that the reason they have such vague and non-committal Changelogs? Be
detailed and explicit.

On that same note; can someone shoot whoever writes the new SDM bits?
They're nearly impossible to comprehend, its like a patent lawyer was
involved with the end result of having a text explicitly engineered to
not be understood :-(

> > > To supply a TID it
> > > requires flushing on context switch. It can however supply the IP
> >=20
> > On SNB+, previous to SNB it would need to have precise=3D=3D1. I've see=
n no
> > such logic in. Instead you seem to artificially limit it to SNB+, for no
> > apparent reason to me.
>=20
> Only tested on Sandy Bridge+

That's just ... /me lacking words.. the worst reason possible for
arbitrary limits, esp. since you guys actually have the hardware to test
older chips.

--QC2OnzLPmgM3Ncx9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThgJUAAoJEHZH4aRLwOS61PgP/3Rl2WaSODPeeBXvsZFfimBV
4yXIf4BgdiPUJkH9y5uli4gJCGXFh/QFmDuHzi0+oLid7fvzeNDHwsAkQGpxdB1N
ic32TaK7UT/mmvD1ODMUOpPZVtPjCDpAVC8d8C7hwW93jV4ZkY+30mqnZFLYkEVL
dg3DnmvCLRsNiDL3/JbisAgRbCeJMOVuJ7a1vBWSLcdoQ/Gfz1/pLCIpsKUZHtbu
FqMhdqfG3SUP/20FFhf3L3BEIPmGBSyzSo4BwzjEaDhwFbOIDWkbE4vAtLTZqrKI
nh4UtYOc9Yium6UvP/tx0YOwfholaZsPWjtmscspC2d9aD3v10biNNMHnLKMJvu/
zWFQ4y2BYtlF8Cf2ynDAsFTaVbnWtpJ6MOUfwXqcNRhVRA/1d2KZwtugqY2D4W8w
wEaiMqdNRBSYIPWSzU8jVod7RxpZSIlx9WOIRQ/uIXu9qkxIC79KZ3NUHwAaCXnP
v0ZNCAjjdI6D8gTWy6pWpuTocoHoVLgVACuFyw+1TNkchsSj8uzx2KqfXr6Fe20a
IkmjVI2fY1Mw+gxsWkQxl06wNxF0Jm7MufeIB5gBS5Y4ivPFXUJ1uiMVdWFiglqx
9MU0f/RnJ8iwgZsua3yo9FWP78jb+/RdZ9z20G22l7WXB7cmi73vfjexH9FabEaJ
qjpuDfV2qG8MZEi+tXAd
=t1pQ
-----END PGP SIGNATURE-----

--QC2OnzLPmgM3Ncx9--
