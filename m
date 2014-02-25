Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaBYDeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:34:20 -0500
Received: from ozlabs.org ([203.10.76.45]:52051 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbaBYDda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:33:30 -0500
In-Reply-To: <1392415338-16288-11-git-send-email-cody@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Lijun Pan <Lijun.Pan@freescale.com>, Li Yang <leoli@freescale.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Priyanka Jain <Priyanka.Jain@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        Tang Yuantian <yuantian.tang@freescale.com>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 10/11] powerpc/perf: add kconfig option for hypervisor provided counters
Message-Id: <20140225033330.54F332C02FB@ozlabs.org>
Date: Tue, 25 Feb 2014 14:33:30 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-14-02 at 22:02:14 UTC, Cody P Schafer wrote:
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  arch/powerpc/perf/Makefile             | 2 ++
>  arch/powerpc/platforms/Kconfig.cputype | 6 ++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/powerpc/perf/Makefile b/arch/powerpc/perf/Makefile
> index 60d71ee..f9c083a 100644
> --- a/arch/powerpc/perf/Makefile
> +++ b/arch/powerpc/perf/Makefile
> @@ -11,5 +11,7 @@ obj32-$(CONFIG_PPC_PERF_CTRS)	+= mpc7450-pmu.o
>  obj-$(CONFIG_FSL_EMB_PERF_EVENT) += core-fsl-emb.o
>  obj-$(CONFIG_FSL_EMB_PERF_EVENT_E500) += e500-pmu.o e6500-pmu.o
>  
> +obj-$(CONFIG_HV_PERF_CTRS) += hv-24x7.o hv-gpci.o hv-common.o
> +
>  obj-$(CONFIG_PPC64)		+= $(obj64-y)
>  obj-$(CONFIG_PPC32)		+= $(obj32-y)
> diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
> index 434fda3..dcc67cd 100644
> --- a/arch/powerpc/platforms/Kconfig.cputype
> +++ b/arch/powerpc/platforms/Kconfig.cputype
> @@ -364,6 +364,12 @@ config PPC_PERF_CTRS
>         help
>           This enables the powerpc-specific perf_event back-end.
>  
> +config HV_PERF_CTRS
> +       def_bool y

This was bool, why did you change it?

> +       depends on PERF_EVENTS && PPC_HAVE_PMU_SUPPORT

Should be:

	depends on PERF_EVENTS && PPC_PSERIES

> +       help
> +         Enable access to perf counters provided by the hypervisor
> +

cheers
