Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3HADR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 23:17:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3HADR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 23:17:58 -0400
Date: Wed, 31 Jul 2013 20:17:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: mhocko@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        dave.hansen@intel.com, kamezawa.hiroyu@jp.fujitsu.com, bp@suse.de,
        dave@linux.vnet.ibm.com
Subject: Re: [PATCH resend] drop_caches: add some documentation and info
 message
Message-Id: <20130731201708.efa5ae87.akpm@linux-foundation.org>
In-Reply-To: <51F9D1F6.4080001@jp.fujitsu.com>
References: <1374842669-22844-1-git-send-email-mhocko@suse.cz>
	<20130729135743.c04224fb5d8e64b2730d8263@linux-foundation.org>
	<51F9D1F6.4080001@jp.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jul 2013 23:11:50 -0400 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> >> --- a/fs/drop_caches.c
> >> +++ b/fs/drop_caches.c
> >> @@ -59,6 +59,8 @@ int drop_caches_sysctl_handler(ctl_table *table, int write,
> >>  	if (ret)
> >>  		return ret;
> >>  	if (write) {
> >> +		printk(KERN_INFO "%s (%d): dropped kernel caches: %d\n",
> >> +		       current->comm, task_pid_nr(current), sysctl_drop_caches);
> >>  		if (sysctl_drop_caches & 1)
> >>  			iterate_supers(drop_pagecache_sb, NULL);
> >>  		if (sysctl_drop_caches & 2)
> > 
> > How about we do
> > 
> > 	if (!(sysctl_drop_caches & 4))
> > 		printk(....)
> > 
> > so people can turn it off if it's causing problems?
> 
> The best interface depends on the purpose. If you want to detect crazy application,
> we can't assume an application co-operate us. So, I doubt this works.

You missed the "!".  I'm proposing that setting the new bit 2 will
permit people to prevent the new printk if it is causing them problems.
