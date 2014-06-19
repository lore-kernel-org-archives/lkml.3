Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966522AbaFSXjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:39:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965603AbaFSXjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:39:02 -0400
Date: Fri, 20 Jun 2014 01:38:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 0/3] x86/nmi: Print all cpu stacks from NMI safely
In-Reply-To: <20140619193635.1949b469@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1406200137310.15014@pobox.suse.cz>
References: <20140619213329.478113470@goodmis.org> <alpine.LNX.2.00.1406192349400.15014@pobox.suse.cz> <20140619185810.4137e14b@gandalf.local.home> <alpine.LNX.2.00.1406200100520.15014@pobox.suse.cz> <20140619191923.1365850a@gandalf.local.home>
 <alpine.LNX.2.00.1406200123220.15014@pobox.suse.cz> <20140619193635.1949b469@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Steven Rostedt wrote:

> > I don't think there is a need for a global stop_machine()-like 
> > synchronization here. The printing CPU will be sending IPI to the CPU N+1 
> > only after it has finished printing CPU N stacktrace.
> 
> So you plan on sending an IPI to a CPU then wait for it to acknowledge
> that it is spinning, and then print out the data and then tell the CPU
> it can stop spinning?

Yes, that was exactly my idea. You have to be synchronized with the CPU 
receiving the NMI anyway in case you'd like to get its pt_regs and dump 
those as part of the dump.

-- 
Jiri Kosina
SUSE Labs
