Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab3HBHdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 03:33:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab3HBHdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:33:06 -0400
Date: Fri, 2 Aug 2013 09:33:04 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, dave.hansen@intel.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, bp@suse.de,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH resend] drop_caches: add some documentation and info
 message
Message-ID: <20130802073304.GA17746@dhcp22.suse.cz>
References: <1374842669-22844-1-git-send-email-mhocko@suse.cz>
 <20130729135743.c04224fb5d8e64b2730d8263@linux-foundation.org>
 <51F9D1F6.4080001@jp.fujitsu.com>
 <20130731201708.efa5ae87.akpm@linux-foundation.org>
 <CAHGf_=r7mek+ueJWfu_6giMOueDTnMs8dY1jJrKyX+gfPys6uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHGf_=r7mek+ueJWfu_6giMOueDTnMs8dY1jJrKyX+gfPys6uA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-08-13 21:39:48, KOSAKI Motohiro wrote:
> On Wed, Jul 31, 2013 at 11:17 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 31 Jul 2013 23:11:50 -0400 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> >
> >> >> --- a/fs/drop_caches.c
> >> >> +++ b/fs/drop_caches.c
> >> >> @@ -59,6 +59,8 @@ int drop_caches_sysctl_handler(ctl_table *table, int write,
> >> >>    if (ret)
> >> >>            return ret;
> >> >>    if (write) {
> >> >> +          printk(KERN_INFO "%s (%d): dropped kernel caches: %d\n",
> >> >> +                 current->comm, task_pid_nr(current), sysctl_drop_caches);
> >> >>            if (sysctl_drop_caches & 1)
> >> >>                    iterate_supers(drop_pagecache_sb, NULL);
> >> >>            if (sysctl_drop_caches & 2)
> >> >
> >> > How about we do
> >> >
> >> >     if (!(sysctl_drop_caches & 4))
> >> >             printk(....)
> >> >
> >> > so people can turn it off if it's causing problems?
> >>
> >> The best interface depends on the purpose. If you want to detect crazy application,
> >> we can't assume an application co-operate us. So, I doubt this works.
> >
> > You missed the "!".  I'm proposing that setting the new bit 2 will
> > permit people to prevent the new printk if it is causing them problems.
> 
> No I don't. I'm sure almost all abuse users think our usage is correct. Then,
> I can imagine all crazy applications start to use this flag eventually.

I guess we do not care about those. If somebody wants to shoot his feet
then we cannot do much about it. The primary motivation was to find out
those that think this is right and they are willing to change the setup
once they know this is not the right way to do things.

I think that giving a way to suppress the warning is a good step. Log
level might be to coarse and sysctl would be an overkill.

-- 
Michal Hocko
SUSE Labs
