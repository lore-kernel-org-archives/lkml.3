Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaBTEos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 23:44:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbaBTEor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 23:44:47 -0500
Date: Wed, 19 Feb 2014 23:42:32 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        davidlohr@hp.com, isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] hugetlb: add hugepages_node= command-line option
Message-ID: <20140219234232.07dc1eab@redhat.com>
In-Reply-To: <alpine.DEB.2.02.1402191941330.29913@chino.kir.corp.google.com>
References: <1392339728-13487-1-git-send-email-lcapitulino@redhat.com>
	<1392339728-13487-5-git-send-email-lcapitulino@redhat.com>
	<alpine.DEB.2.02.1402141511200.13935@chino.kir.corp.google.com>
	<20140214225810.57e854cb@redhat.com>
	<alpine.DEB.2.02.1402150159540.28883@chino.kir.corp.google.com>
	<20140217085622.39b39cac@redhat.com>
	<alpine.DEB.2.02.1402171518080.25724@chino.kir.corp.google.com>
	<20140218123013.GA20609@amt.cnet>
	<alpine.DEB.2.02.1402181407510.20772@chino.kir.corp.google.com>
	<20140220022254.GA25898@amt.cnet>
	<alpine.DEB.2.02.1402191941330.29913@chino.kir.corp.google.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014 19:46:41 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 19 Feb 2014, Marcelo Tosatti wrote:
> 
> > We agree that, in the future, we'd like to provide the ability to
> > dynamically allocate and free 1GB pages at runtime.
> > 
> > Extending the kernel command line interface is a first step.
> > 
> > Do you have a concrete objection to that first step ?
> > 
> 
> Yes, my concrete objection is that the command line interface is 
> unnecessary if you can dynamically allocate and free 1GB pages at runtime 
> unless memory will be so fragmented that it cannot be done when userspace 
> is brought up.  That is not your use case, thus this support is not 

Yes it is. The early boot is the most reliable moment to allocate huge pages
and we want to take advantage from that.

I would understand your position against this series if it was intrusive
or if it was changing the code in an undesirable way, but the code it adds
is completely self-contained and runs only once at boot. It gives us just
one more choice for huge pages allocation at boot. I don't see the huge
problem here.

> needed.  I think Mel also brought up this point.
>
> There's no "first step" about it, this is unnecessary for your use case if 
> you can do it at runtime.  I'm not sure what's so surprising about this.
> 
> > > You can't specify an interleave behavior with Luiz's command line 
> > > interface so now we'd have two different interfaces for allocating 
> > > hugepage sizes depending on whether you're specifying a node or not.  
> > > It's "hugepagesz=1G hugepages=16" vs "hugepage_node=1:16:1G" (and I'd have 
> > > to look at previous messages in this thread to see if that means 16 1GB 
> > > pages on node 1 or 1 1GB pages on node 16.)
> > 
> > What syntax do you prefer and why ?
> > 
> 
> I'm not sure it's interesting to talk about since this patchset is 
> unnecessary if you can do it at runtime, but since "hugepagesz=" and 
> "hugepages=" have existed for many kernel releases, we must maintain 
> backwards compatibility.  Thus, it seems, the easiest addition would have 
> been "hugepagesnode=" which I've mentioned several times, there's no 
> reason to implement yet another command line option purely as a shorthand 
> which hugepage_node=1:2:1G is and in a very cryptic way.
> 

