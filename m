Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaHMI5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:57:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43590 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHMI5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:57:51 -0400
Date: Wed, 13 Aug 2014 10:57:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH] perf/x86/uncore: modularize Intel uncore driver
Message-ID: <20140813085735.GE9918@twins.programming.kicks-ass.net>
References: <1407919754-10421-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+O5NQwgs0eeb9wf2"
Content-Disposition: inline
In-Reply-To: <1407919754-10421-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+O5NQwgs0eeb9wf2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 04:49:14PM +0800, Yan, Zheng wrote:
> This patch adds support for building Intel uncore driver as module.
> It adds clean-up code and config option for the Intel uncore driver.
>=20
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/Makefile                  |  6 ++--
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 48 +++++++++++++++++++++=
+++---
>  init/Kconfig                                  | 15 +++++++++
>  3 files changed, 63 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index 7e1fd4e..2ef37fb 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -36,9 +36,11 @@ obj-$(CONFIG_CPU_SUP_AMD)		+=3D perf_event_amd_iommu.o
>  endif
>  obj-$(CONFIG_CPU_SUP_INTEL)		+=3D perf_event_p6.o perf_event_knc.o perf_=
event_p4.o
>  obj-$(CONFIG_CPU_SUP_INTEL)		+=3D perf_event_intel_lbr.o perf_event_inte=
l_ds.o perf_event_intel.o
> -obj-$(CONFIG_CPU_SUP_INTEL)		+=3D perf_event_intel_uncore.o perf_event_i=
ntel_uncore_snb.o
> -obj-$(CONFIG_CPU_SUP_INTEL)		+=3D perf_event_intel_uncore_snbep.o perf_e=
vent_intel_uncore_nhmex.o
>  obj-$(CONFIG_CPU_SUP_INTEL)		+=3D perf_event_intel_rapl.o
> +
> +obj-$(CONFIG_PERF_X86_INTEL_UNCORE)	+=3D perf_x86_intel_uncore.o
> +perf_x86_intel_uncore-y			+=3D perf_event_intel_uncore.o perf_event_inte=
l_uncore_snb.o
> +perf_x86_intel_uncore-y			+=3D perf_event_intel_uncore_snbep.o perf_even=
t_intel_uncore_nhmex.o
>  endif

Does it make sense to split it into 3 (or maybe 4) modules?

--+O5NQwgs0eeb9wf2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6yh/AAoJEHZH4aRLwOS6PDMP/34s7eqgI4tPqBWryWow/qeM
nMaXxwZNAMy7+GAHIwEYOFCOlxUPg6uG3n71YhTievj7Luqbv88XrI/sYOCeYbu0
k+mnpAXkFSHNoQirPtxy+cs0Pucv4Bngt+SXrfqdUUWZh7IlfyQl8rGRrqrc/sng
VZ/KW5bgfBBWrhn/adIf64ToZgvac6mPvzfJV2JMfbiNx4HlO0dnbxlQMg+sFo4z
nVF7jP3MvI71wc4/5a/KqEdX7Mv+sFd0v0FGjLAPf31GbeJn9+Ebv9hHKu6phJS8
W0EbVehr39XQQelyQ2kIUweK+juONHdfu3iTUVU20IegbTWqQZtABJHTjhxQGj1T
ci3fM1ZHxeQvDV0efJNYo1FPJYMmYjBlKTr0oSoXZVLvJNUmCyBJd4Vkcn4IqyN0
UEEoYyq5K51psHKJvadxAFYXlccAQN7z46FJ48IJ9iY+0C+Vw5Tn6XAng5dMxrH+
dZicVnP9rvw6+x6pSuvmifo0x+SOuNcPyNTKD/7n9X1fsmWrW4zwjPdLSRJ3eEqb
6KDOO2XPNaGAGMCHON5lPpSnQz4H8V7GLLAulDoQ4vYiLINblWCJ8JDDXUqryjKg
P9qKceJO1F0tQz4qozgjVKVDZG73gAcEWad3i46sFZ3jAjytdcWS9IsgQYYzlQ/d
ZHO2PnFANEfxtMi44n05
=1sWv
-----END PGP SIGNATURE-----

--+O5NQwgs0eeb9wf2--
