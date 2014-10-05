Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaJELTV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 07:19:21 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:59236 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaJELTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 07:19:18 -0400
Date: Sun, 5 Oct 2014 13:19:11 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slowdown due to threads bouncing between HT cores
Message-ID: <20141005111911.GA35329@sesse.net>
References: <20141003194428.GA27084@sesse.net>
 <20141004095004.3b84095f@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141004095004.3b84095f@as>
X-Operating-System: Linux 3.16.3 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2014 at 09:50:04AM -0500, Chuck Ebbert wrote:
> Try playing with /proc/sys/kernel/sched_migration_cost_ns. This sets
> the number of nanoseconds the kernel will wait before considering
> moving a thread to another CPU. I have mine set to 50000000.

I can't get any good effect out of this. I tried both 50 ms (your value) and
500 ms, and while it seems (by eyeballing the per-cpu display in top) to
_sometimes_ lock the processes to cores, more often than not, they still
bounce around between all 40. Worse still, when it _does_, it seems to often
lock them to hyperthread pairs (e.g., I've seen it put threads only on
virtual cores 0-9 and 20-29, which means it has all of them on one socket!)

Notwithstanding top, the benchmarks don't improve; setting cores manually
with taskset still is much better.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
