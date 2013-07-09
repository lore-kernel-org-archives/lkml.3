Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3GIQsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:48:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:10502 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab3GIQsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:48:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1029,1363158000"; 
   d="scan'208";a="367245793"
Message-ID: <51DC3ED6.9050607@linux.intel.com>
Date: Tue, 09 Jul 2013 09:48:22 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 1/9] sched: Introduce power scheduler
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <1373385338-12983-2-git-send-email-morten.rasmussen@arm.com>
In-Reply-To: <1373385338-12983-2-git-send-email-morten.rasmussen@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/2013 8:55 AM, Morten Rasmussen wrote:
> +void power_schedule_wq(struct work_struct *work)
> +{
> +	__power_schedule();
> +	mod_delayed_work_on(schedule_cpu(), system_wq, &dwork,
> +				msecs_to_jiffies(INTERVAL));
> +}

please tell me this is at least a deferable timer kind of work?

waking the cpu up all the time even when idle is a huge negative on power ;-(

