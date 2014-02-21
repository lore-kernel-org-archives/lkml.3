Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaBUXyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:54:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaBUXyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:54:24 -0500
Date: Fri, 21 Feb 2014 15:54:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: David Rientjes <rientjes@google.com>,
        Luiz Capitulino <lcapitulino@redhat.com>, mtosatti@redhat.com,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] hugetlb: add hugepages_node= command-line option
Message-Id: <20140221155423.6c6689e27fa10ed394f01843@linux-foundation.org>
In-Reply-To: <1392702456.2468.4.camel@buesod1.americas.hpqcorp.net>
References: <1392339728-13487-1-git-send-email-lcapitulino@redhat.com>
	<1392339728-13487-5-git-send-email-lcapitulino@redhat.com>
	<alpine.DEB.2.02.1402141511200.13935@chino.kir.corp.google.com>
	<20140214225810.57e854cb@redhat.com>
	<alpine.DEB.2.02.1402150159540.28883@chino.kir.corp.google.com>
	<1392702456.2468.4.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014 21:47:36 -0800 Davidlohr Bueso <davidlohr@hp.com> wrote:

> > How is that difficult?  hugepages= is the "noun", hugepagesz= is the 
> > "adjective".  hugepages=100 hugepagesz=1G hugepages=4 makes perfect sense 
> > to me, and I actually don't allocate hugepages on the command line, nor 
> > have I looked at Documentation/kernel-parameters.txt to check if I'm 
> > constructing it correctly.  It just makes sense and once you learn it it's 
> > just natural.
> 
> This can get annoying _really_ fast for larger systems.

Yes, I do prefer the syntax Luiz is proposing.

But I think it would be better if it made hugepages= and hugepagesz=
obsolete, so we can emit a printk if people use those, telling them
to migrate because the old options are going away.

Something like

	hugepages_node=1:4:1G

and

	hugepages_node=:16:1G

?
