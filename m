Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaJUECg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:02:36 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:33432 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaJUECe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:02:34 -0400
MIME-Version: 1.0
In-Reply-To: <5445D6F7.1000805@landley.net>
References: <20141020144448.59e2e067d632c70353296e56@linux-foundation.org>
 <a6b3d86db6f5d19f7130b8dba2703dda68cb14d5.1413842560.git.luto@amacapital.net> <5445D6F7.1000805@landley.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 20 Oct 2014 21:02:02 -0700
Message-ID: <CALCETrWyphjjZfUsdgcYLepSF43pZMc2ECo-YoTt+by1bSH3wg@mail.gmail.com>
Subject: Re: [PATCH] init: Remove CONFIG_INIT_FALLBACK
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 8:45 PM, Rob Landley <rob@landley.net> wrote:
> On 10/20/14 17:04, Andy Lutomirski wrote:
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -960,13 +960,8 @@ static int __ref kernel_init(void *unused)
>>               ret = run_init_process(execute_command);
>>               if (!ret)
>>                       return 0;
>> -#ifndef CONFIG_INIT_FALLBACK
>>               panic("Requested init %s failed (error %d).",
>>                     execute_command, ret);
>> -#else
>> -             pr_err("Failed to execute %s (error %d).  Attempting defaults...\n",
>> -                    execute_command, ret);
>> -#endif
>>       }
>>       if (!try_to_run_init_process("/sbin/init") ||
>>           !try_to_run_init_process("/etc/init") ||
>>
>
> Would you like to remove the try_to_run_init_process() stack of random
> hardwired names that we can never reach if we panic, or do you just want
> to remove the error message?
>

I'm confused.  That code is reachable if there's no initramfs and
init= is not specified.

--Andy

> Confused,
>
> Rob



-- 
Andy Lutomirski
AMA Capital Management, LLC
