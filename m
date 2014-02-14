Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaBNXO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 18:14:26 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41160 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaBNXOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 18:14:25 -0500
Date: Fri, 14 Feb 2014 15:14:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Luiz Capitulino <lcapitulino@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mtosatti@redhat.com, mgorman@suse.de,
        aarcange@redhat.com, andi@firstfloor.org, riel@redhat.com,
        davidlohr@hp.com, isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org
Subject: Re: [PATCH 4/4] hugetlb: add hugepages_node= command-line option
In-Reply-To: <1392339728-13487-5-git-send-email-lcapitulino@redhat.com>
Message-ID: <alpine.DEB.2.02.1402141511200.13935@chino.kir.corp.google.com>
References: <1392339728-13487-1-git-send-email-lcapitulino@redhat.com> <1392339728-13487-5-git-send-email-lcapitulino@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb 2014, Luiz Capitulino wrote:

> From: Luiz capitulino <lcapitulino@redhat.com>
> 
> The HugeTLB command-line option hugepages= allows a user to specify how
> many huge pages should be allocated at boot. This option is needed because
> it improves reliability when allocating 1G huge pages, which are better
> allocated as early as possible due to fragmentation.
> 
> However, hugepages= has a limitation. On NUMA systems, hugepages= will
> automatically distribute memory allocation equally among nodes. For
> example, if you have a 2-node NUMA system and allocate 200 huge pages,
> than hugepages= will try to allocate 100 huge pages from node0 and 100
> from node1.
> 
> This is very unflexible, as it doesn't allow you to specify which nodes
> the huge pages should be allocated from. For example, there are use-cases
> where the user wants to specify that a 1GB huge page should be allocated
> from node 2 or that 300 2MB huge pages should be allocated from node 0.
> 
> The hugepages_node= command-line option introduced by this commit allows
> just that.
> 
> The syntax is:
> 
>   hugepages_node=nid:nr_pages:size,...
> 

Again, I think this syntax is horrendous and doesn't couple well with the 
other hugepage-related kernel command line options.  We already have 
hugepages= and hugepagesz= which you can interleave on the command line to 
get 100 2M hugepages and 10 1GB hugepages, for example.

This patchset is simply introducing another variable to the matter: the 
node that the hugepages should be allocated on.  So just introduce a 
hugepagesnode= parameter to couple with the others so you can do

	hugepagesz=<size> hugepagesnode=<nid> hugepages=<#>

instead of having completely confusing interfaces where you want to do 
hugepages_node=1:1:1G for a 1GB hugepage on page 1 (and try remembering 
which "1" means what, yuck) and "hugepagesz=1GB hugepages=1" if you're 
indifferent to the node.
