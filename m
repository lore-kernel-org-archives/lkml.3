Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647Ab3CZMck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:32:40 -0400
Received: from intranet.asianux.com ([58.214.24.6]:16925 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020Ab3CZMcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:32:39 -0400
X-Spam-Score: -100.8
Message-ID: <51519549.5070204@asianux.com>
Date: Tue, 26 Mar 2013 20:32:09 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: tglx@linutronix.de, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Suggestion] kernel: 'now' may be used uninitialized in posix_cpu_timer_schedule
 function
References: <51514202.2030504@asianux.com> <CAFTL4hw2vc5C9gdf1bm413MftfaYB5PWxTuuU9C5iAuzD_YKEw@mail.gmail.com>
In-Reply-To: <CAFTL4hw2vc5C9gdf1bm413MftfaYB5PWxTuuU9C5iAuzD_YKEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年03月26日 20:27, Frederic Weisbecker wrote:
> 2013/3/26 Chen Gang <gang.chen@asianux.com>:
>> > Hello Maintainers:
>> >
>> >   compiling with EXTRA_CFLAGS=-W:
>> >     make V=1 EXTRA_CFLAGS=-W ARCH=arm s3c2410_defconfig
>> >     make V=1 EXTRA_CFLAGS=-W ARCH=arm menuconfig
>> >       set 'arm-linux-gnu-' for cross chain prefix
>> >     make V=1 EXTRA_CFLAGS=-W ARCH=arm
>> >
>> >   it will report:
>> >     kernel/posix-cpu-timers.c:1065:19: warning: �now� may be used uninitialized in this function [-Wuninitialized]
>> >
>> >   it seems it is really a bug.
>> >     can any member help to fix it ?
>> >     or provide additional suggestion ?
>> >       (it seems only "unsigned long long now = 0" is not enough).
> Yeah it's missing a call to cpu_timer_sample_group() before
> clear_dead_task(). Andrew Morton reported the warning and I have a
> pending patch to fix that. I'm just checking a few other things before
> sending it. These clear_dead_task() calls seem to also conflict with
> cleanup_timers(). I'm fixing that too.
> 
> Thanks for your report!
> 
> 

  thank you, too.

  :-)

-- 
Chen Gang

Asianux Corporation
