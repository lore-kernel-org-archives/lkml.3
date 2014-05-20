Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaETN1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:27:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37834 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaETN11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:27:27 -0400
Date: Tue, 20 May 2014 15:27:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/3] perf: disable sampled events if no PMU interrupt
Message-ID: <20140520132712.GG11096@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1405161701160.11099@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405161708060.11099@vincent-weaver-1.umelst.maine.edu>
 <20140520091216.GS2485@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405200917060.18606@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3h+hNn3PVp185ISI"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405200917060.18606@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3h+hNn3PVp185ISI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 09:19:27AM -0400, Vince Weaver wrote:
> On Tue, 20 May 2014, Peter Zijlstra wrote:
>=20
> > > +#define PERF_PMU_NO_INTERRUPT		1
> >=20
> > Are you ok with me making that:
> >=20
> > #define PERF_PMU_CAP_NO_INTERRUPT		0x01
>=20
> sounds good.  All my recent fuzzing has made me paranoid enough to=20
> double check that yes indeed we don't need to slap an ULL on the end of=
=20
> that.

Thanks!

> Though I hope 32-bits is enough for this, I feel like we've just added th=
e=20
> feature and suddenly all kinds of uses are coming out of the woodwork.

If we run out of bits we can always grow this thing, its not exposed to
userspace so no A[BP]I issues.

--3h+hNn3PVp185ISI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTe1gwAAoJEHZH4aRLwOS6caoQAJHi7xEV9y6WqBUUArYhVJbT
xm34ra+Wl1BhhalARoG4wRMbx0Z/fQcpLCs5MYnjebgXCwxix0t13Gcjp5k5nhWj
8IKlakvPcb96rKNV3mZH1kiTHHZcCtxfG0BMDkPSaxqj1tDSR/Zllf2ViMHkvl8R
880QMhS2Ann25/wqZvTmjVvNHpMwJiH9IlNWGdA5rxPHMqCo54laIMbzrpUkFwTb
QjD0o91WVGxruy0ve7pSabga5ys3Quq7gjVDE5WhxhJ9XfMFsPUtQxp5QvjQpOLF
PHhVMoNX1YbSVDLD+GiJXedSR6dk1YT3Z+0DGF2/4TPHn8NheOGhNMI4WgWWe9VW
sNXKjzAf6Fyjq0gzBgFMm8dfRPBCnanSxWrRIBq8XWOaB7ZOMwuvX7oMBpgDoZkU
/1AoFtg0JCsNwRy3B0IUZlRMdUxUj+2wF6AVJWCZZp+arZVFyp/IjY+GFAzsicqq
+bOtgL5Tvx5ZmypDsFHrpT+N2IE6jvDcCdbnjXlp76iFxRNR4k3zIme79eHEqwW/
sFp15fVL0VWugId0hj99l2nGsQYpcafB48fL8nRw/81LDKHZVeDYnc7yhJnPQwth
rp49b4zXLPZra8BQGflzg6KHditx4Nw/6ZN50PFhcpDj63AniYt+e0GMl+Pro/YJ
3GZ/+nYHIJXd5ymnOAGb
=p2pb
-----END PGP SIGNATURE-----

--3h+hNn3PVp185ISI--
