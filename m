Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbaJIPRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:17:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:40729 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaJIPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:17:31 -0400
Date: Thu, 9 Oct 2014 17:17:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] sched: schedule_tail() should disable preemption
Message-ID: <20141009151730.GW10832@worktop.programming.kicks-ass.net>
References: <20141007195046.GA28002@redhat.com>
 <20141008080016.GB10832@worktop.programming.kicks-ass.net>
 <20141008183302.GA17495@redhat.com>
 <20141008183326.GB17495@redhat.com>
 <20141008193644.GA32055@redhat.com>
 <1412804248.24248.1.camel@yandex.ru>
 <20141009145726.GA5604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009145726.GA5604@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 04:57:26PM +0200, Oleg Nesterov wrote:

> but first we need to remove ->saved_preempt_count.

Why do you want to kill that? Your earlier proposal would penalize every
!x86 arch by adding extra code to the scheduler core while they already
automagically preserve their thread_info::preempt_count.

