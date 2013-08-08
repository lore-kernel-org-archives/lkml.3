Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774Ab3HHCZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:25:12 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:55895 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933558Ab3HHCZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:25:10 -0400
Date: Wed, 7 Aug 2013 22:31:28 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Will Deacon <will.deacon@arm.com>, Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "trinity@vger.kernel.org" <trinity@vger.kernel.org>
Subject: Re: perf,arm -- another (different) fuzzer oops
In-Reply-To: <5202D5B0.9020107@codeaurora.org>
Message-ID: <alpine.DEB.2.10.1308072227060.16962@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1308071611290.14098@vincent-weaver-1.um.maine.edu> <20130807223129.GA17118@mudshark.cambridge.arm.com> <5202D5B0.9020107@codeaurora.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013, Stephen Boyd wrote:

> ---8<----
> 
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index d9f5cd4..21f7790 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -53,7 +53,12 @@ armpmu_map_cache_event(const unsigned (*cache_map)
>  static int
>  armpmu_map_hw_event(const unsigned (*event_map)[PERF_COUNT_HW_MAX], u64 config)
>  {
> -       int mapping = (*event_map)[config];
> +       int mapping;
> +
> +       if (config >= PERF_COUNT_HW_MAX)
> +               return -ENOENT;
> +
> +       mapping = (*event_map)[config];
>         return mapping == HW_OP_UNSUPPORTED ? -ENOENT : mapping;
>  }

I've tested this patch and my testcase no longer causes the kernel to 
oops, so 

Tested-by: Vince Weaver <vincent.weaver@maine.edu>

Thanks,

Vince
