Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754Ab3CZM1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:27:52 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:62794 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759518Ab3CZM1v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:27:51 -0400
MIME-Version: 1.0
In-Reply-To: <51514202.2030504@asianux.com>
References: <51514202.2030504@asianux.com>
Date: Tue, 26 Mar 2013 13:27:49 +0100
Message-ID: <CAFTL4hw2vc5C9gdf1bm413MftfaYB5PWxTuuU9C5iAuzD_YKEw@mail.gmail.com>
Subject: Re: [Suggestion] kernel: 'now' may be used uninitialized in
 posix_cpu_timer_schedule function
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: tglx@linutronix.de, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/26 Chen Gang <gang.chen@asianux.com>:
> Hello Maintainers:
>
>   compiling with EXTRA_CFLAGS=-W:
>     make V=1 EXTRA_CFLAGS=-W ARCH=arm s3c2410_defconfig
>     make V=1 EXTRA_CFLAGS=-W ARCH=arm menuconfig
>       set 'arm-linux-gnu-' for cross chain prefix
>     make V=1 EXTRA_CFLAGS=-W ARCH=arm
>
>   it will report:
>     kernel/posix-cpu-timers.c:1065:19: warning: ‘now’ may be used uninitialized in this function [-Wuninitialized]
>
>   it seems it is really a bug.
>     can any member help to fix it ?
>     or provide additional suggestion ?
>       (it seems only "unsigned long long now = 0" is not enough).

Yeah it's missing a call to cpu_timer_sample_group() before
clear_dead_task(). Andrew Morton reported the warning and I have a
pending patch to fix that. I'm just checking a few other things before
sending it. These clear_dead_task() calls seem to also conflict with
cleanup_timers(). I'm fixing that too.

Thanks for your report!
