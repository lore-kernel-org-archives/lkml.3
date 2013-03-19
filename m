Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3CSMwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:52:06 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:56764 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab3CSMwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:52:01 -0400
MIME-Version: 1.0
In-Reply-To: <1363696232.22553.37.camel@laptop>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
	<9f0fd16f792b9f9b399a4c91c98de37c56067d47.1363617402.git.viresh.kumar@linaro.org>
	<1363696232.22553.37.camel@laptop>
Date: Tue, 19 Mar 2013 18:22:00 +0530
Message-ID: <CAKohpo===J9EeZXcDa2cmUifuwinSVnQsOs1u-cg==tfbs_-0Q@mail.gmail.com>
Subject: Re: [PATCH V3 1/7] sched: Create sched_select_cpu() to give preferred
 CPU for power saving
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, rostedt@goodmis.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2013 18:00, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2013-03-18 at 20:53 +0530, Viresh Kumar wrote:
>> +/*
>> + * This routine returns the nearest non-idle cpu. It accepts a
>> bitwise OR of
>> + * SD_* flags present in linux/sched.h. If the local CPU isn't idle,
>> it is
>> + * returned back. If it is idle, then we must look for another CPU
>> which have
>> + * all the flags passed as argument as set.
>> + */
>> +int sched_select_cpu(unsigned int sd_flags)
>
> So the only problem I have is that you expose the SD_flags to !sched
> code. The only proposed user is in the workqueue code and passes 0.
>
> Why not leave out the sd_flags argument and introduce it once you start
> using it; at which point we can argue on the interface.

Yes, that can be done. Will fix it up.
