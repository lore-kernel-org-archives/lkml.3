Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3LQOPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:15:22 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:41682 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3LQOPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:15:20 -0500
Date: Tue, 17 Dec 2013 15:15:15 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        zheng.z.yan@intel.com, bp@alien8.de, vincent.weaver@maine.edu,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH 2/2] perf/x86: add RAPL PP1 energy counter support
Message-ID: <20131217141515.GA3364@gmail.com>
References: <1387225224-27799-1-git-send-email-eranian@google.com>
 <1387225224-27799-3-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387225224-27799-3-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> Add support for the RAPL energy counter PP1.
> 
> On client processors, it usually correspondss to the
> energy consumption of the builtin graphic card.
> 
> New event:
> - name: power/energy-gfx/
> - code: event=0x4
> - unit: 2^-32 Joules
> 
> On processors without graphics, this should count 0.
> The patch only enables this event on client processors.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> ---
>  arch/x86/kernel/cpu/perf_event_intel_rapl.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_rapl.c b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
> index 0e3754e..b2dc346 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_rapl.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_rapl.c
> @@ -55,10 +55,13 @@
>  #define INTEL_RAPL_PKG		0x2	/* pseudo-encoding */
>  #define RAPL_IDX_RAM_NRG_STAT	2	/* DRAM */
>  #define INTEL_RAPL_RAM		0x3	/* pseudo-encoding */
> +#define RAPL_IDX_PP1_NRG_STAT	3	/* DRAM */
> +#define INTEL_RAPL_PP1		0x4	/* pseudo-encoding */

Another problem I noticed is that there's a pretty good description at 
the top of perf_event_intel_rapl.c, but it does not get updated with 
this new pp1/gfx/gpu angle.

Thanks,

	Ingo
