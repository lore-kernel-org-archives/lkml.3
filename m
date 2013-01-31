Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3AaRFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:05:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab3AaRFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:05:44 -0500
Date: Thu, 31 Jan 2013 18:04:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] uprobes: Teach debug/tracing/uprobe_events to do
	the filtering
Message-ID: <20130131170412.GA14017@redhat.com>
References: <20130127194814.GA25377@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130127194814.GA25377@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27, Oleg Nesterov wrote:
>
> Based on git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
> on top of pre-filtering patches in kernel/uprobes.c.
>
> Please review.

Self-NACK.

Everything seems to work, including the additional cleanupe I sent,
but:

> After that I'll try to change tools/perf to use this new feature.

this can't help perf.

I never used it before so I naively thought that it writes to
tracing/uprobe_events and does perf_event_open(id) in the single
session, but this is not true.

I'll try to do something else. It seems that we can use
TRACE_REG_PERF_OPEN rather than TRACE_REG_PERF_REGISTER and
exploit event->ctx->task->mm to implement the pre-filtering...

Oleg.

