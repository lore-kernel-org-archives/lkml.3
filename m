Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab3KKJam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:30:42 -0500
Received: from exprod5og118.obsmtp.com ([64.18.0.160]:37496 "HELO
	exprod5og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752782Ab3KKJaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:30:25 -0500
MIME-Version: 1.0
In-Reply-To: <20131108155717.GB15074@mudshark.cambridge.arm.com>
References: <1383739658-10036-1-git-send-email-vkale@apm.com>
	<1383739658-10036-3-git-send-email-vkale@apm.com>
	<20131108155717.GB15074@mudshark.cambridge.arm.com>
Date: Mon, 11 Nov 2013 15:00:24 +0530
Message-ID: <CAPrCYkdCjUyPT3b+YQV_YWkwRwBgx2Tt_zQR+4W6hD7roTR1Xg@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64: perf: add support for percpu pmu interrupt
From: Vinayak Kale <vkale@apm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Tuan Phan <tphan@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 8, 2013 at 9:27 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, Nov 06, 2013 at 12:07:37PM +0000, Vinayak Kale wrote:
>> Add support for irq registration when pmu interrupt is percpu.
>>
>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>> Signed-off-by: Tuan Phan <tphan@apm.com>
>> ---
>>  arch/arm64/kernel/perf_event.c |  109 +++++++++++++++++++++++++++++-----------
>>  1 file changed, 81 insertions(+), 28 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
>> index cea1594..e60dae3 100644
>> --- a/arch/arm64/kernel/perf_event.c
>> +++ b/arch/arm64/kernel/perf_event.c
>> @@ -44,6 +44,7 @@
>>  static DEFINE_PER_CPU(struct perf_event * [ARMPMU_MAX_HWEVENTS], hw_events);
>>  static DEFINE_PER_CPU(unsigned long [BITS_TO_LONGS(ARMPMU_MAX_HWEVENTS)], used_mask);
>>  static DEFINE_PER_CPU(struct pmu_hw_events, cpu_hw_events);
>> +static bool is_percpuirq;
>
> This isn't a global property; it should be part of the struct arm_pmu.
> The rest of the patch looks ok, but obvious requires you to merge the core
> changes first.

Okay. I will incorporate above change in next revision once the core
changes are agreed upon.
