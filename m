Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab3GDJ6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:58:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36120 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab3GDJ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:58:18 -0400
Date: Thu, 4 Jul 2013 11:57:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v2 4/7] perf, x86: Save/resotre LBR stack during context
 switch
Message-ID: <20130704095735.GL18898@dyad.programming.kicks-ass.net>
References: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com>
 <1372663387-11754-5-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372663387-11754-5-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 03:23:04PM +0800, Yan, Zheng wrote:
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -185,6 +185,13 @@ void intel_pmu_lbr_reset(void)
>  		intel_pmu_lbr_reset_32();
>  	else
>  		intel_pmu_lbr_reset_64();
> +
> +	wrmsrl(x86_pmu.lbr_tos, 0);
> +}

I double checked; my SDM Jun 2013, Vol 3C 35-93 very explicitly states that
MSR_LASTBRANCH_TOS is a read-only MSR. And afaicr all previous times I checked
this it did say this too.
