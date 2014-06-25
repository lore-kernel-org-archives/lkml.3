Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbaFYMVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:21:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbaFYMVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:21:51 -0400
Date: Wed, 25 Jun 2014 14:21:49 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>
Subject: Re: [RFC][PATCH 0/3] x86/nmi: Print all cpu stacks from NMI safely
Message-ID: <20140625122149.GL8769@pathway.suse.cz>
References: <20140619213329.478113470@goodmis.org>
 <alpine.LNX.2.00.1406192349400.15014@pobox.suse.cz>
 <20140619185810.4137e14b@gandalf.local.home>
 <alpine.LNX.2.00.1406200100520.15014@pobox.suse.cz>
 <20140619191923.1365850a@gandalf.local.home>
 <alpine.LNX.2.00.1406200123220.15014@pobox.suse.cz>
 <20140619193635.1949b469@gandalf.local.home>
 <alpine.LNX.2.00.1406200137310.15014@pobox.suse.cz>
 <20140620143525.GB8769@pathway.suse.cz>
 <CALYGNiM3OH64ULh63cCarTitbjUatZP0mckJ3N9CDusP3mFMRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALYGNiM3OH64ULh63cCarTitbjUatZP0mckJ3N9CDusP3mFMRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-06-24 17:32:15, Konstantin Khlebnikov wrote:
> 
> Instead of per-cpu buffers printk might use part of existing ring
> buffer  -- initiator cpu allocates space for
> target cpu and flushes it into common stream after it finish printing.
> Probably this kind of transactional model might be used on single cpu
> for multi-line KERN_CONT.

I wanted to think more about this.

The evident advantage is that we do not need extra buffers. Also it might
be used instead of the cont buffer.

One challenge is that we do not know how much space is needed. If
we do not reserve enough, we might not be able to reserve it later.
This would happen when the main ring buffer is locked by some
blocked process. If we reserve too much, it is a waste of information.
Note that we must remove old messages to make the space.

Also we could not rotate the ring buffer over the reserved space. Then
we might miss the last messages from the normal context when the
system goes down.

Another question is if it could simplify the printk() code. The reservation
logic would be probably more complicated than the current logic around
the cont buffer.

Best Regards,
Petr
