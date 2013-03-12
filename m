Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab3CLPnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:43:00 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:37732 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065Ab3CLPm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:42:56 -0400
Date: Tue, 12 Mar 2013 08:43:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] device: separate all subsys mutexes (was: Re: [BUG]
 potential deadlock led by cpu_hotplug lock (memcg involved))
Message-ID: <20130312154341.GB18852@kroah.com>
References: <513ECCFE.3070201@huawei.com>
 <20130312101555.GB30758@dhcp22.suse.cz>
 <20130312110750.GC30758@dhcp22.suse.cz>
 <20130312130504.GD30758@dhcp22.suse.cz>
 <1363102105.24558.4.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363102105.24558.4.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 04:28:25PM +0100, Peter Zijlstra wrote:
> On Tue, 2013-03-12 at 14:05 +0100, Michal Hocko wrote:
> > @@ -111,17 +111,17 @@ struct bus_type {
> >         struct iommu_ops *iommu_ops;
> >  
> >         struct subsys_private *p;
> > +       struct lock_class_key __key;
> >  };
> 
> Is struct bus_type constrained to static storage or can people go an
> allocate this stuff dynamically? If so, this patch is broken.

I don't think anyone is creating this dynamically, it should be static.
Why does this matter, does the lockdep code care about where the
variable is declared (heap vs. static)?

thanks,

greg k-h
