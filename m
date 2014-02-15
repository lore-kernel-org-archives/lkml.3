Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaBOKGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:06:46 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:32797 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaBOKGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:06:43 -0500
Date: Sat, 15 Feb 2014 02:06:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Luiz Capitulino <lcapitulino@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mtosatti@redhat.com,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        davidlohr@hp.com, isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] hugetlb: add hugepages_node= command-line option
In-Reply-To: <20140214225810.57e854cb@redhat.com>
Message-ID: <alpine.DEB.2.02.1402150159540.28883@chino.kir.corp.google.com>
References: <1392339728-13487-1-git-send-email-lcapitulino@redhat.com> <1392339728-13487-5-git-send-email-lcapitulino@redhat.com> <alpine.DEB.2.02.1402141511200.13935@chino.kir.corp.google.com> <20140214225810.57e854cb@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014, Luiz Capitulino wrote:

> > Again, I think this syntax is horrendous and doesn't couple well with the 
> > other hugepage-related kernel command line options.  We already have 
> > hugepages= and hugepagesz= which you can interleave on the command line to 
> > get 100 2M hugepages and 10 1GB hugepages, for example.
> > 
> > This patchset is simply introducing another variable to the matter: the 
> > node that the hugepages should be allocated on.  So just introduce a 
> > hugepagesnode= parameter to couple with the others so you can do
> > 
> > 	hugepagesz=<size> hugepagesnode=<nid> hugepages=<#>
> 
> That was my first try but it turned out really bad. First, for every node
> you specify you need three options.

Just like you need two options today to specify a number of hugepages of a 
particular non-default size.  You only need to use hugepagesz= or 
hugepagenode= if you want a non-default size or a specify a particular 
node.

> So, if you want to setup memory for
> three nodes you'll need to specify nine options.

And you currently need six if you want to specify three different hugepage 
sizes (?).  But who really specifies three different hugepage sizes on the 
command line that are needed to be reserved at boot?

If that's really the usecase, it seems like you want the old 
CONFIG_PAGE_SHIFT patch.

> And it gets worse, because
> hugepagesz= and hugepages= have strict ordering (which is a mistake, IMHO) so
> you have to specify them in the right order otherwise things don't work as
> expected and you have no idea why (have been there myself).
> 

How is that difficult?  hugepages= is the "noun", hugepagesz= is the 
"adjective".  hugepages=100 hugepagesz=1G hugepages=4 makes perfect sense 
to me, and I actually don't allocate hugepages on the command line, nor 
have I looked at Documentation/kernel-parameters.txt to check if I'm 
constructing it correctly.  It just makes sense and once you learn it it's 
just natural.

> IMO, hugepages_node=<nid>:<nr_pages>:<size>,... is good enough. It's concise,
> and don't depend on any other option to function. Also, there are lots of other
> kernel command-line options that require you to specify multiple fields, so
> it's not like hugepages_node= is totally different in that regard.
> 

I doubt Andrew is going to want a completely different format for hugepage 
allocations that want to specify a node and have to deal with people who 
say hugepages_node=2:1:1G and constantly have to lookup if it's 2 
hugepages on node 1 or 1 hugepage on node 2.
