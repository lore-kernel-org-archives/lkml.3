Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaBQXXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 18:23:21 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60272 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaBQXXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:23:19 -0500
Date: Mon, 17 Feb 2014 15:23:16 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Luiz Capitulino <lcapitulino@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mtosatti@redhat.com,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        davidlohr@hp.com, isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] hugetlb: add hugepages_node= command-line option
In-Reply-To: <20140217085622.39b39cac@redhat.com>
Message-ID: <alpine.DEB.2.02.1402171518080.25724@chino.kir.corp.google.com>
References: <1392339728-13487-1-git-send-email-lcapitulino@redhat.com> <1392339728-13487-5-git-send-email-lcapitulino@redhat.com> <alpine.DEB.2.02.1402141511200.13935@chino.kir.corp.google.com> <20140214225810.57e854cb@redhat.com>
 <alpine.DEB.2.02.1402150159540.28883@chino.kir.corp.google.com> <20140217085622.39b39cac@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014, Luiz Capitulino wrote:

> hugepages= and hugepages_node= are similar, but have different semantics.
> 
> hugepagesz= and hugepages= create a pool of huge pages of the specified size.
> This means that the number of times you specify those options are limited by
> the number of different huge pages sizes an arch supports. For x86_64 for
> example, this limit is two so one would not specify those options more than
> two times. And this doesn't count default_hugepagesz=, which allows you to
> drop one hugepagesz= option.
> 
> hugepages_node= allows you to allocate huge pages per node, so the number of
> times you can specify this option is limited by the number of nodes. Also,
> hugepages_node= create the pools, if necessary (at least one will be). For
> this reason I think it makes a lot of sense to have different options.
> 

I understand you may want to add as much code as you can to the boot code 
so that you can parse all this information in short-form, and it's 
understood that it's possible to specify a different number of varying 
hugepage sizes on individual nodes, but let's come back down to reality 
here.

Lacking from your entire patchset is a specific example of what you want 
to do.  So I think we're all guessing what exactly your usecase is and we 
aren't getting any help.  Are you really suggesting that a customer wants 
to allocate 4 1GB hugepages on node 0, 12 2MB hugepages on node 0, 6 1GB 
hugepages on node 1, 24 2MB hugepages on node 1, 2 1GB hugepages on node 
2, 100 2MB hugepages on node 3, etc?  Please.

If that's actually the usecase then I'll renew my objection to the entire 
patchset and say you want to add the ability to dynamically allocate 1GB 
pages and free them at runtime early in initscripts.  If something is 
going to be added to init code in the kernel then it better be trivial 
since all this can be duplicated in userspace if you really want to be 
fussy about it.
