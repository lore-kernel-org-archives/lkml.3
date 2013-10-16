Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761452Ab3JPTM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:12:56 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44212 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3JPTMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:12:55 -0400
From: bsegall@google.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, pjt@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] sched: Fix cfs_bandwidth misuse of hrtimer_expires_remaining
References: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
	<20131016181617.22647.73829.stgit@sword-of-the-dawn.mtv.corp.google.com>
	<20131016184144.GH2675@laptop.programming.kicks-ass.net>
Date: Wed, 16 Oct 2013 12:12:52 -0700
In-Reply-To: <20131016184144.GH2675@laptop.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Wed, 16 Oct 2013 20:41:44 +0200")
Message-ID: <xm2661sxyqq3.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Oct 16, 2013 at 11:16:17AM -0700, Ben Segall wrote:
>> + * Requires cfs_b->lock for hrtimer_expires_remaining to be safe against the
>> + * hrtimer base being cleared by __hrtimer_start_range_ns. This is possibly
>> + * incorrect if we ever built with CPU_HOTPLUG.
>
> Do clarify; most people build with hotplug enabled; due to wanting
> suspend/resume stuff etc..

Whoops, that comment turned out to be incorrect anyway - I was worried
about migrate_timers, but it is safe as it is. The following should be
accurate:

+ * Requires cfs_b->lock for hrtimer_expires_remaining to be safe against the
+ * hrtimer base being cleared by __hrtimer_start_range_ns. In the case of
+ * migrate_hrtimers, base is never cleared, so we are fine.
