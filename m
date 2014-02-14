Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaBNEct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:32:49 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:56523 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbaBNEcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:32:46 -0500
Date: Thu, 13 Feb 2014 20:32:35 -0800
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
Message-ID: <20140214043235.GA21999@linux.vnet.ibm.com>
References: <52F88C16.70204@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402100200420.30650@chino.kir.corp.google.com>
 <52F8C556.6090006@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402101333160.15624@chino.kir.corp.google.com>
 <52FC6F2A.30905@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402130003320.11689@chino.kir.corp.google.com>
 <52FC98A6.1000701@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402131416430.13899@chino.kir.corp.google.com>
 <20140214001438.GB1651@linux.vnet.ibm.com>
 <CA+55aFwH8BqyLSqyLL7g-08nOtnOrJ9vKj4ebiSqrxc5ooEjLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwH8BqyLSqyLL7g-08nOtnOrJ9vKj4ebiSqrxc5ooEjLw@mail.gmail.com>
X-Operating-System: Linux 3.11.0-15-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021404-9332-0000-0000-0000031A7717
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 13.02.2014 [16:37:53 -0800], Linus Torvalds wrote:
> Is this whole thread still just for the crazy and pointless
> "max_sane_readahead()"?
> 
> Or is there some *real* reason we should care?

There is an open issue on powerpc with memoryless nodes (inasmuch as we
can have them, but the kernel doesn't support it properly). There is a
separate discussion going on on linuxppc-dev about what is necessary for
CONFIG_HAVE_MEMORYLESS_NODES to be supported.

> Because if it really is just for max_sane_readahead(), then for the
> love of God, let us just do this
> 
>  unsigned long max_sane_readahead(unsigned long nr)
>  {
>         return min(nr, 128);
>  }
> 
> and bury this whole idiotic thread.

Agreed that for the readahead case the above is probably more than
sufficient.

Apologies for hijacking the thread, my comments below were purely about
the memoryless node support, not about readahead specifically.

Thanks,
Nish

> Seriously, if your IO subsystem needs more than 512kB of read-ahead to
> get full performance, your IO subsystem is just bad, and has latencies
> that are long enough that you should just replace it. There's no real
> reason to bend over backwards for that, and the whole complexity and
> fragility of the insane "let's try to figure out how much memory this
> node has" is just not worth it. The read-ahead should be small enough
> that we should never need to care, and large enough that you get
> reasonable IO throughput. The above does that.
> 
> Goddammit, there's a reason the whole "Gordian knot" parable is
> famous. We're making this all too damn complicated FOR NO GOOD REASON.
> 
> Just cut the rope, people. Our aim is not to generate some kind of job
> security by making things as complicated as possible.
> 
>                  Linus
> 
> On Thu, Feb 13, 2014 at 4:14 PM, Nishanth Aravamudan
> <nacc@linux.vnet.ibm.com> wrote:
> >
> > I'm working on this latter bit now. I tried to mirror ia64, but it looks
> > like they have CONFIG_USER_PERCPU_NUMA_NODE_ID, which powerpc doesn't.
> > It seems like CONFIG_USER_PERCPU_NUMA_NODE_ID and
> > CONFIG_HAVE_MEMORYLESS_NODES should be tied together in Kconfig?
> >
> > I'll keep working, but would appreciate any further insight.
> >
> > -Nish
> >
> 

