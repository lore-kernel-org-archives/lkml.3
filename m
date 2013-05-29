Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935267Ab3E2V7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:59:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935228Ab3E2V7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:59:35 -0400
Date: Wed, 29 May 2013 14:59:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Guy Streeter <streeter@redhat.com>,
        Eric Paris <eparis@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: wait_for_auditd() should use
 TASK_UNINTERRUPTIBLE
Message-Id: <20130529145933.6e02f8379cf20b9c7ef30977@linux-foundation.org>
In-Reply-To: <20130524173925.GA17177@redhat.com>
References: <20130524173925.GA17177@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 May 2013 19:39:25 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> audit_log_start() does wait_for_auditd() in a loop until
> audit_backlog_wait_time passes or audit_skb_queue has a room.
> 
> If signal_pending() is true this becomes a busy-wait loop,
> schedule() in TASK_INTERRUPTIBLE won't block.

And that's game over for a uniprocessor non-preempt machine, yes?

> Reported-by: Guy Streeter <streeter@redhat.com>

And what did Guy report?  "that looks screwy"?  "my machine locked up"?

> @@ -1056,7 +1056,7 @@ static inline void audit_get_stamp(struc
>  static void wait_for_auditd(unsigned long sleep_time)
>  {
>  	DECLARE_WAITQUEUE(wait, current);
> -	set_current_state(TASK_INTERRUPTIBLE);
> +	set_current_state(TASK_UNINTERRUPTIBLE);
>  	add_wait_queue(&audit_backlog_wait, &wait);
>  
>  	if (audit_backlog_limit &&
