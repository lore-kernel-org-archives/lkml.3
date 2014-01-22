Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbaAVJlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:41:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbaAVJk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:40:58 -0500
Date: Wed, 22 Jan 2014 09:40:53 +0000
From: Mel Gorman <mgorman@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC] restore user defined min_free_kbytes when disabling thp
Message-ID: <20140122094053.GT4963@suse.de>
References: <20140121093859.GA7546@localhost.localdomain>
 <20140121102351.GD4963@suse.de>
 <20140122060506.GA2657@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140122060506.GA2657@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 02:05:06PM +0800, Han Pingtian wrote:
> On Tue, Jan 21, 2014 at 10:23:51AM +0000, Mel Gorman wrote:
> > On Tue, Jan 21, 2014 at 05:38:59PM +0800, Han Pingtian wrote:
> > > The testcase 'thp04' of LTP will enable THP, do some testing, then
> > > disable it if it wasn't enabled. But this will leave a different value
> > > of min_free_kbytes if it has been set by admin. So I think it's better
> > > to restore the user defined value after disabling THP.
> > > 
> > 
> > Then have LTP record what min_free_kbytes was at the same time THP was
> > enabled by the test and restore both settings. It leaves a window where
> > an admin can set an alternative value during the test but that would also
> > invalidate the test in same cases and gets filed under "don't do that".
> > 
> 
> Because the value is changed in kernel, so it would be better to 
> restore it in kernel, right? :)  I have a v2 patch which will restore
> the value only if it isn't set again by user after THP's initialization.
> This v2 patch is dependent on the patch 'mm: show message when updating
> min_free_kbytes in thp' which has been added to -mm tree, can be found
> here:
> 

It still feels like the type of scenario that only shows up during tests
that modify kernel parameters as part of the test. I do not consider it
normal operation for THP to be enabled and disabled multiple types during
the lifetime of the system. If the system started with THP disabled, ran
for a long period of time then the benefit of having min_free_kbytes at
a higher value is already lost due to the system being potentially in a
fragmented state already.

I'm ok with the warning being displayed if min_free_kbytes is updated
but I'm not convinced that further trickery is necessary.

-- 
Mel Gorman
SUSE Labs
