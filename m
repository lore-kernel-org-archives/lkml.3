Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbaHANfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:35:33 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58107 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301AbaHANf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:35:26 -0400
Date: Fri, 1 Aug 2014 09:34:44 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch 2/3] mm, oom: remove unnecessary check for NULL zonelist
Message-ID: <20140801133444.GH9952@cmpxchg.org>
References: <alpine.DEB.2.02.1407231814110.22326@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1407231815090.22326@chino.kir.corp.google.com>
 <20140731152659.GB9952@cmpxchg.org>
 <alpine.DEB.2.02.1408010159500.4061@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1408010159500.4061@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 02:10:37AM -0700, David Rientjes wrote:
> On Thu, 31 Jul 2014, Johannes Weiner wrote:
> 
> > out_of_memory() wants the zonelist that was used during allocation,
> > not just the random first node's zonelist that's simply picked to
> > serialize page fault OOM kills system-wide.
> > 
> > This would even change how panic_on_oom behaves for page fault OOMs
> > (in a completely unpredictable way) if we get CONSTRAINED_CPUSET.
> > 
> > This change makes no sense to me.
> > 
> 
> Allocations during fault will be constrained by the cpuset's mems, if we 
> are oom then why would we panic when panic_on_oom == 1?

Can you please address the concerns I raised?

And please describe user-visible changes in the changelog.
