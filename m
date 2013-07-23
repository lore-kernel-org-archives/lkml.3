Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab3GWPJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:09:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab3GWPJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:09:35 -0400
Date: Tue, 23 Jul 2013 17:09:31 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kamezawa.hiroyuki@gmail.com" <kamezawa.hiroyuki@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "yinghan@google.com" <yinghan@google.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kay@vrfy.org" <kay@vrfy.org>
Subject: Re: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
 memory blocks
Message-ID: <20130723150931.GM8677@dhcp22.suse.cz>
References: <1374261785-1615-1-git-send-email-kys@microsoft.com>
 <20130722123716.GB24400@dhcp22.suse.cz>
 <e06fced3ca42408b980f8aa68f4a29f3@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e06fced3ca42408b980f8aa68f4a29f3@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23-07-13 14:52:36, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Michal Hocko [mailto:mhocko@suse.cz]
> > Sent: Monday, July 22, 2013 8:37 AM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> > kamezawa.hiroyuki@gmail.com; hannes@cmpxchg.org; yinghan@google.com;
> > jasowang@redhat.com; kay@vrfy.org
> > Subject: Re: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
> > memory blocks
> > 
> > On Fri 19-07-13 12:23:05, K. Y. Srinivasan wrote:
> > > The current machinery for hot-adding memory requires having udev
> > > rules to bring the memory segments online. Export the necessary functionality
> > > to to bring the memory segment online without involving user space code.
> > 
> > Why? Who is going to use it and for what purpose?
> > If you need to do it from the kernel cannot you use usermod helper
> > thread?
> > 
> > Besides that this is far from being complete. memory_block_change_state
> > seems to depend on device_hotplug_lock and find_memory_block is
> > currently called with mem_sysfs_mutex held. None of them is exported
> > AFAICS.
> 
> You are right; not all of the required symbols are exported (yet). Let
> me answer your other questions first:
>
> The Hyper-V balloon driver can use this functionality. I have
> prototyped the in-kernel "onlining" of hot added memory without
> requiring any help from user level code that performs significantly
> better than having user level code involved in the hot add process.

What does significantly better mean here?

> With this change, I am able to successfully hot-add and online the
> hot-added memory even under extreme memory pressure which is what you
> would want given that we are hot-adding memory to alleviate memory
> pressure. The current scheme of involving user level code to close
> this loop obviously does not perform well under high memory pressure.

Hmm, this is really unexpected. Why the high memory pressure matters
here? Userspace only need to access sysfs file and echo a simple string
into a file. The reset is same regardless you do it from the userspace.

> I can, if you prefer export all of the necessary functionality in one
> patch.

If this turns out really a valid use case then I would prefer exporting
a high level function which would hide all the locking and direct
manipulation with mem blocks.

-- 
Michal Hocko
SUSE Labs
