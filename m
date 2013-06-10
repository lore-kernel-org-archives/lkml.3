Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab3FJCHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 22:07:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55775 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3FJCHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 22:07:44 -0400
X-IronPort-AV: E=Sophos;i="4.87,833,1363104000"; 
   d="scan'208";a="7511285"
Message-ID: <51B5344C.3060405@cn.fujitsu.com>
Date: Mon, 10 Jun 2013 10:05:00 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com, wangyun@linux.vnet.ibm.com,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        fweisbec@gmail.com
Subject: Re: [patch v8 6/9] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-7-git-send-email-alex.shi@intel.com> <51B530AE.3020004@cn.fujitsu.com> <51B53375.40102@intel.com>
In-Reply-To: <51B53375.40102@intel.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/10 10:05:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/10 10:05:54,
	Serialize complete at 2013/06/10 10:05:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 10:01 AM, Alex Shi wrote:

> On 06/10/2013 09:49 AM, Gu Zheng wrote:
>> On 06/07/2013 03:20 PM, Alex Shi wrote:
>>
>>>> They are the base values in load balance, update them with rq runnable
>>>> load average, then the load balance will consider runnable load avg
>>>> naturally.
>>>>
>>>> We also try to include the blocked_load_avg as cpu load in balancing,
>>>> but that cause kbuild performance drop 6% on every Intel machine, and
>>>> aim7/oltp drop on some of 4 CPU sockets machines.
>> Hi Alex,
>>    Could you explain me why including the blocked_load_avg causes performance drop ?
> 
> 
> Thanks for review!
> 
> the 9th patch has few explanation. like, after the only task got into
> sleep in a CPU, there is only blocked_load_avg left, it looks quite big
> in short time. that, block it get tasks before sleep, drive task to
> other cpu in periodic balance. So, it cause clear load imbalance.
> 

Got it. Thanks very much for your explanation.:)

Best regards,
Gu
