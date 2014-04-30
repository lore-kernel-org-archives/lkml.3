Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbaD3O5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:57:40 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:36630 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758885AbaD3O5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:57:39 -0400
Message-ID: <53610F60.2060102@suse.cz>
Date: Wed, 30 Apr 2014 16:57:36 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 03/16] kgr: initial code
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>	<1398868249-26169-4-git-send-email-jslaby@suse.cz> <20140430105602.1bed3090@gandalf.local.home>
In-Reply-To: <20140430105602.1bed3090@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 04:56 PM, Steven Rostedt wrote:
> On Wed, 30 Apr 2014 16:30:36 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
>> --- a/arch/x86/kernel/entry_64.S
>> +++ b/arch/x86/kernel/entry_64.S
>> @@ -615,6 +615,7 @@ GLOBAL(system_call_after_swapgs)
>>  	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
>>  	movq  %rcx,RIP-ARGOFFSET(%rsp)
>>  	CFI_REL_OFFSET rip,RIP-ARGOFFSET
>> +	movw $0, TI_kgr_in_progress+THREAD_INFO(%rsp,RIP-ARGOFFSET)
> 
> Why is this not a entry flag? Because you just added a store into a
> fast path of the kernel for something that will be hardly ever used.

Actually it is converted later in the series, please see 16/16.

>> --- /dev/null
>> +++ b/include/linux/kgr.h
>> @@ -0,0 +1,71 @@
>> +#ifndef LINUX_KGR_H
>> +#define LINUX_KGR_H
>> +
>> +#include <linux/init.h>
>> +#include <linux/ftrace.h>
>> +
>> +#include <asm/kgr.h>
>> +
>> +#ifdef CONFIG_KGR
>> +
>> +#define KGR_TIMEOUT 30
>> +#define KGR_DEBUG 1
>> +
>> +#ifdef KGR_DEBUG
>> +#define kgr_debug(args...)	\
>> +	pr_info(args);
>> +#else
>> +#define kgr_debug(args...) { }
>> +#endif
> 
> Why not just use pr_debug(), as that's not defined unless you add DEBUG
> as a define anyway?

Yeah, OK.

thanks,
-- 
js
suse labs
