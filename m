Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaLRS1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 13:27:20 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:56787 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaLRS1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 13:27:19 -0500
MIME-Version: 1.0
In-Reply-To: <549307F0.7090009@zytor.com>
References: <d7875b60e28c512f6a6fc0baf5714d58e7eaadbb.1418856405.git.luto@amacapital.net>
 <tip-3fb2f4237bb452eb4e98f6a5dbd5a445b4fed9d0@git.kernel.org> <549307F0.7090009@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 18 Dec 2014 10:26:57 -0800
Message-ID: <CALCETrU=+rBkG_xwaOA4vruiAeHFE_XLPrAgVCjnvpO5WrfgTw@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86/tls: Don't validate lm in set_thread_area()
 after all
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 8:59 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/18/2014 03:16 AM, tip-bot for Andy Lutomirski wrote:
>> Commit-ID:  3fb2f4237bb452eb4e98f6a5dbd5a445b4fed9d0
>> Gitweb:     http://git.kernel.org/tip/3fb2f4237bb452eb4e98f6a5dbd5a445b4fed9d0
>> Author:     Andy Lutomirski <luto@amacapital.net>
>> AuthorDate: Wed, 17 Dec 2014 14:48:30 -0800
>> Committer:  Ingo Molnar <mingo@kernel.org>
>> CommitDate: Thu, 18 Dec 2014 12:12:26 +0100
>>
>> x86/tls: Don't validate lm in set_thread_area() after all
>>
>> It turns out that there's a lurking ABI issue.  GCC, when
>> compiling this in a 32-bit program:
>>
>> struct user_desc desc = {
>>       .entry_number    = idx,
>>       .base_addr       = base,
>>       .limit           = 0xfffff,
>>       .seg_32bit       = 1,
>>       .contents        = 0, /* Data, grow-up */
>>       .read_exec_only  = 0,
>>       .limit_in_pages  = 1,
>>       .seg_not_present = 0,
>>       .useable         = 0,
>> };
>>
>> will leave .lm uninitialized.  This means that anything in the
>> kernel that reads user_desc.lm for 32-bit tasks is unreliable.
>>
>
> No, it won't.  However, if you initialize this dynamically field by
> field rather than as an initializer, then you are correct.
>

I tried the code above in function scope.

--Andy

>         -hpa
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
