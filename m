Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab3KLRnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:43:14 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:40654 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3KLRnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:43:12 -0500
Date: Tue, 12 Nov 2013 23:13:02 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Add uprobe_task->dup_work/dup_addr
Message-ID: <20131112174302.GH2559@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131108190003.GA12755@redhat.com>
 <20131111071151.GA2559@linux.vnet.ibm.com>
 <20131111165543.GA12233@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131111165543.GA12233@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111217-0928-0000-0000-0000039518C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, and it is always equal to regs->ip when pre_ssout() is called,
> 
> > and do the necessary fixups after single stepping out of line.
> 
> Exactly. So it is write-only (and meaningless) to the generic uprobe
> code. We can (and perhaps should) move it into autask->saved_vaddr,
> arch_uprobe_pre_xol() can initialize it.
> 
> > The casual reading of this commit message, one can get an impression
> > that vaddr is never needed.
> 
> See above. The changelog doesn't say we can simply remove it, it says
> "move it".


Okay, moving to arch_uprobe_task is fine. I probably got confused by 
"First of all it is not really needed," 
> 
> > Your change still retains it.
> 
> 
> OK. How about dup_xol_work/dup_xol_vaddr ?
> 

Yes fine with me.

-- 
Thanks and Regards
Srikar Dronamraju

