Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbaEEOfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:35:23 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59145 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723AbaEEOfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:35:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140502164148.44c0674b@gandalf.local.home>
References: <1399062223-18928-1-git-send-email-ddstreet@ieee.org> <20140502164148.44c0674b@gandalf.local.home>
From: Dan Streetman <ddstreet@ieee.org>
Date: Mon, 5 May 2014 10:35:01 -0400
X-Google-Sender-Auth: qebw4WeNWhhBtFNyLU1hYnVpjv4
Message-ID: <CALZtONB-wT16fPX7GjBVFO_5Bof3=zxviG22p6_9ymbnzA9QAA@mail.gmail.com>
Subject: Re: [PATCH] plist: include -DDEBUG if CONFIG_DEBUG_PI_LIST
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 4:41 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri,  2 May 2014 16:23:43 -0400
> Dan Streetman <ddstreet@ieee.org> wrote:
>
>> lib/plist.c uses pr_debug() in its test function, which is compiled
>> and run only when CONFIG_DEBUG_PI_LIST in set; however pr_debug()
>> is compiled out unless -DDEBUG is set for the file.
>>
>> Update lib/Makefile to add -DDEBUG to CFLAGS_plist.o if
>> CONFIG_DEBUG_PI_LIST is set, so that the pr_debug() output from
>> plist_test() is shown.
>
> Why not just use printk(KERN_DEBUG ...) then if we always want to print
> it?
>
> You could just place
>
> #define DEBUG
>
> in plist.c as well. Although I think just switching to printk() is
> better.

Agreed - since the entire function is already inside
CONFIG_DEBUG_PI_LIST, there's no need to additionally require DEBUG so
we should just use printk.  New patch to follow.

Thanks!

>
> -- Steve
>
>>
>> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
>> ---
>>  lib/Makefile | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/lib/Makefile b/lib/Makefile
>> index 0cd7b68..fd1f4c8 100644
>> --- a/lib/Makefile
>> +++ b/lib/Makefile
>> @@ -39,6 +39,10 @@ CFLAGS_kobject.o += -DDEBUG
>>  CFLAGS_kobject_uevent.o += -DDEBUG
>>  endif
>>
>> +ifeq ($(CONFIG_DEBUG_PI_LIST),y)
>> +CFLAGS_plist.o += -DDEBUG
>> +endif
>> +
>>  obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
>>  obj-$(CONFIG_GENERIC_PCI_IOMAP) += pci_iomap.o
>>  obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
>
