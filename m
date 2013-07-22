Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab3GVRTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:19:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab3GVRTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:19:46 -0400
Date: Mon, 22 Jul 2013 19:14:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] tracing: Introduce trace_create_cpu_file() and
	tracing_get_cpu()
Message-ID: <20130722171435.GA27080@redhat.com>
References: <20130722134342.GA18355@redhat.com> <1374504957.3356.91.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374504957.3356.91.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Steven Rostedt wrote:
>
> Now here's why I'm emailing you.  What Oleg is doing here is instead of
> creating this extra trace_cpu structure, he's using the inode->i_cdev to
> store the CPU information (he's wrapped this with helper functions so we
> can use any inode structure). He sets inode->i_cdev to CPU+1 or to
> RING_BUFFER_ALL_CPUS (when all CPU info is needed).

This doesn't really matter, but RING_BUFFER_ALL_CPUS is encoded as NULL
so we do not need to change init_tracer_debugfs(). inode_init_always()
clears ->i_cdev.

Al, I will appreciate it if can ack/nack this hack.

I chose i_cdev because it shares the same union with i_pipe/bdev, this
(I hope) obviously means that vfs can never use this pointer unless it
checks S_ISCHR().

Oleg.

