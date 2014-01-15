Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaAOPWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:22:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbaAOPWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:22:22 -0500
Date: Wed, 15 Jan 2014 15:22:18 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        Han Pingtian <hanpt@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
Message-ID: <20140115152218.GL4963@suse.de>
References: <20140103033303.GB4106@localhost.localdomain>
 <52C6FED2.7070700@intel.com>
 <20140105003501.GC4106@localhost.localdomain>
 <20140106164604.GC27602@dhcp22.suse.cz>
 <20140108101611.GD27937@dhcp22.suse.cz>
 <20140110081744.GC9437@dhcp22.suse.cz>
 <20140114200720.GM4106@localhost.localdomain>
 <20140114155241.7891fce1fb2b9dfdcde15a8c@linux-foundation.org>
 <alpine.DEB.2.02.1401141621560.3375@chino.kir.corp.google.com>
 <20140114163533.ab191e118e82ca7b4d499551@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140114163533.ab191e118e82ca7b4d499551@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 04:35:33PM -0800, Andrew Morton wrote:
> > Would it be overkill to save the kernel default both with and without thp 
> > and then doing a WARN_ON_ONCE() if a user-written value is ever less?
> 
> Well, min_free_kbytes is a userspace thing, not a kernel thing - maybe
> THP shouldn't be dinking with it.  What effect is THP trying to achieve
> and can we achieve it by other/better means?

It moved logic from hugeadm where few people knew about it to the
kernel. The value is related to anti-fragmentation. With the recommended
setting the probability of mixing pages of different mobility within a
single pageblock is reduced. Very very superficially, it reduces the
number of instances the mm_page_alloc_extfrag tracepoint is triggered
with parameters that are considered to be severely fragmenting.

-- 
Mel Gorman
SUSE Labs
