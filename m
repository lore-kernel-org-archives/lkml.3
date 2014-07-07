Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaGGKHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:07:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:49008 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaGGKHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:07:54 -0400
Date: Mon, 7 Jul 2014 12:07:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, fengguang.wu@intel.com
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140707100745.GJ6758@twins.programming.kicks-ass.net>
References: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
 <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9BQka3UzQ3PAXYZM"
Content-Disposition: inline
In-Reply-To: <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9BQka3UzQ3PAXYZM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 10:30:56AM +0800, Yuyang Du wrote:
> The idea of per entity runnable load average (aggregated to cfs_rq and ta=
sk_group load)
> was proposed by Paul Turner, and it is still followed by this rewrite. Bu=
t this rewrite
> is made due to the following ends:
>=20
> (1). cfs_rq's load average (namely runnable_load_avg and blocked_load_avg=
) is updated
> incrementally by one entity at one time, which means the cfs_rq load aver=
age is only
> partially updated or asynchronous accross its entities (the entity in que=
stion is up
> to date and contributes to the cfs_rq, but all other entities are effecti=
vely lagging
> behind).
>=20
> (2). cfs_rq load average is different between top rq->cfs_rq and task_gro=
up's per CPU
> cfs_rqs in whether or not blocked_load_average contributes to the load.
>=20
> (3). How task_group's load is tracked is very confusing and complex.
>=20
> Therefore, this rewrite tackles these by:
>=20
> (1). Combine runnable and blocked load averages for cfs_rq. And track cfs=
_rq's load average
> as a whole (contributed by all runnabled and blocked entities on this cfs=
_rq).
>=20
> (2). Only track task load average. Do not track task_group's per CPU enti=
ty average, but
> track that entity's own cfs_rq's aggregated average.
>=20
> This rewrite resutls in significantly reduced codes and expected consiste=
ncy and clarity.
> Also, if draw the lines of previous cfs_rq runnable_load_avg and blocked_=
load_avg and the
> new rewritten load_avg, then compare those lines, you can see the new loa=
d_avg is much
> more continuous (no abrupt jumping ups and downs) and decayed/updated mor=
e quickly and
> synchronously.

This patch is too big.. and I can't figure out wth you've done. The
Changelog also doesn't seem to help much.

--9BQka3UzQ3PAXYZM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTunFxAAoJEHZH4aRLwOS6C6EP/35bvPe3pYRXGBkjLb3Kv+zV
49E+Et5dUQVeZkxnNBCGJUdmdVAa3MEtSTzoIHGnFaf08Jg7qJwK9ANQ5YAUvM28
dl0zYgF0k4fonjKoyE4uY3HEUU8SARkugjYuC39W7olxtWcGU0Htu1Bac3emAvF/
KjA6mKg5hT1j09gdhAcBiQbRxEfvdZUY9onBuUNVPUbzDMkGJEHlrictcmiMu9vj
wcu4n1cvxbh1rhtjlNUmlXWGrhYi/gHGAtsr8w8Mvy1uLLpyShGvGJwqiyCu5Z/9
JzTi3HAfPOviSptrLT89+PysbxGVihrQUCluV1dGCbQ/aBBoBR+ZByA1CwX53N+k
R4zAAFwcwKKC/zAgrkZpPglxXjiGLsQzKfttVnWUH/5P6a8ELN9zxp1hDhGHE28E
jxKkdTt+TMHUi7VOAok7bYjBJnFy3D7gN2H42aYpJU07xsCfj6H1xPIDuTwbykfO
vRbzIB0QQQ6fvgIPQYzQT4u6/Ejxz/y2PKX7EMYBIn+dBsTg+N3S3NYH78pabIBQ
ql62ORH5h86f1/Kwhd02zx+KvLFTlCyRDY/n32HBpRLrO+xVTdhIOPFEeohi85AB
t+ybJ7znINFAgYnj5M/CnYaABp0P4Gszf5eS7baKgJ78/rcHWXJBS632YM27h4fQ
ifBASfi+D7Lx0qZbbWyI
=tTGR
-----END PGP SIGNATURE-----

--9BQka3UzQ3PAXYZM--
