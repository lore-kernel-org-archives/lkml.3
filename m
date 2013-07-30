Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab3G3I0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:26:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3G3I0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:26:21 -0400
Date: Tue, 30 Jul 2013 01:25:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, dave.hansen@intel.com,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        bp@suse.de, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH resend] drop_caches: add some documentation and info
 message
Message-Id: <20130730012544.2f33ebf6.akpm@linux-foundation.org>
In-Reply-To: <20130730074531.GA10584@dhcp22.suse.cz>
References: <1374842669-22844-1-git-send-email-mhocko@suse.cz>
	<20130729135743.c04224fb5d8e64b2730d8263@linux-foundation.org>
	<20130730074531.GA10584@dhcp22.suse.cz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013 09:45:31 +0200 Michal Hocko <mhocko@suse.cz> wrote:

> On Mon 29-07-13 13:57:43, Andrew Morton wrote:
> > On Fri, 26 Jul 2013 14:44:29 +0200 Michal Hocko <mhocko@suse.cz> wrote:
> [...]
> > > --- a/fs/drop_caches.c
> > > +++ b/fs/drop_caches.c
> > > @@ -59,6 +59,8 @@ int drop_caches_sysctl_handler(ctl_table *table, int write,
> > >  	if (ret)
> > >  		return ret;
> > >  	if (write) {
> > > +		printk(KERN_INFO "%s (%d): dropped kernel caches: %d\n",
> > > +		       current->comm, task_pid_nr(current), sysctl_drop_caches);
> > >  		if (sysctl_drop_caches & 1)
> > >  			iterate_supers(drop_pagecache_sb, NULL);
> > >  		if (sysctl_drop_caches & 2)
> > 
> > How about we do
> > 
> > 	if (!(sysctl_drop_caches & 4))
> > 		printk(....)
> >
> > so people can turn it off if it's causing problems?
> 
> I am OK with that  but can we use a top bit instead. Maybe we never have
> other entities to drop in the future but it would be better to have a room for them
> just in case.

If we add another flag in the future it can use bit 3?

> So what about using 1<<31 instead?

Could, but negative (or is it positive?) numbers are a bit of a pain.
