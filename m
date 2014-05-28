Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbaE1WCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:02:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbaE1WCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:02:33 -0400
Date: Thu, 29 May 2014 00:02:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Petr Mladek <pmladek@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
In-Reply-To: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
Message-ID: <alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014, Petr Mladek wrote:

> printk() cannot be used safely in NMI context because it uses internal locks
> and thus could cause a deadlock. Unfortunately there are circumstances when
> calling printk from NMI is very useful. For example, all WARN.*(in_nmi())
> would be much more helpful if they didn't lockup the machine.
> 
> Another example would be arch_trigger_all_cpu_backtrace for x86 which uses NMI
> to dump traces on all CPU (either triggered by sysrq+l or from RCU stall
> detector).

I am rather surprised that this patchset hasn't received a single review 
comment for 3 weeks.

Let me point out that the issues Petr is talking about in the cover letter 
are real -- we've actually seen the lockups triggered by RCU stall 
detector trying to dump stacks on all CPUs, and hard-locking machine up 
while doing so.

So this really needs to be solved.

-- 
Jiri Kosina
SUSE Labs
