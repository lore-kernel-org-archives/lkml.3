Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab3LJTyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:54:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60161 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3LJTyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:54:38 -0500
Message-ID: <52A77188.50200@jp.fujitsu.com>
Date: Tue, 10 Dec 2013 14:54:48 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: fweisbec@gmail.com
CC: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@kernel.org, peterz@infradead.org,
        oleg@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 02/10 v2] posix-timers: Remove dead process posix cpu
 timers caching
References: <1386611931-4658-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1386611931-4658-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/9/2013 12:58 PM), Frederic Weisbecker wrote:
> Now that we removed dead thread posix cpu timers caching,
> lets remove the dead process wide version. This caching
> is similar to the per thread version but it should be even
> more rare:
> 
> * If the process id dead, we are not reading its timers
> status from a thread belonging to its group since they
> are all dead. So this caching only concern remote process
> timers reads. Now posix cpu timers using itimers or timer_settime()
> can't do remote process timers anyway so it's not even clear if there
> is actually a user for this caching.
> 
> * Unlike per thread timers caching, this only applies to
> zombies targets. Buried targets' process wide timers return
> 0 values. But then again, timer_gettime() can't read remote
> process timers, so if the process is dead, there can't be
> any reader left anyway.
> 
> Then again this caching seem to complicate the code for
> corner cases that are probably not worth it. So lets get
> rid of it.
> 
> Also remove the sample snapshot on dying process timer
> that is now useless, as suggested by Kosaki.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Looks good to me.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



