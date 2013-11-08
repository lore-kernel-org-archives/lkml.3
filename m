Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab3KHP6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:58:05 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38625 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303Ab3KHP6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:58:03 -0500
Date: Fri, 8 Nov 2013 15:57:17 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vinayak Kale <vkale@apm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Tuan Phan <tphan@apm.com>
Subject: Re: [PATCH 2/2] arm64: perf: add support for percpu pmu interrupt
Message-ID: <20131108155717.GB15074@mudshark.cambridge.arm.com>
References: <1383739658-10036-1-git-send-email-vkale@apm.com>
 <1383739658-10036-3-git-send-email-vkale@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383739658-10036-3-git-send-email-vkale@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 12:07:37PM +0000, Vinayak Kale wrote:
> Add support for irq registration when pmu interrupt is percpu.
> 
> Signed-off-by: Vinayak Kale <vkale@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> ---
>  arch/arm64/kernel/perf_event.c |  109 +++++++++++++++++++++++++++++-----------
>  1 file changed, 81 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index cea1594..e60dae3 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -44,6 +44,7 @@
>  static DEFINE_PER_CPU(struct perf_event * [ARMPMU_MAX_HWEVENTS], hw_events);
>  static DEFINE_PER_CPU(unsigned long [BITS_TO_LONGS(ARMPMU_MAX_HWEVENTS)], used_mask);
>  static DEFINE_PER_CPU(struct pmu_hw_events, cpu_hw_events);
> +static bool is_percpuirq;

This isn't a global property; it should be part of the struct arm_pmu.
The rest of the patch looks ok, but obvious requires you to merge the core
changes first.

Will
