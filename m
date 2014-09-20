Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaITQaG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:30:06 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:31982 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752688AbaITQaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:30:04 -0400
Date: Sat, 20 Sep 2014 12:30:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140920123001.4ac60dba@gandalf.local.home>
In-Reply-To: <1411229447.24444.53.camel@joe-AO725>
References: <20140916203510.GF1205@quack.suse.cz>
	<20140916170709.73ef2993@gandalf.local.home>
	<20140916212250.GI1205@quack.suse.cz>
	<20140916173328.6306a5c2@gandalf.local.home>
	<20140917141816.GO2840@worktop.localdomain>
	<20140917102255.5cd03071@gandalf.local.home>
	<20140917223633.GE2848@worktop.localdomain>
	<20140917203135.6db2ee5e@gandalf.local.home>
	<20140918173414.GU2840@worktop.localdomain>
	<20140920051224.GA5573@quack.suse.cz>
	<20140920154733.GM2832@worktop.localdomain>
	<1411229447.24444.53.camel@joe-AO725>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2014 09:10:47 -0700
Joe Perches <joe@perches.com> wrote:

> On Sat, 2014-09-20 at 17:47 +0200, Peter Zijlstra wrote:
> > On a whole, printk() is entirely useless for debugging these days, its
> > far too fragile/unreliable to be taken seriously so I really don't care
> > on that point either.
> 
> That's unfortunate.
> 
> Care to enumerate the issues that you believe make
> printk too fragile/unreliable for debugging?

I seldom use printk these days. It's far too limited in its uses. For
one, most things worth debugging happen thousands of times a second,
and printk will just slow things down to a crawl if it is used.
Another, is that it can not be used in most critical sections (NMI
handlers and anything that deals with the scheduler). Also, as it no
longer blocks when another CPU is doing a printk, a bug can happen
which crashes the system and the output of that bug will never get
printed due to the delayed output from another CPU having the console
lock.

-- Steve
