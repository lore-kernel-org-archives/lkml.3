Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab3H3DQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 23:16:28 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:42633 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3H3DQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 23:16:27 -0400
Message-ID: <52200E7C.5040402@hp.com>
Date: Thu, 29 Aug 2013 23:16:12 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Alexander Fyodorov <halcy@yandex.ru>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH RFC v2 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <15321377012704@web8h.yandex.ru> <52142D6C.6000400@hp.com> <336901377100289@web16f.yandex.ru> <5215638E.5020702@hp.com> <169431377178121@web21f.yandex.ru> <521BB71F.6080300@hp.com> <66111377605355@web12m.yandex.ru> <521F67C9.4080805@hp.com> <53161377795800@web14m.yandex.ru>
In-Reply-To: <53161377795800@web14m.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 01:03 PM, Alexander Fyodorov wrote:
> 29.08.2013, 19:25, "Waiman Long"<waiman.long@hp.com>:
>> What I have been thinking is to set a flag in an architecture specific
>> header file to tell if the architecture need a memory barrier. The
>> generic code will then either do a smp_mb() or barrier() depending on
>> the presence or absence of the flag. I would prefer to do more in the
>> generic code, if possible.
> If you use flag then you'll have to check it manually. It is better to add new smp_mb variant, I suggest calling it smp_mb_before_store(), and define it to barrier() on x86.

I am sorry that I was not clear in my previous mail. I mean a flag/macro 
for compile time checking rather than doing runtime checking.

Regards,
Longman
