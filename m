Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbaAIT5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 14:57:22 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57852 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbaAIT5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 14:57:15 -0500
Message-ID: <52CEFF18.2070501@codeaurora.org>
Date: Thu, 09 Jan 2014 11:57:12 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Neil Leeder <nleeder@codeaurora.org>,
        Ashwin Chaugule <ashwinc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/7] ARM: perf_event: Add basic support for Krait CPU
 PMUs
References: <1389221984-10973-1-git-send-email-sboyd@codeaurora.org> <1389221984-10973-4-git-send-email-sboyd@codeaurora.org> <20140109110440.GC17838@mudshark.cambridge.arm.com>
In-Reply-To: <20140109110440.GC17838@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding DT reviewers)

On 01/09/14 03:04, Will Deacon wrote:
> On Wed, Jan 08, 2014 at 10:59:40PM +0000, Stephen Boyd wrote:
>
>> +static int krait_pmu_init(struct arm_pmu *cpu_pmu)
>> +{
>> +	u32 id = read_cpuid_id() & 0xffffff00;
>> +
>> +	armv7pmu_init(cpu_pmu);
>> +	cpu_pmu->name		= "ARMv7 Krait";
>> +	/* Some early versions of Krait don't support PC write events */
>> +	if (id == 0x511f0400 || id == 0x510f0600)
>> +		cpu_pmu->map_event	= krait_map_event_no_branch;
> Hmm, I'd really rather this information came via the DT. In fact, you could
> just drop the branch event from your main map_event_function and keep things
> simple. It depends how badly you want to advertise it in perf list :)
>

Not every version of Krait is missing support for this event, so I'd
like to keep it so things like perf stat show branch counts. How about I
add a bool property to the pmu node indicating that this PMU is missing
support for the PC write events? Something like "no-pc-write"?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

