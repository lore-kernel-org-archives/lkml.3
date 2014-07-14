Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbaGNMPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:15:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50731 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaGNMPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:15:38 -0400
Date: Mon, 14 Jul 2014 14:15:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Chen LinX <linx.z.chen@intel.com>
Cc: paulus@samba.org, mingo@redhat.com, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: Re: [PATCH] perf: Don't enable the perf_event without in
 PERF_ATTACH_CONTEXT status
Message-ID: <20140714121525.GX19379@twins.programming.kicks-ass.net>
References: <1404358598-19186-1-git-send-email-linx.z.chen@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="04bHF1C/QcYMF4Q7"
Content-Disposition: inline
In-Reply-To: <1404358598-19186-1-git-send-email-linx.z.chen@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--04bHF1C/QcYMF4Q7
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
> that without linked in context list again. when cpu offine the second tim=
e, the 'perf_cpu_notify'
> can't disable event on the pmu as the event doesn't link to context list.=
 the perf app may free
> this event later(the free procedure try to disable event on the pmu but a=
s the cpu is offline,
> the 'cpu_function_call(event->cpu, __perf_remove_from_context, event)' is=
 failed). then after
> cpu online again, pmu will access freed perf_event and hit panic.

What?

(also, teach your MUA to wrap text at 78 chars)

--04bHF1C/QcYMF4Q7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw8ndAAoJEHZH4aRLwOS6utoP+wch9djdWvd7w0LVdSDiCfXG
T1QTN4/6lyo/4ADb7o9Z15LLl+UVzXHSzU+q6sg1EOMh+d6jcUP04HK29zxHUxCX
js20lJvlNuOUpYMQ+XFMKkJDVvPjLDqZpMJJ4/giXj80TwhxkPYWwNbAhajfkuEt
LxzW+x5iCC/3lTHBqYvGriZyaIOjXdh94BpJ9KTgaVT5G+6YXZ7L87KzL0wf5NaF
KwZZjdUoovbBZi5zPIrmmx3/8BLWC1jp5QGHSgYCToVQTDOjCHYtKcrAE0Xy+scu
kdlA/2W5zTO4aOESSj3WOfQBxct6r59U6ScHgBl1oFQarw2FVOPyXwlte2gRO9J+
Rs6KjNQtOsdrd8l6vOQ/7KTLFA85GpeIXyFVUL4t9d81EFBZBRz55Nan6zusswHx
g82q16XPbVd65IMvVyWNEBpeP/kutRmSCOQGQt71KwoiAplynzKRXcGFdLyG8i+f
2cMu7DU0p4cxA6SQEtpAV1ML5s8gb0zuNGpc4CadHspe1k86vwjljsQ4KPNkhXf0
qsFEB5G6n0Pti10i/OcRVK/9/hRs6UvQvIGjXQyRlfElkL7d/ghug6BGLWEJ4jv0
fpnleWzge4t3WS6FNZ34xP6aWTEYaY4j54eQLiTqeJeYlppGZbB/ew7bnxkp75Pr
qakoVScUJXaJ5nBQxFmK
=anWb
-----END PGP SIGNATURE-----

--04bHF1C/QcYMF4Q7--
