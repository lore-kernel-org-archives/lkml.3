Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab3DQT2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:28:43 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:32758 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab3DQT2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:28:41 -0400
Message-ID: <516EF7E4.3070701@hp.com>
Date: Wed, 17 Apr 2013 15:28:36 -0400
From: Waiman Long <Waiman.Long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v3 5/5] mutex: Move mutex spinning code from sched/core.c
 back to mutex.c
References: <1366172891-7729-1-git-send-email-Waiman.Long@hp.com> <1366172891-7729-6-git-send-email-Waiman.Long@hp.com> <20130417071827.GB21051@gmail.com>
In-Reply-To: <20130417071827.GB21051@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 03:18 AM, Ingo Molnar wrote:
> * Waiman Long<Waiman.Long@hp.com>  wrote:
>
>> As mentioned by Ingo, the SCHED_FEAT_OWNER_SPIN scheduler feature
>> bit was really just an early hack to make with/without mutex-spinning
>> testable. So it is no longer necessary.
>>
>> This patch removes the SCHED_FEAT_OWNER_SPIN feature bit and move the
>> mutex spinning code from kernel/sched/core.c back to kernel/mutex.c
>> which is where they should belong.
>>
>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
>> ---
>>   include/linux/sched.h   |    4 ---
>>   kernel/mutex.c          |   62 ++++++++++++++++++++++++++++++++++++++++++++++
>>   kernel/sched/core.c     |   63 -----------------------------------------------
>>   kernel/sched/features.h |    7 -----
>>   4 files changed, 62 insertions(+), 74 deletions(-)
> Please move this patch first in the series - so that later, functional patches are
> easier to revert, should the need arise. When possible we sort patches by risk:
> low risk ones first, riskier come later.

I have sent out a new series (v4) with the requested changes. Please let 
me know what else do you think I need to do.

Regards,
Longman
