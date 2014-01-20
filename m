Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaATBI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 20:08:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37778 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbaATBIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 20:08:25 -0500
Message-ID: <52DC76B8.7050808@zytor.com>
Date: Sun, 19 Jan 2014 17:07:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the tip tree
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au> <CAJvTdKmdopjSopfHrZRKXJBKqjizrFHich+dQCd6Fq7C3bOogw@mail.gmail.com>
In-Reply-To: <CAJvTdKmdopjSopfHrZRKXJBKqjizrFHich+dQCd6Fq7C3bOogw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2014 05:00 PM, Len Brown wrote:
> On Wed, Jan 15, 2014 at 10:58 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
>> failed like this:
>>
>> arch/x86/kernel/process.c: In function 'mwait_idle':
>> /scratch/sfr/next/arch/x86/kernel/process.c:434:3: error: implicit declaration of function '__monitor' [-Werror=implicit-function-declaration]
>>    __monitor((void *)&current_thread_info()->flags, 0, 0);
>>    ^
>> arch/x86/kernel/process.c:437:4: error: implicit declaration of function '__sti_mwait' [-Werror=implicit-function-declaration]
>>     __sti_mwait(0, 0);
>>     ^
>>
>> Caused by commit 16824255394f ("x86, acpi, idle: Restructure the mwait
>> idle routines") interacting with commit 7760518cce95 ("x86 idle: restore
>> mwait_idle()") from the idle tree.
>>
>> I am not sure how to fix this so I just reverted the idle tree commit for
>> now (since it reverted cleanly). Please let me know if there is a better
>> solution.
> 
> IMO, a regression fix (restore mwait_idle()) is more important than a clean up
> (restructure mwait routines), and the clean-up should take a back seat;
> in -tip, in -next, upstream, and in -stable.
> 
> Also, I'm wondering if that clean-up went too far -- as not all users of mwait
> are necessarily under the same conditions...
> 

Sounds like a NAK to me, in which case that bit should probably be
deferred and reintroduced after fixing via the idle tree?

	-hpa


