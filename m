Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaKCVvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:51:19 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaKCVvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:51:16 -0500
Date: Mon, 3 Nov 2014 22:51:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: arapov@gmail.com, poros@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, matt@console-pimps.org
Subject: Re: FW/BIOS Bug category for oops.kernel.org
Message-ID: <20141103215106.GC10501@worktop.programming.kicks-ass.net>
References: <20141103212610.GA10501@worktop.programming.kicks-ass.net>
 <20141103213442.GB27387@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103213442.GB27387@pd.tnic>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 10:34:43PM +0100, Borislav Petkov wrote:
> On Mon, Nov 03, 2014 at 10:26:10PM +0100, Peter Zijlstra wrote:
> > Hi oops.kernel.org folks,
> > 
> > I'm wanting to collect information on FW/BIOS bugs, and I figured that
> > we could use the oops.kernel.org infrastructure to do this.
> > 
> > Now, I'd prefer to not use the regular BUG/WARN because it might confuse
> > users and the stacktrace is entirely pointless -- we know were/why we
> > generate the msgs.
> > 
> > Is everything between:
> > 
> >         pr_warn("------------[ cut here ]------------\n");
> > and:
> >         pr_warn("---[ end trace %016llx ]---\n", (unsigned long long)oops_id);
> > 
> > sucked in automagically, or do we need more magic?
> 
> Btw, we have FW_{BUG,WARN,INFO} macros for exactly firmware issues.

They're more like printk prefixes, while we can continue to use them
inside the body, prefixing the actual msg, I think we need more.

Just using those will not get the data out of the machine, not have it
associated with hardware strings.

I want to know how often various FW fails still happen out there and I
want to have a list of hardware to avoid buying ;-)
