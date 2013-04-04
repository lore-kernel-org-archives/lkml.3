Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761214Ab3DDNu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 09:50:26 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:34918 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761158Ab3DDNuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 09:50:25 -0400
MIME-Version: 1.0
In-Reply-To: <201304041345.41971.arnd@arndb.de>
References: <201304041345.41971.arnd@arndb.de>
Date: Thu, 4 Apr 2013 15:50:23 +0200
Message-ID: <CAFTL4hxMVJnk-EWbAcSZz4XmOCnYJdXtkvtRf6P0KWY_EzFCNQ@mail.gmail.com>
Subject: Re: posix_cpu_timer: initialize "now" variable
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/4 Arnd Bergmann <arnd@arndb.de>:
> Patch 6d0e025 "posix_cpu_timer: consolidate expiry time type" in linux-next
> introduces a new compiler warning:
>
> kernel/posix-cpu-timers.c: In function 'posix_cpu_timer_schedule':
> kernel/posix-cpu-timers.c:1127:19: warning: 'now' may be used uninitialized in this function [-Wmaybe-uninitialized]
>     clear_dead_task(timer, now);
>
> As far as I can tell, that warning is about an actual bug an not
> a false positive, as that variable is clearly never initialized
> when it gets used in line 1127.
>
> Here is a patch that makes the warning go away for me, no idea if this is
> the right solution or not.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I posted a fix two days ago: https://lkml.org/lkml/2013/3/30/63

Thanks.
