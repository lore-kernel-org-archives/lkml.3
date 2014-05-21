Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751023AbaEUGi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 02:38:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55095 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaEUGi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 02:38:56 -0400
Date: Wed, 21 May 2014 08:38:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>, Russ Anderson <rja@sgi.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Reduce the rate of needless idle load balancing
Message-ID: <20140521063826.GC30445@twins.programming.kicks-ass.net>
References: <1400617046.2970.270.camel@schen9-DESK>
 <CAGQ1y=5cwk+-Ztv8kXod+QexwEqQ0U6wPdMDBLL66rcF_cukLA@mail.gmail.com>
 <1400619550.2970.274.camel@schen9-DESK>
 <CAGQ1y=4z69iNRAM8eZFhh=kjRYQgwDxyMjyNG4XJ0b1xOxLURA@mail.gmail.com>
 <1400621967.2970.280.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3TG/ZNIaOacldBdr"
Content-Disposition: inline
In-Reply-To: <1400621967.2970.280.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3TG/ZNIaOacldBdr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 02:39:27PM -0700, Tim Chen wrote:
> From: Tim Chen <tim.c.chen@linux.intel.com>
> Subject: [PATCH v2] sched: Reduce the rate of needless idle load balancing
>=20
>=20
> The current no_hz idle load balancer do load balancing for *all* idle cpu=
s,
> even though the time due to load balance for a particular
> idle cpu could be still a while in the future.  This introduces a much
> higher load balancing rate than what is necessary.  The patch
> changes the behavior by only doing idle load balancing on
> behalf of an idle cpu only when it is due for load balancing.
>=20
> On SGI's systems with over 3000 cores, the cpu responsible for idle balan=
cing
> got overwhelmed with idle balancing, and introduces a lot of OS noise
> to workloads.  This patch fixes the issue.
>=20
> Acked-by: Russ Anderson <rja@sgi.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: Jason Low <jason.low2@hp.com>
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---

Thanks!

--3TG/ZNIaOacldBdr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfEnWAAoJEHZH4aRLwOS6U6YP/0Z1BnU6ie+CSJ4s8Nj8Cbbp
dAcUkbN4zHArzFzu9Nu0MNrt3JfNFESQIQHvbHV9yE6aFxbPqXd0csU6svl3I/8b
XZRcSWcz0qM92GCbEU2iIgVMjqpky6cG7bKEcCQJQVaYUh4nOX6PmlTrmb7necC2
hdcAv1yMiFlbQLJ0DsdYvO4g3ow/ncnd7oj0x4PG6o/U84aiR7wLMJO4Mbxo1Wvu
FZt6jdZKylPSDeeArcOh9GnGTK6JZL1S9DmNUJO9dCsUY92UVyMy6ai2T2LWNqCk
9Zgi/ShbBH3ApJ71gKM3V7rG10uNiS7Ovy0eyrZnBViR2TdRyolieywSn6uYzhnd
RjTgIy28jQHKjScvIzzGd0cJLJLoAAhu+m3f+wejEFbtfkfYrtfzCagHuGNiyGWC
oPwTgB+MasMMJKF2qVznCW6++PUEbeRVPLyltECVlOkvvIqkQ4fw2odyEa4hRZpz
4RMj17O9MPZ7G4i4NPdiKOxjoVi5OyNG/hzV1dTKhAZ2nga72JFCFWLhQXI/6VSl
bgDnPQIRtI2BwfI1meXQmyIYwc//46tZQYTwh3/KZK3HkOEdFYsepuiD/fAdk1K8
P5yo6cmN88q3m7jP1pqk/KBfCPSkkabecBly15PFgybavs4R+LyIpvnXVf/cNig3
l1i+QXPLgvxetx6gFzU1
=GWnI
-----END PGP SIGNATURE-----

--3TG/ZNIaOacldBdr--
