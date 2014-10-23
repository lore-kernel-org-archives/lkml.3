Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaJWMje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:39:34 -0400
Received: from mta-out1.inet.fi ([62.71.2.194]:54863 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386AbaJWMjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:39:32 -0400
Date: Thu, 23 Oct 2014 15:36:16 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, akpm@linux-foundation.org, riel@redhat.com,
        mgorman@suse.de, oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        laijs@cn.fujitsu.com, dave@stgolabs.net, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 3/6] mm: VMA sequence count
Message-ID: <20141023123616.GA8809@node.dhcp.inet.fi>
References: <20141020215633.717315139@infradead.org>
 <20141020222841.361741939@infradead.org>
 <20141022112657.GG30588@node.dhcp.inet.fi>
 <20141022113951.GB21513@worktop.programming.kicks-ass.net>
 <20141022115304.GA31486@node.dhcp.inet.fi>
 <20141022121554.GD21513@worktop.programming.kicks-ass.net>
 <20141022134416.GA15602@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022134416.GA15602@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 03:44:16PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 22, 2014 at 02:15:54PM +0200, Peter Zijlstra wrote:
> > On Wed, Oct 22, 2014 at 02:53:04PM +0300, Kirill A. Shutemov wrote:
> > > Em, no. In this case change_protection() will not touch the pte, since
> > > it's pte_none() and the pte_same() check will pass just fine.
> > 
> > Oh, that's what you meant. Yes that's a problem, yes vm_page_prot
> > needs wrapping too.
> 
> Maybe also vm_policy, is there anything else that can change while a vma
> lives?

 - vm_flags, obviously;
 - shared, anon_vma and anon_vma_chain (at least on the first write fault
   to private mapping);
 - vm_pgoff (mremap(2) ?);
 - vm_private_data -- it's all over drivers. Potential nightmare, but
   seems not in use for anon mappings.

-- 
 Kirill A. Shutemov
