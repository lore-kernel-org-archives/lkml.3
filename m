Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3JBRP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:15:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48604 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab3JBRPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:15:24 -0400
Message-ID: <524C5484.5000601@ti.com>
Date: Wed, 2 Oct 2013 13:14:44 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched_clock: fix postinit no sched_clock function check
References: <1380732928-13897-1-git-send-email-santosh.shilimkar@ti.com> <20131002170917.GB30298@mudshark.cambridge.arm.com>
In-Reply-To: <20131002170917.GB30298@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 October 2013 01:09 PM, Will Deacon wrote:
> On Wed, Oct 02, 2013 at 05:55:28PM +0100, Santosh Shilimkar wrote:
>> The sched_clock code uses 2 levels of function pointers, sched_clock_func()
>> and read_sched_clock() but the no sched_clock check in postinit() just
>> checks read_sched_clock().
>>
>> This leads to kernel falling back to jiffy based sched clock even in
>> presence of sched_clock_func() which is not desirable.
>>
>> Fix the postinit() check to avoid the issue. Probably the issue is hidden
>> so far on most of the arm SOCs because of already existing sched_clock
>> registrations apart from arch_timer sched_clock. One can reproduce the
>> issue by just have arch_timer as sched_clock
> 
> Isn't this just an issue with the arch timer driver not calling
> setup_sched_clock? Instead, we munge around with sched_clock_func directly,
> which doesn't appear to be the way anybody else deals with this.
> 
I thought about that option as well but was not sure since even in that case
the check is not complete. We just ensure that function is popullated.

> I'm not sure of the history though, so perhaps there's a reason for this...
> 
Am curious as well.

Regards,
Santosh
