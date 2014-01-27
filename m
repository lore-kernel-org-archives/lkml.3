Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaA0RVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:21:33 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50066 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753480AbaA0RVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:21:32 -0500
Date: Mon, 27 Jan 2014 17:21:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/9] ARM: get rid of arch_cpu_idle_prepare()
Message-ID: <20140127172110.GR15937@n2100.arm.linux.org.uk>
References: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org> <1390802904-28399-2-git-send-email-nicolas.pitre@linaro.org> <52E6175F.1050401@linaro.org> <20140127160736.GP15937@n2100.arm.linux.org.uk> <52E69395.9020004@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E69395.9020004@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 06:12:53PM +0100, Daniel Lezcano wrote:
> On 01/27/2014 05:07 PM, Russell King - ARM Linux wrote:
>> On Mon, Jan 27, 2014 at 09:22:55AM +0100, Daniel Lezcano wrote:
>>> On 01/27/2014 07:08 AM, Nicolas Pitre wrote:
>>>> ARM and ARM64 are the only two architectures implementing
>>>> arch_cpu_idle_prepare() simply to call local_fiq_enable().
>>>>
>>>> We have secondary_start_kernel() already calling local_fiq_enable() and
>>>> this is done a second time in arch_cpu_idle_prepare() in that case. And
>>>> enabling FIQs has nothing to do with idling the CPU to start with.
>>>>
>>>> So let's introduce init_fiq_boot_cpu() to take care of FIQs on the boot
>>>> CPU and remove arch_cpu_idle_prepare(). This is now done a bit earlier
>>>> at late_initcall time but this shouldn't make a difference in practice
>>>> i.e. when FIQs are actually used.
>>>>
>>>> Signed-off-by: Nicolas Pitre <nico@linaro.org>
>>>
>>> Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>
>> What kind of review did you do when giving that attributation?
>
> I did the review to the best of my knowledge and with good will.
>
> I read your comment on this patch and I learnt one more thing.
>
> Today, I am smarter than yesterday and dumber than tomorrow :)

Just be aware that putting a comment along with the reviewed-by tag
is always a good idea.  I know that's a little more work, but this has
been raised a number of times by various people over the years.

A reviewed-by tag on its own doesn't mean much, as it could mean that
you've just glanced over the code and decided "yea, it looks okay", or
it could mean that you've spent all day verifying that the code change
is indeed correct.

Consequently, some will ignore emails which just contain a reviewed-by
attributation.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
