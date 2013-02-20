Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935446Ab3BTOU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:20:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:14040 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757742Ab3BTOUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:20:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,702,1355126400"; 
   d="scan'208";a="289580374"
Message-ID: <5124DBA3.20605@intel.com>
Date: Wed, 20 Feb 2013 22:20:19 +0800
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
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com> <1361164062-20111-12-git-send-email-alex.shi@intel.com> <20130220121256.GD16775@pd.tnic>
In-Reply-To: <20130220121256.GD16775@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 2e8131d..0047856 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4053,6 +4053,8 @@ struct lb_env {
>>  	unsigned int		loop;
>>  	unsigned int		loop_break;
>>  	unsigned int		loop_max;
>> +	int			power_lb;  /* if power balance needed */
>> +	int			perf_lb;   /* if performance balance needed */
> 
> Those look like they're used like simple boolean flags. Why not make
> them such, i.e. bitfields? See struct perf_event_attr for an example.

there are 11 long words in struct lb_env now. use boolean or bitfields
can't save much space. and not use conveniently.
> 
> Thanks.
> 


-- 
Thanks
    Alex
