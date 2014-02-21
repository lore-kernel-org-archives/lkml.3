Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaBUWEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:04:08 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:47055 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaBUWEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:04:06 -0500
Date: Fri, 21 Feb 2014 14:04:03 -0800 (PST)
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
In-Reply-To: <20140221191055.GD19955@amt.cnet>
Message-ID: <alpine.DEB.2.02.1402211358030.4682@chino.kir.corp.google.com>
References: <20140217085622.39b39cac@redhat.com> <alpine.DEB.2.02.1402171518080.25724@chino.kir.corp.google.com> <20140218123013.GA20609@amt.cnet> <alpine.DEB.2.02.1402181407510.20772@chino.kir.corp.google.com> <20140220022254.GA25898@amt.cnet>
 <alpine.DEB.2.02.1402191941330.29913@chino.kir.corp.google.com> <20140220213407.GA11048@amt.cnet> <alpine.DEB.2.02.1402201502580.30647@chino.kir.corp.google.com> <20140221022800.GA30230@amt.cnet> <alpine.DEB.2.02.1402210158400.17851@chino.kir.corp.google.com>
 <20140221191055.GD19955@amt.cnet>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014, Marcelo Tosatti wrote:

> > I agree that your customer wants a non-default distribution of 1GB 
> > hugepages, yes, that's clear.  The questions that have not been answered: 
> > why must it be done this way as opposed to runtime?  If 1GB hugepages 
> > could be dynamically allocated, would your customer be able to use it?  If 
> > not, why not?  If dynamic allocation resolves all the issues, then is this 
> > patchset a needless maintenance burden if we had such support today?
> 
> It must be done this way because:
> 
> 1) its the only interface which is easily backportable.
> 

There's no pending patchset that adds dynamic allocation of GB hugepages 
so you can't comment on what is easily backportable and which isn't.

> 2) it improves the kernel command line interface from incomplete
> (lacking the ability to specify node<->page correlation), to 
> a complete interface.
> 

If GB hugepages can be allocated dynamically, I really think we should be 
able to remove hugepagesz= entirely for x86 after a few years of 
supporting it for backwards compatibility, even though Linus has insisted 
that we never break userspace in the past (which should discourage us 
from adding additional command line interfaces which are obsoleted in the 
future, such as in this case).

Still waiting on an answer to whether your customer would be able to 
dynamically allocate 1GB hugepages at runtime if we had such support and, 
if not, please show why not?
