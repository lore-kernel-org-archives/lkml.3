Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229Ab3CHCvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:51:08 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:38158 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab3CHCvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:51:06 -0500
Message-ID: <5139520C.1060109@linux.vnet.ibm.com>
Date: Fri, 08 Mar 2013 10:50:52 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wakeup buddy
References: <5136EB06.2050905@linux.vnet.ibm.com> <1362677252.10972.26.camel@laptop>
In-Reply-To: <1362677252.10972.26.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030802-8878-0000-0000-0000062E4E4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 01:27 AM, Peter Zijlstra wrote:
> On Wed, 2013-03-06 at 15:06 +0800, Michael Wang wrote:
>> @@ -3351,7 +3420,13 @@ select_task_rq_fair(struct task_struct *p, int
>> sd_flag, int wake_flags)
>>         }
>>  
>>         if (affine_sd) {
>> -               if (cpu != prev_cpu && wake_affine(affine_sd, p,
>> sync))
>> +               /*
>> +                * If current and p are wakeup related, and balance is
>> +                * guaranteed, we will try to make them running
>> closely
>> +                * to gain cache benefit.
>> +                */
>> +               if (cpu != prev_cpu && wakeup_related(p) &&
>> +                                       wake_affine(affine_sd, p,
>> sync))
>>                         prev_cpu = cpu;
> 
> 
> OK, so there's two issues I have with all this are:
> 
>  - it completely wrecks task placement for things like interrupts (sadly
> I don't
>      have a good idea about a benchmark where this matters).

I don't get this point...could you please give more details?

>  - yet another random number.. :/

Correct...well, but that also means flexibility, I suppose different
system and workload will need some tuning on this knob to gain more
benefit, by default, they will gain some benefit, small or big.

> 
> Also, I'm starting to dislike the buddy name; its somewhat over-used.
> 

I have to agree :), any suggestions?

Regards,
Michael Wang

