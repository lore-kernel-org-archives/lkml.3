Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab3HNQ66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:58:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47045 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932885Ab3HNQ64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:58:56 -0400
Message-ID: <520BB71F.6000701@zytor.com>
Date: Wed, 14 Aug 2013 09:58:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <bitbucket@online.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH 0/5] preempt_count rework
References: <20130814131539.790947874@chello.nl> <520B8A81.1080405@zytor.com> <1376494751.7355.28.camel@marge.simpson.net> <20130814160632.GJ24092@twins.programming.kicks-ass.net> <520BACEA.50604@zytor.com> <20130814165227.GA21191@laptop.programming.kicks-ass.net>
In-Reply-To: <20130814165227.GA21191@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 09:52 AM, Peter Zijlstra wrote:
> 
> Oh curses, this is because lea can't do segment offsets? So there's no
> sane way to get addresses of per-cpu variables.
> 
> Because ideally we'd have something like:
> 
>   lea %gs:__percpu_runqueues,%rax
> 
> So in this case it makes sense to also store the actual pointer; how
> unfortunate.
> 

Correct; the segment offset is not part of the effective address, even
in 64-bit mode.

	-hpa

