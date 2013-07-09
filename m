Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab3GIR5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:57:37 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:47248 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3GIR5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:57:35 -0400
Date: Tue, 9 Jul 2013 21:57:29 +0400
From: Glauber Costa <glommer@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Dave Chinner <david@fromorbit.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: slab shrinkers: BUG at mm/list_lru.c:92
Message-ID: <20130709175632.GC9188@localhost.localdomain>
References: <20130701075005.GA28765@dhcp22.suse.cz>
 <20130701081056.GA4072@dastard>
 <20130702092200.GB16815@dhcp22.suse.cz>
 <20130702121947.GE14996@dastard>
 <20130702124427.GG16815@dhcp22.suse.cz>
 <20130703112403.GP14996@dastard>
 <20130704163643.GF7833@dhcp22.suse.cz>
 <20130708125352.GC20149@dhcp22.suse.cz>
 <20130709173242.GA9098@localhost.localdomain>
 <20130709105032.f9acb85a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709105032.f9acb85a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 10:50:32AM -0700, Andrew Morton wrote:
> On Tue, 9 Jul 2013 21:32:51 +0400 Glauber Costa <glommer@gmail.com> wrote:
> 
> > > $ dmesg | grep "blocked for more than"
> > > [276962.652076] INFO: task xfs-data/sda9:930 blocked for more than 480 seconds.
> > > [276962.653097] INFO: task kworker/2:2:17823 blocked for more than 480 seconds.
> > > [276962.653940] INFO: task ld:14442 blocked for more than 480 seconds.
> > > [276962.654297] INFO: task ld:14962 blocked for more than 480 seconds.
> > > [277442.652123] INFO: task xfs-data/sda9:930 blocked for more than 480 seconds.
> > > [277442.653153] INFO: task kworker/2:2:17823 blocked for more than 480 seconds.
> > > [277442.653997] INFO: task ld:14442 blocked for more than 480 seconds.
> > > [277442.654353] INFO: task ld:14962 blocked for more than 480 seconds.
> > > [277922.652069] INFO: task xfs-data/sda9:930 blocked for more than 480 seconds.
> > > [277922.653089] INFO: task kworker/2:2:17823 blocked for more than 480 seconds.
> > > 
> > 
> > You seem to have switched to XFS. Dave posted a patch two days ago fixing some
> > missing conversions in the XFS side. AFAIK, Andrew hasn't yet picked the patch.
> 
> I can't find that patch.  Please resend?
> 
> There's also "list_lru: fix broken LRU_RETRY behaviour", which I
> assume we need?

Yes, we can either apply or stash that one - up to you.
