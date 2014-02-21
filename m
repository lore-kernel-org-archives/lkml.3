Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaBUWoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:44:09 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52868 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbaBUWoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:44:07 -0500
Date: Fri, 21 Feb 2014 14:44:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Rik van Riel <riel@redhat.com>, davidlohr@hp.com,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] hugetlb: add hugepages_node= command-line option
In-Reply-To: <20140221223616.GG22728@two.firstfloor.org>
Message-ID: <alpine.DEB.2.02.1402211440120.20113@chino.kir.corp.google.com>
References: <20140218123013.GA20609@amt.cnet> <alpine.DEB.2.02.1402181407510.20772@chino.kir.corp.google.com> <20140220022254.GA25898@amt.cnet> <alpine.DEB.2.02.1402191941330.29913@chino.kir.corp.google.com> <20140220213407.GA11048@amt.cnet>
 <alpine.DEB.2.02.1402201502580.30647@chino.kir.corp.google.com> <20140221022800.GA30230@amt.cnet> <alpine.DEB.2.02.1402210158400.17851@chino.kir.corp.google.com> <20140221191055.GD19955@amt.cnet> <alpine.DEB.2.02.1402211358030.4682@chino.kir.corp.google.com>
 <20140221223616.GG22728@two.firstfloor.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014, Andi Kleen wrote:

> > > 2) it improves the kernel command line interface from incomplete
> > > (lacking the ability to specify node<->page correlation), to 
> > > a complete interface.
> > > 
> > 
> > If GB hugepages can be allocated dynamically, I really think we should be 
> > able to remove hugepagesz= entirely for x86 after a few years of 
> > supporting it for backwards compatibility, even though Linus has insisted 
> 
> That doesn't make any sense. Why break a perfectly fine interface?
> 

I think doing hugepagesz= and not default_hugepagesz= is more of a hack 
just because we lack support for dynamically allocating some class of 
hugepage sizes and this is the only way to currently do it; if we had 
support for doing it at runtime then that hack probably isn't needed.  You 
would still be able to do default_hugepagesz=1G and allocate a ton of them 
when fragmentation is a concern and it can only truly be done at boot.  
Even then, with such a large size it doesn't seem absolutely necessary 
since you'd either be (a) oom as a result of all those hugepages or (b) 
there would be enough memory for initscripts to do this at runtime, this 
isn't the case with 2MB.

But, like I said, I'm not sure we'd ever be able to totally remove it 
because of backwards compatibility, but the point is that nobody would 
have to use it anymore as a hack for 1GB.
