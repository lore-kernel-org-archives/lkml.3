Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbaHLHJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:09:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:38068 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaHLHJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:09:29 -0400
Date: Tue, 12 Aug 2014 09:09:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: Re: [PATCH] perf/x86/uncore: export basic memory events for IVT IMC
 PMU
Message-ID: <20140812070915.GM9918@twins.programming.kicks-ass.net>
References: <20140812060031.GA25239@quad>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XEzLdEi2UC3eDnpc"
Content-Disposition: inline
In-Reply-To: <20140812060031.GA25239@quad>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XEzLdEi2UC3eDnpc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2014 at 08:00:31AM +0200, Stephane Eranian wrote:
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/ker=
nel/cpu/perf_event_intel_uncore.c
> index cfc6f9d..800e087 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -1391,6 +1391,7 @@ static struct intel_uncore_type ivt_uncore_imc =3D {
>  	.fixed_ctr_bits	=3D 48,
>  	.fixed_ctr	=3D SNBEP_MC_CHy_PCI_PMON_FIXED_CTR,
>  	.fixed_ctl	=3D SNBEP_MC_CHy_PCI_PMON_FIXED_CTL,
> +	.event_descs	=3D snbep_uncore_imc_events,
>  	IVT_UNCORE_PCI_COMMON_INIT(),
>  };

I changed that to the below; seeing how I have the uncore splitup
patches.

Also, I'm very tempted to do a s/ivt/ivbep/ on that whole thing. We
really should not mix all these stupid names.

---
Subject: perf/x86/uncore: export basic memory events for IVT IMC PMU
=46rom: Stephane Eranian <eranian@google.com>
Date: Tue, 12 Aug 2014 08:00:31 +0200

This patch exposes two basic events for Ivytown IMC uncore PMU:

- cas_count_read: number of full-cache line reads to memory controller
- cas_count_write: number of full-cache line writes to memory controller

Those events use the same encoding as for SNB-EP, so reuse the same
event table. See specification in:

http://www.intel.com/content/dam/www/public/us/en/documents/manuals/xeon-e5=
-2600-v2-uncore-manual.pdf

By aggregating all the read and write events from all the memory controllers
of each processor socket, one can determine the total memory bandwidth util=
ization.

Cc: zheng.z.yan@intel.com
Cc: mingo@elte.hu
Cc: ak@linux.intel.com
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140812060031.GA25239@quad
---
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -1422,6 +1422,7 @@ static struct intel_uncore_type ivt_unco
 	.fixed_ctr_bits	=3D 48,
 	.fixed_ctr	=3D SNBEP_MC_CHy_PCI_PMON_FIXED_CTR,
 	.fixed_ctl	=3D SNBEP_MC_CHy_PCI_PMON_FIXED_CTL,
+	.event_descs	=3D snbep_uncore_imc_events,
 	IVT_UNCORE_PCI_COMMON_INIT(),
 };
=20

--XEzLdEi2UC3eDnpc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6b2bAAoJEHZH4aRLwOS67o4QAInyfvJYEE7/v6QeELTROHRJ
QAJ/x7LYlgH6RwBeC4XevCCeuSUw7MQ4S8+WWzxL2GrVvhT3/01H/sJc7fSHHbVb
J2h8RTj72sdqsoaI5zxFCVMGnYOOwnYcz/oarF94nl5/X6KIbssTbU6Hh+XoHF0O
qnUoeGoguA26PUyLeDrbVlCNcpWjbwa4+OQBuOUmfBYPFDWLbvHA0IZPdLeXbi53
294O7OmG0KVduFl0zyzn8UVsCOhW4+0svivKdrIBhODNYJU1bohuis7CQq7pKAEc
fOGCoqX9AVo7967Sk2sQXfq9GaTypFv1eqQPVyH4c5tkGcHhs079HZ10HhL+eGi5
lEk5ohdRL1gsg1f39ruo4KIaHiuG1GLZuYkON+EEtmOldVVKCph+yg3z8DklKmNE
6yq0dBoYaOmDyR/liL6NrmITs5zUtKj0DnDzYovTuxujKzpu6Mb3abmBgucBgNve
Ow33QAOFl4dquDf6qb+CZx3bpToWiK8JBsPrM0LjsOd5pfj/j6rw9eIYnOV1ZTZn
qH4x5PiFbtMSs+Fm4ke0OtOzqHj5kq8Zkf9gOOgQ9ltm+aEy51JQItfTC83cUtUw
fHg/MZX9/Xd44mQxLxdxXiqPi1K9ey7xrYwzzm1f80b591pVcdvWzD2Iz4rC3UBE
tDUa314r7kJDmwJwYr+G
=9CT1
-----END PGP SIGNATURE-----

--XEzLdEi2UC3eDnpc--
