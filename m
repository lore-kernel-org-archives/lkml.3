Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaAHKQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:16:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008AbaAHKQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:16:13 -0500
Date: Wed, 8 Jan 2014 11:16:11 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
Message-ID: <20140108101611.GD27937@dhcp22.suse.cz>
References: <20140101002935.GA15683@localhost.localdomain>
 <52C5AA61.8060701@intel.com>
 <20140103033303.GB4106@localhost.localdomain>
 <52C6FED2.7070700@intel.com>
 <20140105003501.GC4106@localhost.localdomain>
 <20140106164604.GC27602@dhcp22.suse.cz>
 <20140108082000.GJ4106@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108082000.GJ4106@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08-01-14 16:20:01, Han Pingtian wrote:
> On Mon, Jan 06, 2014 at 05:46:04PM +0100, Michal Hocko wrote:
> > On Sun 05-01-14 08:35:01, Han Pingtian wrote:
> > [...]
> > > From f4d085a880dfae7638b33c242554efb0afc0852b Mon Sep 17 00:00:00 2001
> > > From: Han Pingtian <hanpt@linux.vnet.ibm.com>
> > > Date: Fri, 3 Jan 2014 11:10:49 +0800
> > > Subject: [PATCH] mm: show message when raising min_free_kbytes in THP
> > > 
> > > min_free_kbytes may be raised during THP's initialization. Sometimes,
> > > this will change the value being set by user. Showing message will
> > > clarify this confusion.
> > 
> > I do not have anything against informing about changing value
> > set by user but this will inform also when the default value is
> > updated. Is this what you want? Don't you want to check against
> > user_min_free_kbytes? (0 if not set by user)
> > 
> 
> To use user_min_free_kbytes in mm/huge_memory.c, we need a 
> 
>     extern int user_min_free_kbytes;

The variable is not defined as static so you can use it outside of
mm/page_alloc.c.

> in somewhere? Where should we put it? I guess it is mm/internal.h,
> right?

I do not think this has to be globaly visible though. Why not just
extern declaration in mm/huge_memory.c?

-- 
Michal Hocko
SUSE Labs
