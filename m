Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab3HBQEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:04:10 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:37869 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab3HBQEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:04:08 -0400
Date: Fri, 02 Aug 2013 11:04:02 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH resend] drop_caches: add some documentation and info
 message
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        dave.hansen@intel.com, kamezawa.hiroyu@jp.fujitsu.com, bp@suse.de,
        dave@linux.vnet.ibm.com
In-Reply-To: <20130731201708.efa5ae87.akpm@linux-foundation.org> (from
	akpm@linux-foundation.org on Wed Jul 31 22:17:08 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1375459442.8422.1@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 10:17:08 PM, Andrew Morton wrote:
> On Wed, 31 Jul 2013 23:11:50 -0400 KOSAKI Motohiro  
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > >> --- a/fs/drop_caches.c
> > >> +++ b/fs/drop_caches.c
> > >> @@ -59,6 +59,8 @@ int drop_caches_sysctl_handler(ctl_table  
> *table, int write,
> > >>  	if (ret)
> > >>  		return ret;
> > >>  	if (write) {
> > >> +		printk(KERN_INFO "%s (%d): dropped kernel  
> caches: %d\n",
> > >> +		       current->comm, task_pid_nr(current),  
> sysctl_drop_caches);
> > >>  		if (sysctl_drop_caches & 1)
> > >>  			iterate_supers(drop_pagecache_sb, NULL);
> > >>  		if (sysctl_drop_caches & 2)
> > >
> > > How about we do
> > >
> > > 	if (!(sysctl_drop_caches & 4))
> > > 		printk(....)
> > >
> > > so people can turn it off if it's causing problems?
> >
> > The best interface depends on the purpose. If you want to detect  
> crazy application,
> > we can't assume an application co-operate us. So, I doubt this  
> works.
> 
> You missed the "!".  I'm proposing that setting the new bit 2 will
> permit people to prevent the new printk if it is causing them  
> problems.

Or an alternative for those planning to patch it down to a KERN_DEBUG  
locally.

I'd be surprised if anybody who does this sees the printk and thinks  
"hey, I'll dig into the VM's balancing logic and come up to speed on  
the tradeoffs sufficient to contribute to kernel development" because  
of something in dmesg. Anybody actually annoyed by it will chop out the  
printk (you barely need to know C to do that), the rest won't notice.

Rob