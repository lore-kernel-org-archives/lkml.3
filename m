Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3AOAZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:25:42 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:59258 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab3AOAZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:25:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAMbhsRQv=ogNmkK=Np6JGM-iuG=aocqb_4aMBC6CW5mpkGvpmw@mail.gmail.com>
References: <1357941108-14138-1-git-send-email-ccross@android.com>
	<CAFTL4hzYkPCmkfqBafkTA5E_snkLoC_y3p9xwumj=L1xWAWK0g@mail.gmail.com>
	<CAMbhsRQv=ogNmkK=Np6JGM-iuG=aocqb_4aMBC6CW5mpkGvpmw@mail.gmail.com>
Date: Tue, 15 Jan 2013 01:25:40 +0100
Message-ID: <CAFTL4hxnCn13PigcWjrcnSV9RAz5gSX-VtQk9J8HEbQco7jbbQ@mail.gmail.com>
Subject: Re: [PATCH v2] hardlockup: detect hard lockups without NMIs using
 secondary cpus
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Colin Cross <ccross@android.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        liu chuansheng <chuansheng.liu@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/15 Colin Cross <ccross@android.com>:
> On Mon, Jan 14, 2013 at 4:13 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> I believe this is pretty much what the RCU stall detector does
>> already: checks for other CPUs being responsive. The only difference
>> is on how it checks that. For RCU it's about checking for CPUs
>> reporting quiescent states when requested to do so. In your case it's
>> about ensuring the hrtimer interrupt is well handled.
>>
>> One thing you can do is to enqueue an RCU callback (cal_rcu()) every
>> minute so you can force other CPUs to report quiescent states
>> periodically and thus check for lockups.
>
> That's a good point, I'll take a look at using that.  A minute is too
> long, some SoCs have maximum HW watchdog periods of under 30 seconds,
> but a call_rcu every 10-20 seconds might be sufficient.

Sure. And you can tune CONFIG_RCU_CPU_STALL_TIMEOUT accordingly.
