Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3JSNSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 09:18:44 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:45117 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab3JSNSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 09:18:43 -0400
Date: Sat, 19 Oct 2013 15:18:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: fix fork() with the pending ret-probe(s)
Message-ID: <20131019131839.GA11609@gmail.com>
References: <20131019130212.GA27109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131019130212.GA27109@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Ingo, please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
> 
> This fixes the serious bug, a forked process crashes if it returns
> from the probed function called by its parent, this cc's stable.
> 
> Also the minor fix from Ralf.
> 
> Oleg Nesterov (6):
>       uprobes: Change the callsite of uprobe_copy_process()
>       uprobes: Introduce __create_xol_area()
>       uprobes: Teach __create_xol_area() to accept the predefined vaddr
>       uprobes: Change uprobe_copy_process() to dup return_instances
>       uprobes: Change uprobe_copy_process() to dup xol_area
>       uprobes: Teach uprobe_copy_process() to handle CLONE_VFORK
> 
> Ralf Baechle (1):
>       uprobes: Remove the wrong __weak attribute
> 
>  include/linux/uprobes.h |    6 +-
>  kernel/events/uprobes.c |  156 ++++++++++++++++++++++++++++++++++++-----------
>  kernel/fork.c           |    2 +-
>  3 files changed, 124 insertions(+), 40 deletions(-)

Pulled into tip:perf/urgent, thanks a lot Oleg!

	Ingo
