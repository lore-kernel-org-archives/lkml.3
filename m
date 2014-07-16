Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaGPXSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:18:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37130 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaGPXSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:18:43 -0400
Message-ID: <53C7084C.7090104@arm.com>
Date: Thu, 17 Jul 2014 01:18:36 +0200
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bruno Wolff III <bruno@wolff.to>
CC: Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from caffcdd8d27ba78730d5540396ce72ad022aff2c
References: <20140716145546.GA6922@wolff.to> <20140716151748.GC2460@hansolo.jdub.homelinux.org> <53C6CFCC.2050300@arm.com> <20140716195414.GA16401@wolff.to>
In-Reply-To: <20140716195414.GA16401@wolff.to>
X-OriginalArrivalTime: 16 Jul 2014 23:18:38.0503 (UTC) FILETIME=[463D1B70:01CFA14C]
X-MC-Unique: 114071700184001201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/14 21:54, Bruno Wolff III wrote:
> On Wed, Jul 16, 2014 at 21:17:32 +0200,
>    Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>> Hi Bruno and Josh,
>>
>>From the issue, I see that the machine making trouble is an Xeon (2
>> processors w/ hyper-threading).
>>
>> Could you please share:
>>
>> cat /proc/cpuinfo and
>
> I have attached it to the bug and to this message.
>
>> cat /proc/schedstat (kernel config w/ CONFIG_SCHEDSTATS=y)
>
> It looks like that isn't set for my previous builds and I'll need to
> set it for my next test build.
>
>> Could you also put the two BUG_ON lines into build_sched_groups()
>> [kernel/sched/core.c] wo/ the cpumask_clear() and setting
>> sg->sgc->capacity to 0 and share the possible crash output as well?
>
> I can try a new build with this. I can probably get results back tomorrow
> before I leave for work. The crashes happen too early in the boot process
> for me to easily capture output as text. I can slow things down to take
> pictures though.
>

That would be helpful. Thanks. I saw that you have CONFIG_SCHED_DEBUG 
enabled.

So the output of

$ cat /proc/sys/kernel/sched_domain/cpu*/domain*/*

would be handy too.

The difference to the Intel machine I tested on is that yours is a "dual 
single core CPU with hyper-threading' and mine is a 'dual core with 
hyper-threading'

yours:
$ cat cpuinfo.out | grep '^physical\|^core\|^cpu cores'
physical id	: 0
core id		: 0
cpu cores	: 1
physical id	: 3
core id		: 0
cpu cores	: 1
physical id	: 0
core id		: 0
cpu cores	: 1
physical id	: 3
core id		: 0
cpu cores	: 1

mine:
$ cat /proc/cpuinfo | grep '^physical\|^core\|^cpu cores'
physical id	: 0
core id		: 0
cpu cores	: 2
physical id	: 0
core id		: 0
cpu cores	: 2
physical id	: 0
core id		: 1
cpu cores	: 2
physical id	: 0
core id		: 1
cpu cores	: 2

Just to make sure, you do have 'CONFIG_X86_32=y' and '# CONFIG_NUMA is 
not set' in your build?

