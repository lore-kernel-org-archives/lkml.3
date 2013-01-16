Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab3APV4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:56:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620Ab3APV4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:56:48 -0500
Date: Wed, 16 Jan 2013 13:56:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        johnstul@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/4] sched: /proc/sched_debug fails on very very
 large machines.
Message-Id: <20130116135647.019cbe8d.akpm@linux-foundation.org>
In-Reply-To: <1358286372-13777-3-git-send-email-nzimmer@sgi.com>
References: <1358286372-13777-1-git-send-email-nzimmer@sgi.com>
	<1358286372-13777-3-git-send-email-nzimmer@sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 15:46:10 -0600
Nathan Zimmer <nzimmer@sgi.com> wrote:

> On systems with 4096 cores attemping to read /proc/sched_debug fails.
> We are trying to push all the data into a single kmalloc buffer.
> The issue is on these very large machines all the data will not fit in 4mb.
> 
> A better solution is to not us the single_open mechanism but to provide
> our own seq_operations and treat each cpu as an individual record.
> 
> The output should be identical to previous version.
> 
> ...
>
> +	int cpu = (unsigned long)(v - 2);

Again, the meaning of the magic offsets are unobvious to readers of
this code.

> -	SEQ_printf(m, "\n");
> +	if (cpu != -1)
> +		print_cpu(m, cpu);

Same concerns with cpu hotplug.

> +	else
> +		sched_debug_header(m);
>  
>  	return 0;
>  }

