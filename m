Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaGBKM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:12:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51922 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaGBKM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:12:28 -0400
Date: Wed, 2 Jul 2014 12:12:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 02/16] perf, core: introduce pmu context switch
 callback
Message-ID: <20140702101216.GV6758@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
 <1404118253-19532-3-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A40sgxQLUpGaial+"
Content-Disposition: inline
In-Reply-To: <1404118253-19532-3-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A40sgxQLUpGaial+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 04:50:39PM +0800, Yan, Zheng wrote:
> @@ -2362,6 +2363,58 @@ unlock:
>  	}
>  }
> =20
> +void perf_sched_cb_disable(struct pmu *pmu)
> +{
> +	__get_cpu_var(perf_sched_cb_usages)--;
> +}
> +
> +void perf_sched_cb_enable(struct pmu *pmu)
> +{
> +	__get_cpu_var(perf_sched_cb_usages)++;
> +}

Those should not be called {dis,en}able, they don't as such do that.
Also we have: this_cpu_{inc,dec} for this.

--A40sgxQLUpGaial+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTs9sAAAoJEHZH4aRLwOS6Y2AP/3B35xCdcTJCrCbsUaJ0yGPu
iz5NPbALEko0PnlFmIxROT3vmzdMxk1E/ggET8aOT2sFJr5vAGhKNzAGr3spsqQV
nMQOwOm+Kz4tvbbglR7KzxV+f5SjQEqOkd5PsPdjGnysaMnLfxG+ZgyQzX/RXUaT
JsM14rvsccN4n3uCBRW5ouKwNuwC2aw14+E9r/mZWHZFp5YMmKrkIQsKpyVBAyKy
bpN4XMBwcEadHJQOKCMlMAPZXfzOVHej9wGPhQTtrzNArQocHNTedPvKXkIEihCh
IlrbHhGRGOyVV+yRCkj9EmY3KnJ8PgzRXYDI9Ad2o/d5x+HJfYbrd7nwAPz2jI/3
ebss4gsdZiLzRDLBKOzx6NM6FNexZdDr4dv9+v6gXWWhg+Y5U1eRRnYZOD8qrZJn
8FSjx+laE36TpV02xZ/5dVZoB61r/Jg1WvPtB4Kpmj3e9zr2CvJ3diWdqMFirdvx
2Q0Wlz76lQgHdRNiNtAfAOzkuAuXt0zbvTtwwbAnHw23EcVg3yl4CXKQvVMTN2Hn
FysXuS52FmckC/SwFGAP9fyVRebZhxplGDXjw9YUOIWorIuR/MVtLJ/WJyj4giYP
AHn8WtZxcsNQSQlRz/1ICaT0Ww/OIofTJKf+Hl/plZM3VNfDaTqVHUK/RJSMExLA
iT1prxr02q3mko7DTbiS
=LAFw
-----END PGP SIGNATURE-----

--A40sgxQLUpGaial+--
