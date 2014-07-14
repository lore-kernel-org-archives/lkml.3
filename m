Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbaGNN2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:28:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:52077 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbaGNN2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:28:08 -0400
Date: Mon, 14 Jul 2014 15:27:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Chen LinX <linx.z.chen@intel.com>
Cc: paulus@samba.org, mingo@redhat.com, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: Re: [PATCH] perf: Don't enable the perf_event without in
 PERF_ATTACH_CONTEXT status
Message-ID: <20140714132756.GY19379@twins.programming.kicks-ass.net>
References: <1404358598-19186-1-git-send-email-linx.z.chen@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QLoLgODBTVlZARKX"
Content-Disposition: inline
In-Reply-To: <1404358598-19186-1-git-send-email-linx.z.chen@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QLoLgODBTVlZARKX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 11:36:38AM +0800, Chen LinX wrote:
> From: "Chen LinX" <linx.z.chen@intel.com>
>=20
> when do cpu hotplug test and run below perf test together, pmu may access=
 freed perf_event
>=20
> while true;
> do
> perf record -a -g -f sleep 10
> rm perf.*
> done
>=20
> the scenario is that when cpu offline firstly, the 'perf_cpu_notify' will=
 disable event on the
> pmu and remove it from the context list. after cpu online, the perf app m=
ay enable the event

But it does not, right?

> that without linked in context list again. when cpu offine the second tim=
e, the 'perf_cpu_notify'
> can't disable event on the pmu as the event doesn't link to context list.=
 the perf app may free
> this event later(the free procedure try to disable event on the pmu but a=
s the cpu is offline,
> the 'cpu_function_call(event->cpu, __perf_remove_from_context, event)' is=
 failed)

Failed how, below is __perf_install_in_context.

> . then after
> cpu online again, pmu will access freed perf_event and hit panic.
>=20
> so adding PERF_ATTACH_CONTEXT flag check before enable event to avoid thi=
s scenario.

In fact it does not. If you look at perf_event_enable() there's a code
path that doesn't call __perf_event_enable().

> [  157.670138 ]  [<ffffffff8216321f>] __perf_install_in_context+0xff/0x170

And yet, __perf_install_in_context isn't mentioned at all in the above.

> Change-Id: I7265d83159b9180e9be3a370ba50e067385547bd
> Signed-off-by: Yanmin Zhang <yanmin.zhang@intel.com>
> Signed-off-by: Chen LinX <linx.z.chen@intel.com>

Wrong SoB-chain, Yanmin didn't author this patch did he, seeing how From
is you. And Yanmin didn't actually send me this patch either.

--QLoLgODBTVlZARKX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw9rcAAoJEHZH4aRLwOS6KNAP+gKScmUwGGqK5k6PHULLamxQ
uL+v++mZsvqNnkKjkP73ShNaYkEYZdRAwGgIH4vINh39Y8VyUjd9iAXsjxMCy+BT
2+/rN6EBMh1+YBiJDsIuowCEuodYkO6n1kPmB4bVgSZnMX11JNAMameG4gpxafgy
rCKsYUB4u5bbOsh2ry13/rjsvzJByj/RCzy1aymt27jvSw7rbBRNygPAmTSE1Odj
pEqocw9E7UeH2AMvGsTfaCHQItuF9tZk6WiXx10G3Gy8jZj5wYdblRU+wj2hxA98
DRtbUHkYcZ91s+Vb4mf01ZZFY0pH+3Whr+GsL7QD/wPx93OOx18qAzwDI1dKuN6i
45ut3X6XBFjLq+I3iSPRSxXIhOU6VaGRv/A1vOHr5HTNHSdAdVrL9H3305kMoor6
Q/VAPonrW/bHUHnAVu364NIrNg6meAtFOfqfDJH2SmSLN83M1M4Bv+QOOnmNVcq5
fLM8XRhwoFwHOujCA1gphgthQAEcS+vMPMqv37Q2jHAwSOhxWNkUUY7NEO6dImEY
yKWwnpHlaM6bHS4fUCJHi2D2cd4gmiGaz2ar0J93fNugVK4sU9KQkOIdJVx4Il5k
M5kL7vft7bQnsl2O7Pzu69nwR38aXGiXsTV6xS5aSN7dCmLU7EV9OefPUy5zUvr6
PtODs8OMoO9kKF/cLKBB
=dhjU
-----END PGP SIGNATURE-----

--QLoLgODBTVlZARKX--
