Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaAJLBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:01:50 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36546 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbaAJLBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:01:44 -0500
Date: Fri, 10 Jan 2014 11:01:14 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Neil Leeder <nleeder@codeaurora.org>,
        Ashwin Chaugule <ashwinc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        mark.rutland@arm.com
Subject: Re: [PATCH 3/7] ARM: perf_event: Add basic support for Krait CPU PMUs
Message-ID: <20140110110114.GC10455@mudshark.cambridge.arm.com>
References: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org>
 <1389221984-10973-4-git-send-email-sboyd@codeaurora.org>
 <20140109110440.GC17838@mudshark.cambridge.arm.com>
 <52CEFF18.2070501@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CEFF18.2070501@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 07:57:12PM +0000, Stephen Boyd wrote:
> (Adding DT reviewers)
> 
> On 01/09/14 03:04, Will Deacon wrote:
> > On Wed, Jan 08, 2014 at 10:59:40PM +0000, Stephen Boyd wrote:
> >
> >> +static int krait_pmu_init(struct arm_pmu *cpu_pmu)
> >> +{
> >> +	u32 id = read_cpuid_id() & 0xffffff00;
> >> +
> >> +	armv7pmu_init(cpu_pmu);
> >> +	cpu_pmu->name		= "ARMv7 Krait";
> >> +	/* Some early versions of Krait don't support PC write events */
> >> +	if (id == 0x511f0400 || id == 0x510f0600)
> >> +		cpu_pmu->map_event	= krait_map_event_no_branch;
> > Hmm, I'd really rather this information came via the DT. In fact, you could
> > just drop the branch event from your main map_event_function and keep things
> > simple. It depends how badly you want to advertise it in perf list :)
> >
> 
> Not every version of Krait is missing support for this event, so I'd
> like to keep it so things like perf stat show branch counts. How about I
> add a bool property to the pmu node indicating that this PMU is missing
> support for the PC write events? Something like "no-pc-write"?

Perhaps, although I think it should be qualcomm-specific, so something like
"qcom,krait-no-pc-write"? Again, I'd be glad to hear something from a DT
reviewer on this.

Will
