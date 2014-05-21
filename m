Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaEUIxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:53:45 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:51837 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaEUIxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:53:42 -0400
Date: Wed, 21 May 2014 14:23:35 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Denys Vlasenko <dvlasenk@redhat.com>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Shift ->readpage check from __copy_insn() to
 uprobe_register()
Message-ID: <20140521085335.GA29630@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140519184054.GA6750@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140519184054.GA6750@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052108-8878-0000-0000-00000C8A4FD8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-05-19 20:40:54]:

> Sorry for double-posting, but it seems that this patch didn't reach
> lkml. Let me resend it just on case. Plus another patch in reply, on
> top of this change.
> 
> -------------------------------------------------------------------------------
> Subject: [PATCH] uprobes: Shift ->readpage check from __copy_insn() to uprobe_register()
> 
> copy_insn() fails with -EIO if ->readpage == NULL, but this error
> is not propagated unless uprobe_register() path finds ->mm which
> already mmaps this file. In this case (say) "perf record" does not
> actually install the probe, but the user can't know about this.
> 
> Move this check into uprobe_register() so that this problem can be
> detected earlier and reported to user.
> 
> Note: this is still not perfect,
> 
> 	- copy_insn() and arch_uprobe_analyze_insn() should be called
> 	  by uprobe_register() but this is not simple, we need vm_file
> 	  for read_mapping_page() (although perhaps we can pass NULL),
> 	  and we need ->mm for is_64bit_mm() (although this logic is
> 	  broken anyway).
> 
> 	- uprobe_register() should be called by create_trace_uprobe(),
> 	  not by probe_event_enable(), so that an error can be detected
> 	  at "perf probe -x" time. This also needs more changes in the
> 	  core uprobe code, uprobe register/unregister interface was
> 	  poorly designed from the very beginning.
> 
> Reported-by: Denys Vlasenko <dvlasenk@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

