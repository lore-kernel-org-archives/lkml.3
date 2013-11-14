Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3KNMbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:31:48 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:48820 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab3KNMbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:31:46 -0500
Message-ID: <5284C2B9.2020805@cogentembedded.com>
Date: Thu, 14 Nov 2013 16:31:53 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: gaowanlong@cn.fujitsu.com, linux-sh@vger.kernel.org, lethal@linux-sh.org
CC: linux-kernel@vger.kernel.org, fengguang.wu@intel.com, kbuild-all@01.org
Subject: Re: [PATCH] sh: fix kernel build error
References: <1384353504-21886-1-git-send-email-gaowanlong@cn.fujitsu.com> <5283C19D.4050601@cogentembedded.com> <528418B1.6090507@cn.fujitsu.com>
In-Reply-To: <528418B1.6090507@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 14-11-2013 4:26, Wanlong Gao wrote:

>>>      arch/sh/kernel/kgdb.c: In function 'sleeping_thread_to_gdb_regs':
>>>>> arch/sh/kernel/kgdb.c:225:32: error: implicit declaration of function 'task_stack_page' [-Werror=implicit-function-declaration]
>>>>> arch/sh/kernel/kgdb.c:242:23: error: dereferencing pointer to incomplete type
>>>>> arch/sh/kernel/kgdb.c:243:22: error: dereferencing pointer to incomplete type
>>>      arch/sh/kernel/kgdb.c: In function 'singlestep_trap_handler':
>>>>> arch/sh/kernel/kgdb.c:310:27: error: 'SIGTRAP' undeclared (first use in this function)
>>>      arch/sh/kernel/kgdb.c:310:27: note: each undeclared identifier is reported only once for each function it appears in
>>>      cc1: all warnings being treated as errors

>>     Strange quoting...

> Strange? It's the build error log.

    I've never seen the leading > characters in gcc's error output.

>>> This is introduced by commit 16559ae.

>>     Please also specify that commit's summary line in parens.

> commit 16559ae48c76f1ceb970b9719dea62b77eb5d06b
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Mon Feb 4 15:35:26 2013 -0800

>      kgdb: remove #include <linux/serial_8250.h> from kgdb.h
>
>      There's no reason kgdb.h itself needs to include the 8250 serial port
>      header file.  So push it down to the _very_ limited number of individual
>      drivers that need the values in that file, and fix up the places where
>      people really wanted serial_core.h and platform_device.h.

>      Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


> And the line caused this build error is:

> diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
> index 4dff0c6..c6e091b 100644
> --- a/include/linux/kgdb.h
> +++ b/include/linux/kgdb.h
> @@ -13,7 +13,6 @@
>   #ifndef _KGDB_H_
>   #define _KGDB_H_
>
> -#include <linux/serial_8250.h>
>   #include <linux/linkage.h>
>   #include <linux/init.h>
>   #include <linux/atomic.h>

    That's all interesting but what I asked you to do is add the summary line 
("kgdb: remove #include <linux/serial_8250.h> from kgdb.h" in this case) 
enclosed into parentheses to your commit log. There was no need to tell me all 
the gory details of your fix. :-)

> Thanks,
> Wanlong Gao

WBR, Sergei

