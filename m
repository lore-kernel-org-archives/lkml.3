Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3EaROn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:14:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab3EaROe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:14:34 -0400
Date: Fri, 31 May 2013 19:10:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Guy Streeter <streeter@redhat.com>,
        Eric Paris <eparis@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: wait_for_auditd() should use
	TASK_UNINTERRUPTIBLE
Message-ID: <20130531171025.GA32387@redhat.com>
References: <20130524173925.GA17177@redhat.com> <20130529145933.6e02f8379cf20b9c7ef30977@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529145933.6e02f8379cf20b9c7ef30977@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29, Andrew Morton wrote:
>
> On Fri, 24 May 2013 19:39:25 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > audit_log_start() does wait_for_auditd() in a loop until
> > audit_backlog_wait_time passes or audit_skb_queue has a room.
> >
> > If signal_pending() is true this becomes a busy-wait loop,
> > schedule() in TASK_INTERRUPTIBLE won't block.
>
> And that's game over for a uniprocessor non-preempt machine, yes?

If this task is rt, yes. Otherwise schedule() still does pick_next_task()
but this is obviously bad anyway. So I fully agree with "Cc: stable" you
added.

> > Reported-by: Guy Streeter <streeter@redhat.com>
>
> And what did Guy report?  "that looks screwy"?  "my machine locked up"?

He also investigated the problem and provided the detailed explanation ;)

Oleg.

