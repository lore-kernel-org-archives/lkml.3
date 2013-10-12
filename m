Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab3JLT3N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 15:29:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab3JLT3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 15:29:12 -0400
Date: Sat, 12 Oct 2013 21:22:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: perf_event_mmap(vma) && !vma->vm_mm
Message-ID: <20131012192203.GA21738@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am fighting with uprobe bug, and perf_event_mmap() complicates
the problem, it is the only reason (afaics) why the forking task
can not do install_special_mapping(new_child_mm). This means that
the child should do this itself, say, from task_work_run() but
this way it can't handle the error if get_xol_area() fails, too
late to abort the already finished copy_process().

But please ignore, the only question is that I can't understand
this

	if (!vma->vm_mm) {
		name = strncpy(tmp, "[vdso]", sizeof(tmp));
		goto got_name;
	}

code in perf_event_mmap_event() and I am just curious. How it is
possible that vma->vm_mm == NULL ? perf_event_mmap(vma) is never
called with, say, vma == gate_vma. And even if it was possible
arch_vma_name() should handle this case?

Thanks,

Oleg.

