Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaCKQ2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:28:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbaCKQ2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:28:49 -0400
Date: Tue, 11 Mar 2014 16:28:45 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>, Sasha Levin <sasha.levin@oracle.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, hhuang@redhat.com,
        knoel@redhat.com, aarcange@redhat.com
Subject: Re: [PATCH -mm] mm,numa,mprotect: always continue after finding a
 stable thp page
Message-ID: <20140311162845.GA30604@suse.de>
References: <5318E4BC.50301@oracle.com>
 <20140306173137.6a23a0b2@cuia.bos.redhat.com>
 <5318FC3F.4080204@redhat.com>
 <20140307140650.GA1931@suse.de>
 <20140307150923.GB1931@suse.de>
 <20140307182745.GD1931@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140307182745.GD1931@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 06:27:45PM +0000, Mel Gorman wrote:
> > This is a completely untested prototype. It rechecks pmd_trans_huge
> > under the lock and falls through if it hit a parallel split. It's not
> > perfect because it could decide to fall through just because there was
> > no prot_numa work to do but it's for illustration purposes. Secondly,
> > I noted that you are calling invalidate for every pmd range. Is that not
> > a lot of invalidations? We could do the same by just tracking the address
> > of the first invalidation.
> > 
> 
> And there were other minor issues. This is still untested but Sasha,
> can you try it out please? I discussed this with Rik on IRC for a bit and
> reckon this should be sufficient if the correct race has been identified.
> 

Any luck with this patch Sasha? It passed basic tests here but I had not
seen the issue trigger either.

-- 
Mel Gorman
SUSE Labs
