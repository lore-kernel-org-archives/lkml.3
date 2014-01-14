Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaANPQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:16:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50984 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbaANPQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:16:09 -0500
Message-ID: <52D55479.9010802@zytor.com>
Date: Tue, 14 Jan 2014 07:15:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the tip
 tree
References: <20140114155331.88d170d3c991b9465c23a537@canb.auug.org.au> <20140114125153.GY7572@laptop.programming.kicks-ass.net>
In-Reply-To: <20140114125153.GY7572@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 04:51 AM, Peter Zijlstra wrote:
> On Tue, Jan 14, 2014 at 03:53:31PM +1100, Stephen Rothwell wrote:
>> Hi Andrew,
>>
>> Today's linux-next merge of the akpm-current tree got a conflict in
>> kernel/futex.c between commit a52b89ebb6d4 ("futexes: Increase hash table
>> size for better performance") from the tip tree and commit 61beee6c76e5
>> ("futex: switch to USER_DS for futex test") from the akpm-current tree.
>>
>> @@@ -2869,10 -2748,13 +2871,13 @@@
>>   	 * implementation, the non-functional ones will return
>>   	 * -ENOSYS.
>>   	 */
>> + 	fs = get_fs();
>> + 	set_fs(USER_DS);
>>   	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
>>   		futex_cmpxchg_enabled = 1;
>> + 	set_fs(fs);
>>   
> 
> This seems terribly broken, the *futex_value*() ops should not need
> that; they are supposed to access userspace without any of that.
> 

I am *guessing* that m68k is has get_fs() == KERNEL_DS at the point that
futex_init() is called.  This would seem a bit of a peculiarity to m68k,
and as such it would seem like it would be better for it to belong in
the m68k-specific code, but since futex_init() is init code and only
called once anyway it shouldn't cause any harm...

	-hpa

