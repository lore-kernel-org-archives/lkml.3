Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaIRAbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 20:31:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:62191 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752994AbaIRAbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 20:31:38 -0400
Date: Wed, 17 Sep 2014 20:31:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140917203135.6db2ee5e@gandalf.local.home>
In-Reply-To: <20140917223633.GE2848@worktop.localdomain>
References: <20140915163740.GA12408@x4>
	<20140916105547.GA1205@quack.suse.cz>
	<20140916144252.GB32118@x4>
	<20140916111331.14303381@gandalf.local.home>
	<20140916203510.GF1205@quack.suse.cz>
	<20140916170709.73ef2993@gandalf.local.home>
	<20140916212250.GI1205@quack.suse.cz>
	<20140916173328.6306a5c2@gandalf.local.home>
	<20140917141816.GO2840@worktop.localdomain>
	<20140917102255.5cd03071@gandalf.local.home>
	<20140917223633.GE2848@worktop.localdomain>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014 00:36:33 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Sep 17, 2014 at 10:22:55AM -0400, Steven Rostedt wrote:
> > On Wed, 17 Sep 2014 16:18:16 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > By not calling console_unlock() the messages will be 'delayed', as in,
> > > we'll not call console->write() and we'll not see them, etc..
> > > 
> > > So some form of [delayed] or whatnot seems to remain appropriate.
> > > 
> > > I agree that the 'sched_' part has lived far beyond its relevance.
> > 
> > But then we should add '[delayed]' if a CPU calls printk() while
> > another CPU is printing, as printk() wont block in that case either,
> > and the output will happen some later time.
> 
> You're over thinking this. You cannot (and we don't want to) know if it
> indeed got delayed, therefore it got delayed.

I totally didn't get what you wrote.

We don't want to know if it got delayed, then the patch to remove that
print seems correct. But how did it get delayed if we don't know if it
got delayed and don't want to know?

Are my meds still that strong???

-- Steve
