Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaKFQ4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:56:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaKFQ4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:56:20 -0500
Date: Thu, 6 Nov 2014 17:56:17 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 11/12 v3] printk: Add per_cpu printk func to allow
 printk to be diverted
Message-ID: <20141106165617.GA28294@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160223.146433028@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104160223.146433028@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-04 10:52:48, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Being able to divert printk to call another function besides the normal
> logging is useful for such things like NMI handling. If some functions
> are to be called from NMI that does printk() it is possible to lock up
> the box if the nmi handler triggers when another printk is happening.
> 
> One example of this use is to perform a stack trace on all CPUs via NMI.
> But if the NMI is to do the printk() it can cause the system to lock up.
> By allowing the printk to be diverted to another function that can safely
> record the printk output and then print it when it in a safe context
> then NMIs will be safe to call these functions like show_regs().
> 
> Link: http://lkml.kernel.org/p/20140619213952.209176403@goodmis.org
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Looks fine to me.

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
