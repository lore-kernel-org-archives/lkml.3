Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaBTQIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:08:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbaBTQIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:08:34 -0500
Date: Thu, 20 Feb 2014 10:06:03 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        davidlohr@hp.com, isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] hugetlb: add hugepages_node= command-line option
Message-ID: <20140220100603.76622b33@redhat.com>
In-Reply-To: <alpine.DEB.2.02.1402192048240.2568@chino.kir.corp.google.com>
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
 <20140219234232.07dc1eab@redhat.com>
 <alpine.DEB.2.02.1402192048240.2568@chino.kir.corp.google.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014 20:51:55 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 19 Feb 2014, Luiz Capitulino wrote:
> 
> > > Yes, my concrete objection is that the command line interface is 
> > > unnecessary if you can dynamically allocate and free 1GB pages at runtime 
> > > unless memory will be so fragmented that it cannot be done when userspace 
> > > is brought up.  That is not your use case, thus this support is not 
> > 
> > Yes it is. The early boot is the most reliable moment to allocate huge pages
> > and we want to take advantage from that.
> > 
> 
> Your use case is 8GB of hugepages on a 32GB machine.  It shouldn't be 
> necessary to do that at boot.

That's shortsighted because it's tied to a particular machine. The same
customer asked for more flexibility, too.

Look, we're also looking forward to allocating 1G huge pages from user-space.
We actually agree here. What we're suggesting is having _both_, the
command-line option (which offers higher reliability and is a low hanging
fruit right now) _and_ later we add support to allocate 1G huge pages from
user-space. No loss here, that's the maximum benefit for all users.
