Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaAILFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:05:20 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43081 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290AbaAILFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:05:11 -0500
Date: Thu, 9 Jan 2014 11:04:40 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Neil Leeder <nleeder@codeaurora.org>,
        Ashwin Chaugule <ashwinc@codeaurora.org>
Subject: Re: [PATCH 3/7] ARM: perf_event: Add basic support for Krait CPU PMUs
Message-ID: <20140109110440.GC17838@mudshark.cambridge.arm.com>
References: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org>
 <1389221984-10973-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389221984-10973-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 10:59:40PM +0000, Stephen Boyd wrote:
> Add basic support for the Krait CPU PMU. This allows us to use
> the architected functionality of the PMU.
> 
> This is based on code originally written by Ashwin Chaugule and
> Neil Leeder [1].
> 
> [1] https://www.codeaurora.org/cgit/quic/la/kernel/msm/tree/arch/arm/kernel/perf_event_msm_krait.c?h=msm-3.4
> 
> Cc: Neil Leeder <nleeder@codeaurora.org>
> Cc: Ashwin Chaugule <ashwinc@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/kernel/perf_event_cpu.c |   1 +
>  arch/arm/kernel/perf_event_v7.c  | 165 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 166 insertions(+)

[...]

> +static int krait_pmu_init(struct arm_pmu *cpu_pmu)
> +{
> +	u32 id = read_cpuid_id() & 0xffffff00;
> +
> +	armv7pmu_init(cpu_pmu);
> +	cpu_pmu->name		= "ARMv7 Krait";
> +	/* Some early versions of Krait don't support PC write events */
> +	if (id == 0x511f0400 || id == 0x510f0600)
> +		cpu_pmu->map_event	= krait_map_event_no_branch;

Hmm, I'd really rather this information came via the DT. In fact, you could
just drop the branch event from your main map_event_function and keep things
simple. It depends how badly you want to advertise it in perf list :)

Will
