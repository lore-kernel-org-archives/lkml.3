Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab3JTIsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 04:48:43 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:44358 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3JTIsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 04:48:40 -0400
Date: Sun, 20 Oct 2013 10:48:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Sullivan <dsulliva@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hung_task debugging: Add tracepoint to report the
 hang
Message-ID: <20131020084837.GB16236@gmail.com>
References: <20131019161807.GA7431@redhat.com>
 <20131019161828.GA7439@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131019161828.GA7439@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Currently check_hung_task() prints a warning if it detects the problem, 
> but it is not convenient to watch the system logs if user-space wants to 
> be notified about the hang.
> 
> Add the new trace_sched_process_hang() into check_hung_task(), this way 
> a user-space monitor can easily wait for the hang and potentially 
> resolve a problem.

I'm wondering, is the data of trace_console() in kernel/printk/printk.c 
not sufficient?

If it's not enough then it might be better to add a higher level printk 
tracepoint instead - that can catch hung_task messages and (much) more.

Thanks,

	Ingo
