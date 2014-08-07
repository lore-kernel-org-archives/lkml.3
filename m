Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbaHGIon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:44:43 -0400
Received: from sym2.noone.org ([178.63.92.236]:53852 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbaHGIok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:44:40 -0400
Date: Thu, 7 Aug 2014 10:44:37 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: jolsa@redhat.com, andi@firstfloor.org,
        Michael Ellerman <mpe@ellerman.id.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/perf: Implement get_cpu_str()
Message-ID: <20140807084436.GB29832@distanz.ch>
References: <20140806001754.GA28735@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806001754.GA28735@us.ibm.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-06 at 02:17:55 +0200, Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> wrote:
> powerpc/perf: Implement get_cpu_str()
> 
> With a file like ~/.cache/pmu-events/004d0100-core.json describing
> Power8 PMU events, we would need to run:
> 
> 	perf stat \
> 		--events-file ~/.cache/pmu-events/004d0100-core.json \
> 		-e PM_CYC sleep 1
> 
> With this get_cpu_str(), on Powerpc, we can skip the --events-file option
> and run:
> 
> 	perf stat -e PM_CYC sleep 1
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
> Note: This patch is based on Andi Kleen's recent patchset
> 
> 	https://lkml.org/lkml/2014/7/30/693
> 
> Changelog[v2]:
> 	[Michael Ellerman]: Use PVR instead of AUXV variables
> 
>  tools/perf/arch/powerpc/util/header.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
> index 6c1b8a7..1bb400e8 100644
> --- a/tools/perf/arch/powerpc/util/header.c
> +++ b/tools/perf/arch/powerpc/util/header.c
> @@ -6,6 +6,7 @@
>  
>  #include "../../util/header.h"
>  #include "../../util/util.h"
> +#include "../../util/jevents.h"
>  
>  #define mfspr(rn)       ({unsigned long rval; \
>  			 asm volatile("mfspr %0," __stringify(rn) \
> @@ -32,3 +33,14 @@ get_cpuid(char *buffer, size_t sz)
>  	}
>  	return -1;
>  }
> +
> +char *
> +get_cpu_str(void)
> +{
> Changelog[v2]:
> 	[Michael Ellerman]: Use PVR instead of AUXV variables

This was probably not intended to be here and the patch does not apply
due to these lines.

> 
> +        char *bufp;
> +
> +        if (asprintf(&bufp, "%.8lx-core", mfspr(SPRN_PVR)) < 0)
> +		bufp = NULL;
> +
> +        return bufp;
> +}
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
