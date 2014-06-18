Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbaFRXUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:20:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:31490 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756178AbaFRXU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:20:27 -0400
Date: Wed, 18 Jun 2014 19:20:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
Message-ID: <20140618192017.40094ae9@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1406182310070.2303@pobox.suse.cz>
References: <alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz>
	<20140529000909.GC6507@localhost.localdomain>
	<alpine.LNX.2.00.1405290959270.17241@pobox.suse.cz>
	<20140610164641.GD1951@localhost.localdomain>
	<CA+55aFzseOqF-EpKMvwKpfhBJZQSLqKpJ3shzVee9s0+mvyCuA@mail.gmail.com>
	<alpine.LNX.2.00.1406181245230.2303@pobox.suse.cz>
	<20140618143612.GC4669@linux.vnet.ibm.com>
	<CA+55aFwPgDC6gSEPfu3i-pA4f0ZbsTSvykxzX4sXMeLbdXuKrw@mail.gmail.com>
	<20140618162117.GM4669@linux.vnet.ibm.com>
	<alpine.LNX.2.00.1406182232390.2303@pobox.suse.cz>
	<20140618210757.GU4669@linux.vnet.ibm.com>
	<alpine.LNX.2.00.1406182310070.2303@pobox.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014 23:12:48 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:


> > I believe that this was what Steven was suggesting, though by using
> > tracing.  
> 
> My understanding was that Steven is suggesting using trace_printk() from 
> NMI.

Not quite. I was suggesting using the ftrace ring buffer. It could have
its own way to write the stack and not depend on tracing itself.

-- Steve
