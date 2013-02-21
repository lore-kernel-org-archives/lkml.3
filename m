Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3BUBce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 20:32:34 -0500
Received: from mga14.intel.com ([143.182.124.37]:9051 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab3BUBcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 20:32:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,705,1355126400"; 
   d="scan'208";a="204691596"
Message-ID: <51257946.1010505@intel.com>
Date: Thu, 21 Feb 2013 09:32:54 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        morten.rasmussen@arm.com
Subject: Re: [patch v5 11/15] sched: add power/performance balance allow flag
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-12-git-send-email-alex.shi@intel.com> <20130220121256.GD16775@pd.tnic> <5124DBA3.20605@intel.com> <20130220152234.GE16775@pd.tnic>
In-Reply-To: <20130220152234.GE16775@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 11:22 PM, Borislav Petkov wrote:
> On Wed, Feb 20, 2013 at 10:20:19PM +0800, Alex Shi wrote:
>>>> > >> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>> > >> index 2e8131d..0047856 100644
>>>> > >> --- a/kernel/sched/fair.c
>>>> > >> +++ b/kernel/sched/fair.c
>>>> > >> @@ -4053,6 +4053,8 @@ struct lb_env {
>>>> > >>  	unsigned int		loop;
>>>> > >>  	unsigned int		loop_break;
>>>> > >>  	unsigned int		loop_max;
>>>> > >> +	int			power_lb;  /* if power balance needed */
>>>> > >> +	int			perf_lb;   /* if performance balance needed */
>>> > > 
>>> > > Those look like they're used like simple boolean flags. Why not make
>>> > > them such, i.e. bitfields? See struct perf_event_attr for an example.
>> > 
>> > there are 11 long words in struct lb_env now. use boolean or bitfields
>> > can't save much space.
> Now now maybe.
> 
> Btw, there's a ->flags variable there which simply cries to get another
> LBF_* flag or two. This way you don't add any new members at all and
> don't enlarge the struct.
> 

Yes, use flags can save 2 int variable, I will change that.

Just curious, consider the lb_env size and just used in stack, plus the
big cacheline size of modern cpu, and the alignment of gcc flag on
kernel, seems no arch needs more cache lines. Are there any platforms
performance is impacted by this 2 int variables?

-- 
Thanks Alex
