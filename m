Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbaAFSz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:55:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbaAFSz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:55:27 -0500
Date: Mon, 6 Jan 2014 13:55:11 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Bart Van Assche <bvanassche@acm.org>, Jeff Mahoney <jeffm@suse.com>,
        torvalds@linux-foundation.org,
        device-mapper development <dm-devel@redhat.com>,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mingo@kernel.org
Subject: Re: [dm-devel] [PATCH] kobject: provide kobject_put_wait to fix
 module unload race
In-Reply-To: <20140105182640.GA2522@kroah.com>
Message-ID: <alpine.LRH.2.02.1401061347120.15626@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com> <52C98BCC.9040900@acm.org> <20140105182640.GA2522@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Jan 2014, Greg Kroah-Hartman wrote:

> On Sun, Jan 05, 2014 at 05:43:56PM +0100, Bart Van Assche wrote:
> > On 01/04/14 19:06, Mikulas Patocka wrote:
> > > -	if (t && !t->release)
> > > -		pr_debug("kobject: '%s' (%p): does not have a release() "
> > > -			 "function, it is broken and must be fixed.\n",
> > > -			 kobject_name(kobj), kobj);
> > > -
> > 
> > Has it been considered to issue a warning if no release function has
> > been defined and free_completion == NULL instead of removing the above
> > debug message entirely ? I think even with this patch applied it is
> > still wrong to invoke kobject_put() on an object without defining a
> > release function.
> 
> This patch isn't going to be applied, and I've reverted the original
> commit, so there shouldn't be any issues anymore with this code.

Why? This patch does the same thing as 
eee031649707db3c9920d9498f8d03819b74fc23, but it's smaller. So why did you 
accept eee031649707db3c9920d9498f8d03819b74fc23 and not this?

The code to wait for kobject destruction using completion already exists 
in cpufreq_sysfs_release, cpuidle_sysfs_release, 
cpuidle_state_sysfs_release, cpuidle_driver_sysfs_release, 
ext4_sb_release, ext4_feat_release, f2fs_sb_release (these are the only 
kobject users that are correct w.r.t. module unloading), so if you accept 
this patch, you can simplify them to use kobject_put_wait.

Mikulas
