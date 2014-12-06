Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaLFCtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:49:55 -0500
Received: from ns.horizon.com ([71.41.210.147]:46648 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751925AbaLFCty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:49:54 -0500
Date: 5 Dec 2014 21:49:52 -0500
Message-ID: <20141206024952.24901.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: akpm@linux-foundation.org, linux@horizon.com
Subject: Re: [PATCH] [PATCH] VERIFY_OCTAL_PERMISSIONS: Move to <linux/sysfs.h> where it belongs
Cc: linux-kernel@vger.kernel.org, rdunlap@infradead.org, rusty@rustcorp.com.au
In-Reply-To: <20141205172802.4c56cbd6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -----

> This shouldn't be here because "^---" is considered "end of changelog".

Damn it, I couldn't remember how to add not-for-commit comments to a patch.
I RTFMed and thought that was what "git mailinfo --scissors" wanted.

(Normally, I put it down with the diffstat, but preferred a more
prominent place for this conversation.)

> Let's include bug.h into sysfs.h.

It worked without, but yeah... since I can't figure *how* it works.

>> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
>> index 1c9effa2..974097df 100644
>> --- a/include/linux/moduleparam.h
>> +++ b/include/linux/moduleparam.h
>> @@ -1,9 +1,9 @@
>>  #ifndef _LINUX_MODULE_PARAMS_H
>>  #define _LINUX_MODULE_PARAMS_H
>>  /* (C) Copyright 2001, 2002 Rusty Russell IBM Corporation */
>> -#include <linux/init.h>
>>  #include <linux/stringify.h>
>> -#include <linux/kernel.h>
>> +#include <linux/sysfs.h>
>> +#include <linux/types.h>

> Removing the kernel.h inclusion is good, but risky.  Are you sure
> there's nothing in moduleparam.h which uses kernel.h things?

Well, I did a quick eyeball-scan, then did my usual build, then
an allyesconfig and an allmodconfig.

I found some other alarming things, but nothing related to this.

E.g.
drivers/net/ethernet/intel/i40e/i40e_debugfs.c: In function 'i40e_dbg_dump_desc':
drivers/net/ethernet/intel/i40e/i40e_debugfs.c:855:1: warning: the frame size of 8192 bytes is larger than 2048 bytes [-Wframe-larger-than=]
 }

(Honestly, I didn't wait for the allmodconfig to finish, since I
expected it to fail within the first few hundred modules if it was going to
fail at all, but it has finished now.)
