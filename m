Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbaAUAfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 19:35:23 -0500
Received: from ozlabs.org ([203.10.76.45]:58815 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525AbaAUAfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 19:35:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 3.13-rc5] module: Add missing newline in printk call.
In-Reply-To: <201401172058.DHJ34830.OFFSOLVJHOMtFQ@I-love.SAKURA.ne.jp>
References: <201312231603.IGB09833.HLJtFMOOFSFQVO@I-love.SAKURA.ne.jp> <201401172058.DHJ34830.OFFSOLVJHOMtFQ@I-love.SAKURA.ne.jp>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 21 Jan 2014 09:58:36 +1030
Message-ID: <87r482qlln.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:
> Rusty, would you pick up this patch?
>
> This message was added in 3.13-rc1. Thus, should be fixed in 3.13.

Thanks, applied.  It's a bit trivial for a CC:stable though.

Cheers,
Rusty.

> Tetsuo Handa wrote:
>> From cc90e27d5cda227e7a0cbeb5de3cc1cbb1595dfa Mon Sep 17 00:00:00 2001
>> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> Date: Mon, 23 Dec 2013 15:52:42 +0900
>> Subject: [PATCH] module: Add missing newline in printk call.
>> 
>> Add missing \n and also follow commit bddb12b3 "kernel/module.c: use pr_foo()".
>> 
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>> ---
>>  kernel/module.c |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>> 
>> diff --git a/kernel/module.c b/kernel/module.c
>> index f5a3b1e..d24fcf2 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -815,10 +815,8 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>>  		return -EFAULT;
>>  	name[MODULE_NAME_LEN-1] = '\0';
>>  
>> -	if (!(flags & O_NONBLOCK)) {
>> -		printk(KERN_WARNING
>> -		       "waiting module removal not supported: please upgrade");
>> -	}
>> +	if (!(flags & O_NONBLOCK))
>> +		pr_warn("waiting module removal not supported: please upgrade\n");
>>  
>>  	if (mutex_lock_interruptible(&module_mutex) != 0)
>>  		return -EINTR;
>> -- 
>> 1.7.1
>> 
