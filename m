Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbaGOLkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:40:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43580 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493AbaGOLkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:40:07 -0400
Date: Tue, 15 Jul 2014 13:39:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v2 1/7] perf, core: introduce pmu context switch callback
Message-ID: <20140715113957.GD9918@twins.programming.kicks-ass.net>
References: <1405414739-31455-1-git-send-email-zheng.z.yan@intel.com>
 <1405414739-31455-2-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OxpcHoRZqvs6WvX3"
Content-Disposition: inline
In-Reply-To: <1405414739-31455-2-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OxpcHoRZqvs6WvX3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 15, 2014 at 04:58:53PM +0800, Yan, Zheng wrote:
> +void perf_sched_cb_disable(struct pmu *pmu)
> +{
> +	this_cpu_dec(perf_sched_cb_usages);
> +}
> +
> +void perf_sched_cb_enable(struct pmu *pmu)
> +{
> +	this_cpu_inc(perf_sched_cb_usages);
> +}

Still wrong names, they do not enable/disable. Enable/disable is a
strictly boolean thing, this is counting.

--OxpcHoRZqvs6WvX3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxRMNAAoJEHZH4aRLwOS6++EP/jNrSNvkR24ojpne5AuDDmVT
1u74qSZ6s6O30vU1B+gLGjtfzf5yr1s8FxzQlKwYYO8hfvkJvpy1sAedq6gUb6CO
dHmfVeOdaLoQB2SpScDdAw094xBwFOYUPUWviUW8TSL6stnFe6jm2COSDe7tEQLv
uwY+pjOkULK5f25YyDJZLiVuSTyN48A37iWRjnEwpBVWepU5hzpdb5HA+qHtQRAe
Ajr/llXyLOJMUOY6BbRVfCrdqqqtu2ooxSao9u7Aw1bwDWflNrpd8xsyT7J9LKi1
GHdkw9F6K/HUR+1CD8jtaPVeDtMU8/VdiBHQEBqvuSZAFGtLN0F5GRZHVU4WyrYT
yBKH4P2Qe2Jl3YXvg4jbpWeWru9nE+C6cPknERBvG14F4OYMBvPCB3WX7cfSssAk
ILYe/99FvaI5J0yrPqiPPHSvEuaQoQN2bj+bpEGbayvqdtcLJ1TM7PYV24IRPLxu
czdXjrfhhQtqdT8AjORcb+iSeSz/ZzgrbNi8PlGVAywsTsDoMwAptQFwY8xVyKAO
+r5xLqXu4WxuSsR6M+GWnZRiJqYT0Sq/kc1sFilE0AFsZ8A4ao26f6QTerllb/B0
qLra0dkgnkOh2pA9gjCbwM85qoGWt5gdPKJNcqSSUaEc0cSucSfR9aKgs1OG2iHX
JlP+u04qP9VuQy+C54qJ
=DTnn
-----END PGP SIGNATURE-----

--OxpcHoRZqvs6WvX3--
