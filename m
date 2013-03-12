Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab3CLSqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:46:47 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63993 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab3CLSqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:46:45 -0400
Date: Tue, 12 Mar 2013 11:47:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH -v2] device: separate all subsys mutexes (was: Re: [BUG]
 potential deadlock led by cpu_hotplug lock (memcg involved))
Message-ID: <20130312184718.GA9749@kroah.com>
References: <513ECCFE.3070201@huawei.com>
 <20130312101555.GB30758@dhcp22.suse.cz>
 <20130312110750.GC30758@dhcp22.suse.cz>
 <20130312130504.GD30758@dhcp22.suse.cz>
 <20130312133446.GA3514@kroah.com>
 <20130312162119.GB5963@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312162119.GB5963@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 05:21:19PM +0100, Michal Hocko wrote:
> On Tue 12-03-13 06:34:46, Greg Kroah-Hartman wrote:
> > On Tue, Mar 12, 2013 at 02:05:04PM +0100, Michal Hocko wrote:
> > > The fix is quite simple. We can pull the key inside bus_type structure
> > > because they are defined per device so the pointer will be unique as
> > > well. bus_register doesn't need to be a macro anymore so change it
> > > to the inline. We could get rid of __bus_register as there is no other
> > > caller but maybe somebody will want to use a different key so keep it
> > > around for now.
> > 
> > Nice work, but just drop __bus_register(), no one should need to use a
> > new key for this type of thing, now that you have added a per-bus_type
> > variable.
> 
> OK v2 below. I have also ranamed __key to lock_key. Who is going to take
> the patch?

I will, thanks.

greg k-h
