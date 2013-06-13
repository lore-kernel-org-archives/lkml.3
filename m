Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab3FMAAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 20:00:25 -0400
Received: from forward5.mail.yandex.net ([77.88.46.21]:37545 "EHLO
	forward5.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab3FMAAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 20:00:24 -0400
Authentication-Results: smtp4.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <51B90D45.8050505@yandex.ru>
Date: Thu, 13 Jun 2013 04:07:33 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, tglx@linutronix.de
Subject: Re: [PATCH] spin_unlock*_no_resched()
References: <1022041371038807@web30d.yandex.ru>  <20130612121532.GD3204@twins.programming.kicks-ass.net> <1371042443.9844.255.camel@gandalf.local.home>
In-Reply-To: <1371042443.9844.255.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/13 17:07, Steven Rostedt wrote:
> On Wed, 2013-06-12 at 14:15 +0200, Peter Zijlstra wrote:
>
>> So I absolutely hate this API because people can (and invariably will)
>> abuse it; much like they did/do preempt_enable_no_resched().
>
> Me too.
>
>>
>> IIRC Thomas even maps preempt_enable_no_resched() to preempt_enable() in
>> -rt to make sure we don't miss preemption points due to stupidity.
>>
>> He converted the 'few' sane sites to use schedule_preempt_disabled(). In
>> that vein, does it make sense to introduce schedule_spin_locked()?
>>
>
> I was thinking the exact same thing when I read this patch. This is a
> strict policy that we should enforce and not let individual developers
> implement. Yes, a schedule_spin_unlock() would work nicely. The API will
> enforce the two to be used together. Otherwise, I can envision seeing
> things like:
>
> 	preempt_disable();
> 	[...]
>
> 	spin_lock(x);
>
> 	spin_unlock_no_resched(x);
>
> 	[...]
>
> 	preempt_enable();
>
> And developers having no idea why the above is broken. Although, I would
> say the above is broken for other reasons, but I was just using that to
> show the craziness such an API would give to us.
>
> -- Steve
>
>
>

In additional to my previous letter. If spin_lock is locked then irqs
must be disabled. So sorry for the noise.

