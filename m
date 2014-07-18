Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaGRGnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 02:43:19 -0400
Received: from ozlabs.org ([103.22.144.67]:54643 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbaGRGnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 02:43:17 -0400
Message-ID: <1405665795.17297.5.camel@concordia>
Subject: Re: [PATCH 06/11] perf, tools: Automatically look for event file
 name for cpu
From: Michael Ellerman <mpe@ellerman.id.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        acme@infradead.org, Andi Kleen <ak@linux.intel.com>
Date: Fri, 18 Jul 2014 16:43:15 +1000
In-Reply-To: <1405123165-22666-7-git-send-email-andi@firstfloor.org>
References: <1405123165-22666-1-git-send-email-andi@firstfloor.org>
	 <1405123165-22666-7-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 16:59 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> When no JSON event file is specified automatically look
> for a suitable file in ~/.cache/pmu-events. A "perf download" can
> automatically add files there for the current CPUs.
... 

> diff --git a/tools/perf/arch/x86/util/header.c b/tools/perf/arch/x86/util/header.c
> index 146d12a..76e0ece 100644
> --- a/tools/perf/arch/x86/util/header.c
> +++ b/tools/perf/arch/x86/util/header.c
> @@ -57,3 +58,15 @@ get_cpuid(char *buffer, size_t sz)
>  	}
>  	return -1;
>  }
> +
> +int get_cpuid(char *buffer, size_t sz)
> +{
> +	return __get_cpuid(buffer, sz, "%s,%u,%u,%u$");
> +}
> +
> +char *get_cpu_str(void)
> +{
> +	char *buf = malloc(128);

I realise malloc failure is unlikely, but it's not impossible right?

Seems like it'd be cleaner if the caller allocated the buffer.

> +	__get_cpuid(buf, 128, "%s-%d-%X-core");
> +	return buf;
> +}

cheers


