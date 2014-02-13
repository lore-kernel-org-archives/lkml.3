Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaBMVmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:42:35 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36473 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbaBMVmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:42:22 -0500
Date: Thu, 13 Feb 2014 13:42:11 -0800
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
Message-ID: <20140213214211.GC12409@linux.vnet.ibm.com>
References: <alpine.DEB.2.02.1402061557210.5061@chino.kir.corp.google.com>
 <52F4B8A4.70405@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402071239301.4212@chino.kir.corp.google.com>
 <52F88C16.70204@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402100200420.30650@chino.kir.corp.google.com>
 <52F8C556.6090006@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402101333160.15624@chino.kir.corp.google.com>
 <52FC6F2A.30905@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402130003320.11689@chino.kir.corp.google.com>
 <20140213130643.0cf5fb083056cdd159d1aac4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140213130643.0cf5fb083056cdd159d1aac4@linux-foundation.org>
X-Operating-System: Linux 3.11.0-15-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021321-5806-0000-0000-000024216401
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.02.2014 [13:06:43 -0800], Andrew Morton wrote:
> On Thu, 13 Feb 2014 00:05:31 -0800 (PST) David Rientjes <rientjes@google.com> wrote:
> 
> > On Thu, 13 Feb 2014, Raghavendra K T wrote:
> > 
> > > I was able to test (1) implementation on the system where readahead problem
> > > occurred. Unfortunately it did not help.
> > > 
> > > Reason seem to be that CONFIG_HAVE_MEMORYLESS_NODES dependency of
> > > numa_mem_id(). The PPC machine I am facing problem has topology like
> > > this:
> > > 
> > > numactl -H
> > > ---------
> > > available: 2 nodes (0-1)
> > > node 0 cpus: 0 1 2 3 4 5 6 7 12 13 14 15 16 17 18 19 20 21 22 23 24 25
> > > ...
> > > node 0 size: 0 MB
> > > node 0 free: 0 MB
> > > node 1 cpus: 8 9 10 11 32 33 34 35 ...
> > > node 1 size: 8071 MB
> > > node 1 free: 2479 MB
> > > node distances:
> > > node   0   1
> > >   0:  10  20
> > >   1:  20  10
> > > 
> > > So it seems numa_mem_id() does not help for all the configs..
> > > Am I missing something ?
> > > 
> > 
> > You need the patch from http://marc.info/?l=linux-mm&m=139093411119013 
> > first.
> 
> That (un-signed-off) powerpc patch appears to be moribund.  What's up?

Gah, thanks for catching that Andrew, not sure what went wrong. I've
appended my S-o-b. I've asked Ben to take a look, but I think he's still
catching up on his queue after travelling.

-Nish

