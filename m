Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab3JQPeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:34:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964Ab3JQPeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:34:24 -0400
Date: Thu, 17 Oct 2013 17:27:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] (Was: perf_event_mmap(vma) && !vma->vm_mm)
Message-ID: <20131017152717.GA15308@redhat.com>
References: <20131012192203.GA21738@redhat.com> <20131014102426.GX3081@twins.programming.kicks-ass.net> <20131016200924.GA23214@redhat.com> <20131016202822.GI2675@laptop.programming.kicks-ass.net> <20131016204348.GA25121@redhat.com> <20131016205807.GG10651@twins.programming.kicks-ass.net> <20131016205800.GB26066@redhat.com> <20131016211613.GJ10651@twins.programming.kicks-ass.net> <20131017152027.GA14098@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131017152027.GA14098@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17, Oleg Nesterov wrote:
>
> 	- we do not really need "len", we can simply do
>
> 		size = strlen(name) + 1;
> 		while (size % sizeof(u64))
> 			name[size++] = '\0';
>
> 	  although I won't argue if you dislike "size & 7" in while().

Or, perhaps,

	while (!IS_ALIGNED(size, sizeof(u64)))
		name[size++] = '\0';

to make it self-explanatory.

Oleg.

