Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaKRRCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:02:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbaKRRCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:02:51 -0500
Date: Tue, 18 Nov 2014 18:02:58 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 26/26 v5] x86/nmi: Perform a safe NMI stack trace on all
 CPUs
Message-ID: <20141118170258.GM23958@pathway.suse.cz>
References: <20141115045847.712848224@goodmis.org>
 <20141115050605.055232587@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115050605.055232587@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-14 23:59:13, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> When trigger_all_cpu_backtrace() is called on x86, it will trigger an
> NMI on each CPU and call show_regs(). But this can lead to a hard lock
> up if the NMI comes in on another printk().
> 
> In order to avoid this, when the NMI triggers, it switches the printk
> routine for that CPU to call a NMI safe printk function that records the
> printk in a per_cpu seq_buf descriptor. After all NMIs have finished
> recording its data, the seq_bufs are printed in a safe context.
> 
> Link: http://lkml.kernel.org/p/20140619213952.360076309@goodmis.org
> 
> Tested-by: Jiri Kosina <jkosina@suse.cz>
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

I really like that the NMI part is fast and we do not longer
block many CPUs until the others are finished with priting.

Best Regards,
Petr
