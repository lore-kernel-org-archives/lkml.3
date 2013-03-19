Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934363Ab3CSWn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:43:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933877Ab3CSWn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:43:28 -0400
Date: Tue, 19 Mar 2013 15:43:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/4] posix_cpu_timer: Consolidate expiry time type
Message-Id: <20130319154326.f8fd35776086c66617a08c90@linux-foundation.org>
In-Reply-To: <1363366442-11494-2-git-send-email-fweisbec@gmail.com>
References: <1363366442-11494-1-git-send-email-fweisbec@gmail.com>
	<1363366442-11494-2-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013 17:53:59 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> The posix cpu timer expiry time is stored in a union of
> two types: a 64 bits field if we rely on scheduler precise
> accounting, or a cputime_t if we rely on jiffies.
> 
> This result in quite some duplicate code and special cases
> to handle the two types.
> 
> Just unify this into a single 64 bits field. cputime_t can
> always fit into it.
> 

x86_64 allnoconfig:

kernel/posix-cpu-timers.c: In function 'posix_cpu_timer_schedule':
kernel/posix-cpu-timers.c:1127: warning: 'now' may be used uninitialized in this function

It looks like it's always been buggy, but your switch from `union
cou_time_count' to `unsigned long long' made gcc notice it.

