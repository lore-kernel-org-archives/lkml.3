Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaERIE1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 04:04:27 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:59248 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaERIEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 04:04:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAAG0J9915TAT-9JUjz5cMQ_ze7jayhNpKpjZdCZG9JzW1ocBsA@mail.gmail.com>
References: <1397209481-28542-2-git-send-email-vincent.guittot@linaro.org>
 <tip-143e1e28cb40bed836b0a06567208bd7347c9672@git.kernel.org> <CAAG0J9915TAT-9JUjz5cMQ_ze7jayhNpKpjZdCZG9JzW1ocBsA@mail.gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Sun, 18 May 2014 10:04:01 +0200
Message-ID: <CAKfTPtDp2-Jicp2JL_OHvFFfZ9+DArk-XP61dBB=ufJCR1ffpQ@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Rework sched_domain topology definition
To: James Hogan <james.hogan@imgtec.com>
Cc: Ingo Molnar <mingo@kernel.org>, Hanjun Guo <hanjun.guo@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Jason Low <jason.low2@hp.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "David S. Miller" <davem@davemloft.net>, bhelgaas@google.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        linux-tip-commits@vger.kernel.org, metag <linux-metag@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2014 11:57, James Hogan <james.hogan@imgtec.com> wrote:
> Hi Vincent,
>

[snip]

>
>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 2a4298f..656b035 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -985,6 +1006,38 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
>>
>>  bool cpus_share_cache(int this_cpu, int that_cpu);
>>
>> +typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
>> +typedef const int (*sched_domain_flags_f)(void);
>
> I just noticed, since May 9th, linux-next (ARCH=metag, gcc 4.2.4, with
> meta2_smp_defconfig) is showing loads of warnings due to the above
> line:
>
> include/linux/sched.h +1010 : warning: type qualifiers ignored on
> function return type
>
> Looks to me that the const serves no purpose in this context and could
> be removed.

Hi James,

Ok, i'm going to have a look a it. I haven't seen such warning during
my test but my configuration was different (ARCH=ARM gcc 4.7.1)

Thanks,
Vincent

>
> Cheers
> James
