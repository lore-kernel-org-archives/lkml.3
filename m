Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaEFLjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:39:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:60383 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaEFLjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:39:41 -0400
Date: Tue, 6 May 2014 13:39:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti Murthy <preeti.lkml@gmail.com>
Cc: Alex Shi <alex.shi@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>, mingo@redhat.com,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mike Galbraith <efault@gmx.de>, wangyun@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [RESEND PATCH V5 0/8] remove cpu_load idx
Message-ID: <20140506113936.GF11096@twins.programming.kicks-ass.net>
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
 <20140424162029.GV11096@twins.programming.kicks-ass.net>
 <5361982F.3080307@linaro.org>
 <CAM4v1pPH54OHehb1i-esXTMsGJ-n7ck3V8yDK_rwajVCSmdU1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GOzekVbrLdOLv44p"
Content-Disposition: inline
In-Reply-To: <CAM4v1pPH54OHehb1i-esXTMsGJ-n7ck3V8yDK_rwajVCSmdU1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GOzekVbrLdOLv44p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2014 at 03:24:13PM +0530, Preeti Murthy wrote:
> Hi Morten, Peter, Alex,
>=20
> In a similar context, I noticed that /proc/loadavg makes use of
> avenrun[] array which keeps track of the history of the global
> load average. This however makes use of the sum of
> nr_running + nr_uninterruptible per cpu. Why are we not
> using the cpu_load[] array here which also keeps track
> of the history of per-cpu load and then return a sum of it?

Entirely different kind of 'load'. Note that you cannot use
->nr_uninterruptible per-cpu, also note that sched/proc.c doesn't.

> Using nr_running to show the global load average would
> be misleading when entire load balancing is being done on the
> basis of the history of cfs_rq->runnable_load_avg/cpu_load[]
> right? IOW, to the best of my understanding we do not use
> nr_running anywhere to directly determine cpu load in the kernel.
>=20
> My idea was that the global/per_cpu load that we reflect via
> proc/sys interfaces must be consistent. I haven't really
> looked at what /proc/schedstat, /proc/stat, top are all reading
> from. But /proc/loadavg is reading out global nr_running +
> waiting tasks when this will not give us the accurate picture
> of the system load especially when there are many short running
> tasks.

Nobody said /proc/loadavg is a sane number, but its what it is and since
its a global number its entirely unsuited for balancing -- not to
mention all other reasons its crap.


--GOzekVbrLdOLv44p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTaMn4AAoJEHZH4aRLwOS6IggQALTHPierWIa8QMb1r7ueR1vP
zu1CLac46zmF/L/mX5w1DxVQ28NCuXKaCGL9hGOTumMIcFodKEw2W4wKNGs3mtlL
SFSFsIBFPoXBF4eeJ2+IcbTadHoS5TIfIGLpZSVrYLl3O9eNfi4irzKyRZ2PBamc
hzjKkZkxK78DwXinumU+EMByNfgTBx7CcHsCluQrxGJ+Dv9HQiuDoAYS4XM0ict2
lc/F6R+A/OMys5yRxlW3Y7gW+ICm9IEvBbygbwvtRA8368RRypkN1Air15OLtuLz
f0StjD+1CRQfduzVmAa85bO/wEZqs42MhUO9LR5FjJrAUtfW/nQCOS72M/llK+V4
XiSK7JsXQ9+reUb1dUwhsp/W5q+Og99gURH+M4TePrXka2I50X8q1D2mSPvatMlR
v9OOiB2RNqof4yV9lkAwzvi90tXHUkmAJlsqgBV4JmG55Jr1cX/B9xkSK2yjb7sH
W3dVcj/QPHj8KUA5BK4r2KEO3d0LXRRd7d4sHmFi4TbaVJ9WSSeYzc8xBu0+R16u
GFmSGxXD2wpRAAczLXyKvzDjB198+ShJEzZ3oJ8CtL3nYytDBQYW0MSEzBjDZXOQ
uYve4rpikH4BOwJJe0Yp4iLtd+lTCjv3a69LEdZwL3EUAPlSsSrr8lyMgrdMCEIu
sn17AR+f2SOEw4Ze2LDs
=4lQx
-----END PGP SIGNATURE-----

--GOzekVbrLdOLv44p--
