Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaAKD1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 22:27:20 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:44944 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaAKD1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 22:27:17 -0500
Date: Sat, 11 Jan 2014 11:27:08 +0800
From: Han Pingtian <hanpt@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] mm: show message when updating min_free_kbytes in thp
Message-ID: <20140111032708.GL4106@localhost.localdomain>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
	linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>,
	Michal Hocko <mhocko@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
References: <52C5AA61.8060701@intel.com>
 <20140103033303.GB4106@localhost.localdomain>
 <52C6FED2.7070700@intel.com>
 <20140105003501.GC4106@localhost.localdomain>
 <20140106164604.GC27602@dhcp22.suse.cz>
 <20140108101611.GD27937@dhcp22.suse.cz>
 <20140110081744.GC9437@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110081744.GC9437@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011103-9332-0000-0000-000002BA3B9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 09:17:44AM +0100, Michal Hocko wrote:
> On Fri 10-01-14 00:13:44, Andrew Morton wrote:
> > On Fri, 10 Jan 2014 09:05:04 +0100 Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > > > --- a/mm/huge_memory.c
> > > > > +++ b/mm/huge_memory.c
> > > > > @@ -100,6 +100,7 @@ static struct khugepaged_scan khugepaged_scan = {
> > > > >  	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
> > > > >  };
> > > > >  
> > > > > +extern int user_min_free_kbytes;
> > > > >  
> > > > 
> > > > We don't add extern declarations to .c files.  How many other examples of 
> > > > this can you find in mm/?
> > > 
> > > I have suggested this because general visibility is not needed.
> > 
> > It's best to use a common declaration which is seen by the definition
> > site and all references, so everyone agrees on the variable's type. 
> > Otherwise we could have "long foo;" in one file and "extern char foo;"
> > in another and the compiler won't tell us.  I think the linker could
> > tell us, but it doesn't, afaik.  Perhaps there's an option...
> > 
> > > But if
> > > you think that it should then include/linux/mm.h sounds like a proper
> > > place.
> > 
> > mm/internal.h might suit.
> 
> min_free_kbytes is in mm.h so I thought having them together would be
> appropriate.
> 

At present, we only use user_min_free_kbytes in memory subsystem. So I
think mm/internal.h is suit.

Thanks.

