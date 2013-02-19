Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431Ab3BSVvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 16:51:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46574 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933697Ab3BSVvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 16:51:17 -0500
Message-ID: <5123F32B.3000401@zytor.com>
Date: Tue, 19 Feb 2013 13:48:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ebiederm@xmission.com, xemul@parallels.com,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 1/2] kcmp: Make it to depend on CONFIG_KCMP
References: <20130219064800.719149796@openvz.org> <20130219065210.030802820@openvz.org> <5123444D.6000806@suse.cz> <20130219093154.GF20312@moon> <5123BC2B.6000304@zytor.com> <20130219182838.GL20312@moon> <20130219134256.f4cedf44.akpm@linux-foundation.org>
In-Reply-To: <20130219134256.f4cedf44.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 01:42 PM, Andrew Morton wrote:
>> Index: linux-2.6.git/kernel/Makefile
>> ===================================================================
>> --- linux-2.6.git.orig/kernel/Makefile
>> +++ linux-2.6.git/kernel/Makefile
>> @@ -25,9 +25,7 @@ endif
>>   obj-y += sched/
>>   obj-y += power/
>>
>> -ifeq ($(CONFIG_CHECKPOINT_RESTORE),y)
>> -obj-$(CONFIG_X86) += kcmp.o
>> -endif
>> +obj-$(CONFIG_KCMP) += kcmp.o
>>   obj-$(CONFIG_FREEZER) += freezer.o
>>   obj-$(CONFIG_PROFILING) += profile.o
>>   obj-$(CONFIG_STACKTRACE) += stacktrace.o
>
> This permits people to select kcmp with CONFIG_CHECKPOINT_RESTORE=n.
> Is there any point in doing that?
>
> What would be wrong with just doing
>
> 	obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
>

The real question is if there are any potential use cases of kcmp() 
outside checkpoint/restore.  It is actually a very general facility.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

