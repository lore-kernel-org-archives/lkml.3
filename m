Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbaBTXR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 18:17:58 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:51154 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaBTXR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:17:57 -0500
Date: Thu, 20 Feb 2014 15:17:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Marcelo Tosatti <mtosatti@redhat.com>
cc: Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        davidlohr@hp.com, isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] hugetlb: add hugepages_node= command-line option
In-Reply-To: <20140220213854.GB11486@amt.cnet>
Message-ID: <alpine.DEB.2.02.1402201516140.30647@chino.kir.corp.google.com>
References: <1392339728-13487-5-git-send-email-lcapitulino@redhat.com> <alpine.DEB.2.02.1402141511200.13935@chino.kir.corp.google.com> <20140214225810.57e854cb@redhat.com> <alpine.DEB.2.02.1402150159540.28883@chino.kir.corp.google.com> <20140217085622.39b39cac@redhat.com>
 <alpine.DEB.2.02.1402171518080.25724@chino.kir.corp.google.com> <20140218123013.GA20609@amt.cnet> <alpine.DEB.2.02.1402181407510.20772@chino.kir.corp.google.com> <20140220022254.GA25898@amt.cnet> <alpine.DEB.2.02.1402191941330.29913@chino.kir.corp.google.com>
 <20140220213854.GB11486@amt.cnet>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Marcelo Tosatti wrote:

> > I'm not sure it's interesting to talk about since this patchset is 
> > unnecessary if you can do it at runtime, but since "hugepagesz=" and 
> > "hugepages=" have existed for many kernel releases, we must maintain 
> > backwards compatibility.  Thus, it seems, the easiest addition would have 
> > been "hugepagesnode=" which I've mentioned several times, there's no 
> > reason to implement yet another command line option purely as a shorthand 
> > which hugepage_node=1:2:1G is and in a very cryptic way.
> 
> There is one point from Davidlohr Bueso in favour of the proposed
> command line interface. Did you consider that aspect?
> 

I did before he posted it, in 
http://marc.info/?l=linux-kernel&m=139267940609315.  I don't think "large 
machines" open up the use case for 4 1GB hugepages on node 0, 12 2MB 
hugepages on node 0, 6 1GB hugepages on node 1, 24 2MB hugepages on node 
1, 2 1GB hugepages on node 2, 100 2MB hugepages on node 3, etc.
