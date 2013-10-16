Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302Ab3JPJWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:22:53 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35905 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932Ab3JPJWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:22:51 -0400
Message-ID: <1381915369.2045.118.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH 5/6] net: __this_cpu_inc in route.c
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>
Date: Wed, 16 Oct 2013 02:22:49 -0700
In-Reply-To: <20131016084659.GS10651@twins.programming.kicks-ass.net>
References: <20131015174722.615394057@linux.com>
	 <20131015174747.307585124@linux.com>
	 <20131016084659.GS10651@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 10:46 +0200, Peter Zijlstra wrote:

> Are we sure all !x86 implementations will DTRT in that it will increment
> some CPU and not get horribly confused? I suppose it would; but is
> that a guarantee given someplace?

I think we should be fine, these are only stats exposed
on /proc/net/stat/rt_cache

Those 32bit counters were useful when we still had IP route cache.

Most of the fields are no longer incremented.

We eventually could remove them.


