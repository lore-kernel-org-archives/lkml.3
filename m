Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbaAGC4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:56:01 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:61217 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaAGCz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:55:59 -0500
MIME-Version: 1.0
In-Reply-To: <1388972316.4918.5.camel@buesod1.americas.hpqcorp.net>
References: <1388675120-8017-1-git-send-email-davidlohr@hp.com>
	<1388972316.4918.5.camel@buesod1.americas.hpqcorp.net>
Date: Tue, 7 Jan 2014 10:55:57 +0800
X-Google-Sender-Auth: 8W5a5U-zXE9A7SuH6U8BYebV6Bs
Message-ID: <CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com>
Subject: Re: [PATCH 5/4] futex: silence uninitialized warnings
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 6, 2014 at 9:38 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>  {
>         int lock_taken, ret, force_take = 0;
> -       u32 uval, newval, curval, vpid = task_pid_vnr(task);
> +       u32 uval, newval, uninitialized_var(curval), vpid = task_pid_vnr(task);

Do you have some broken compiler? I really tend to hate this kind of
workarounds, because as mentioned, they can actually hide valid
warnings, and it seems to be due to just stupid compilers. Are we
perhaps better off trying to get people off the broken compiler
versions instead?

              Linus
