Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966922Ab3DQVx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 17:53:56 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:32787 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966683Ab3DQVxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 17:53:54 -0400
Message-ID: <516F19EE.5060309@kernel.org>
Date: Wed, 17 Apr 2013 17:53:50 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Borislav Petkov <bp@alien8.de>, Alex Shi <alex.shi@intel.com>,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>  <516724F5.20504@kernel.org> <5167C9FA.8050406@intel.com>  <20130412162348.GE2368@pd.tnic> <1365785311.5814.36.camel@marge.simpson.net>
In-Reply-To: <1365785311.5814.36.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 12:48 PM, Mike Galbraith wrote:
> On Fri, 2013-04-12 at 18:23 +0200, Borislav Petkov wrote: 
>> On Fri, Apr 12, 2013 at 04:46:50PM +0800, Alex Shi wrote:
>>> Thanks a lot for comments, Len!
>>
>> AFAICT, you kinda forgot to answer his most important question:
>>
>>> These numbers suggest that this patch series simultaneously
>>> has a negative impact on performance and energy required
>>> to retire the workload.  Why do it?
> 
> Hm.  When I tested AIM7 compute on a NUMA box, there was a marked
> throughput increase at the low to moderate load end of the test spectrum
> IIRC.  Fully repeatable.  There were also other benefits unrelated to
> power, ie mitigation of the evil face of select_idle_sibling().  I
> rather liked what I saw during ~big box test-drive.
> 
> (just saying there are other aspects besides joules in there)

Mike,

Can you re-run your AIM7 measurement with turbo-mode and HT-mode disabled,
and then independently re-enable them?

If you still see the performance benefit, then that proves
that the scheduler hacks are not about tricking into
turbo mode, but something else.

If the performance gains *are* about interactions with turbo-mode,
then perhaps what we should really be doing here is making
the scheduler explicitly turbo-aware?  Of course, that begs the question
of how the scheduler should be aware of cpufreq in general...

thanks,
Len Brown, Intel Open Source Technology Center

