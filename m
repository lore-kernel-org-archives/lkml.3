Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765143Ab3DIO0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:26:42 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:57889 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761106Ab3DIO0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:26:41 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <51642262.10902@windriver.com>
References: <CA+icZUUkEgv+e1q3v1kW5WhJdT1egZKc5o96zF2omcT0YtVE3w@mail.gmail.com>
	<51642262.10902@windriver.com>
Date: Tue, 9 Apr 2013 16:26:40 +0200
Message-ID: <CA+icZUWECpybkd8AxhvzboE0c54PkoLEZGBSXU-hbOVmEChaug@mail.gmail.com>
Subject: Re: kdb: kgdb: CONFIG_DEBUG_RODATA setting?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 4:14 PM, Jason Wessel <jason.wessel@windriver.com> wrote:
> On 04/09/2013 08:06 AM, Sedat Dilek wrote:
>
>>  config DEBUG_RODATA
>>       bool "Write protect kernel read-only data structures"
>> -     default y
>>       depends on DEBUG_KERNEL
>> +     default n if KGDB
>> +     default y
>>       ---help---
>>         Mark the kernel read-only data as write-protected in the pagetables,
>>         in order to catch accidental (and incorrect) writes to such const
>
>
> This is wrong and should not be merged.
>
> A) You should not change these defaults in this manner
>
> B) You have pointed out that the documentation is currently
>    incorrect. The CONFIG_DEBUG_RODATA constraints were removed some time
>    ago, per commit 3751d3e85cf693e10e2c47c03c8caa65e171099b (x86,kgdb:
>    Fix DEBUG_RODATA limitation using text_poke())
>

OK (B) has to be changed then.
I had a look at the new WIKI [1] and FAQ [2].

The new FAQ does not list any recommended kconfig-settings.
This is what I have:

$ egrep -i 'kdb|kgdb|debug_rodata|early_printk|frame_pointer' .config
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_SERIAL_KGDB_NMI=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
# CONFIG_KGDB_TESTS is not set
CONFIG_KGDB_LOW_LEVEL_TRAP=y
CONFIG_KGDB_KDB=y
CONFIG_KDB_KEYBOARD=y
CONFIG_KDB_CONTINUE_CATASTROPHIC=0
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set

OK? Sth. missing?

Booting with...

*** Configure kdb for early debugging: earlyprintk=vga ekgdboc=kbd ***

...shows me nothing here.

Might be the problem in Linux-Next [3,4] is not triggable with kdb/kgdb.

Thanks for your help in advance.

Regards,
- Sedat -

[1] https://kgdb.wiki.kernel.org/index.php/Main_Page
[2] https://kgdb.wiki.kernel.org/index.php/KDB_FAQ
[3] http://marc.info/?t=136545603700003&r=1&w=2
[4] http://marc.info/?t=136545773000008&r=1&w=2


> Jason.
>
