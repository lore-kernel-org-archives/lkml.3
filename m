Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762186Ab3JPVFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 17:05:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761392Ab3JPVFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 17:05:04 -0400
Date: Wed, 16 Oct 2013 22:58:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] (Was: perf_event_mmap(vma) && !vma->vm_mm)
Message-ID: <20131016205800.GB26066@redhat.com>
References: <20131012192203.GA21738@redhat.com> <20131014102426.GX3081@twins.programming.kicks-ass.net> <20131016200924.GA23214@redhat.com> <20131016202822.GI2675@laptop.programming.kicks-ass.net> <20131016204348.GA25121@redhat.com> <20131016205807.GG10651@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016205807.GG10651@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Peter Zijlstra wrote:
>
> On Wed, Oct 16, 2013 at 10:43:48PM +0200, Oleg Nesterov wrote:
> > Peter, just in case. I understand that this all is minor. Just I am
> > confused. And in any case I do think we do not need __GFP_ZERO when
> > it comes to PAGE_SIZE allocation.
>
> Yeah; we could probably avoid it; if only the strcpy functions would
> return how many bytes they copied :/ Then we could create a nice little
> helper to \0 the tail end for alignment.
>
> Anyway, as long as the resulting code is obvious and makes it hard to
> leak something I'm fine.

OK. I'll wait for your review on this series, then send the next patch.

d_path() case can clear the extra bytes, everything else can use a single

	if (name != buf)
		name = str*copy(tmp, buf);

to avoid the leak.

Oleg.

