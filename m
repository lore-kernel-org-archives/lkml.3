Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190Ab3HMUYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:24:36 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41758 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264Ab3HMUYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <520A83B0.40607@sgi.com>
References: <1375465467-40488-1-git-send-email-nzimmer@sgi.com>
	<1376344480-156708-1-git-send-email-nzimmer@sgi.com>
	<CA+55aFwTQLexJkf67P0b7Z7cw8fePjdDSdA4SOkM+Jf+kBPYEA@mail.gmail.com>
	<520A6DFC.1070201@sgi.com>
	<CA+55aFwRHdQ_f6ryUU1yWkW1Qz8cG958jLZuyhd_YdOq4-rfRA@mail.gmail.com>
	<520A7514.9020008@sgi.com>
	<520A83B0.40607@sgi.com>
Date: Tue, 13 Aug 2013 13:24:31 -0700
X-Google-Sender-Auth: Ic39Y3GCJG_7cIZOWK3JoYCiHr4
Message-ID: <CAE9FiQXdHWEF9aTQtTa8AjM8BTUZWg6TSUebqBr9aT8JL58c8A@mail.gmail.com>
Subject: Re: [RFC v3 0/5] Transparent on-demand struct page initialization
 embedded in the buddy allocator
From: Yinghai Lu <yinghai@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nathan Zimmer <nzimmer@sgi.com>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Robin Holt <holt@sgi.com>,
        Rob Landley <rob@landley.net>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 12:06 PM, Mike Travis <travis@sgi.com> wrote:
>
>
> On 8/13/2013 11:04 AM, Mike Travis wrote:
>>
>>
>> On 8/13/2013 10:51 AM, Linus Torvalds wrote:
>>> by the time you can log in. And if it then takes another ten minutes
>>> until you have the full 16TB initialized, and some things might be a
>>> tad slower early on, does anybody really care?  The machine will be up
>>> and running with plenty of memory, even if it may not be *all* the
>>> memory yet.
>>
>> Before the patches adding memory took ~45 mins for 16TB and almost 2 hours
>> for 32TB.  Adding it late sped up early boot but late insertion was still
>> very slow, where the full 32TB was still not fully inserted after an hour.
>> Doing it in parallel along with the memory hotplug lock per node, we got
>> it down to the 10-15 minute range.
>>
>
> FYI, the system at this time had 128 nodes each with 256GB of memory.
> About 252GB was inserted into the absent list from nodes 1 .. 126.
> Memory on nodes 0 and 128 was left fully present.

Can we have one topic about those boot time issues in this year kernel summit?

There will be more 32 sockets x86 systems and will have lots of
memory, pci chain and cpu cores.

current kernel/smp.c::smp_init(),  we still have
|        /* FIXME: This should be done in userspace --RR */
|        for_each_present_cpu(cpu) {
|                if (num_online_cpus() >= setup_max_cpus)
|                        break;
|                if (!cpu_online(cpu))
|                        cpu_up(cpu);
|        }

solution would be:
1. delay some memory, pci chain, or cpus cores.
2. or parallel initialize them during booting
3. or parallel add them after booting.

Thanks

Yinghai
