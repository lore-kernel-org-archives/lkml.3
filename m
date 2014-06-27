Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaF0OlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:41:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:52872 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753194AbaF0OlC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:41:02 -0400
Date: Fri, 27 Jun 2014 10:40:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr =?UTF-8?B?TWzDoWRlaw==?= <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC][PATCH 5/5 v2] x86/nmi: Perform a safe NMI stack trace on
 all CPUs
Message-ID: <20140627104059.2f08aeb3@gandalf.local.home>
In-Reply-To: <20140627143246.GE23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
	<20140626220130.764213722@goodmis.org>
	<20140627143246.GE23205@pathway.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 16:32:46 +0200
Petr Mládek <pmladek@suse.cz> wrote:

 
> > +/*
> > + * It is not safe to call printk() directly from NMI handlers.
> > + * It may be fine if the NMI detected a lock up and we have no choice
> > + * but to do so, but doing a NMI on all other CPUs to get a back trace
> > + * can be done with a sysrq-l. We don't want that to lock up, which
> > + * can happen if the NMI interrupts a printk in progress.
> > + *
> > + * Instead, we redirect the vprintk() to this nmi_vprintk() that writes
> > + * the content into a per cpu seq_buf buffer. Then when the NMIs are
> > + * all done, we can safely dump the contents of the seq_buf to a printk()
> > + * from a non NMI context.
> > + */
> 
> I would move this comment above #define NMI_BUF_SIZE
> It should be on top because it helps to understand many other tricks that are
> used above.
> 

I have no problem with moving it. This started out as a simple comment
and then I just got carried away ;-)

-- Steve
