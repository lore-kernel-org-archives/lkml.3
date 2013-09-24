Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3IXAwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 20:52:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab3IXAwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 20:52:43 -0400
Date: Mon, 23 Sep 2013 17:52:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v6 0/5] memcg, cgroup: kill css id
Message-Id: <20130923175247.ea5156de.akpm@linux-foundation.org>
In-Reply-To: <5240DD83.1070509@huawei.com>
References: <524001F8.6070205@huawei.com>
	<20130923130816.GH30946@htj.dyndns.org>
	<20130923131215.GI30946@htj.dyndns.org>
	<5240DD83.1070509@huawei.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013 08:32:03 +0800 Li Zefan <lizefan@huawei.com> wrote:

> On 2013/9/23 21:12, Tejun Heo wrote:
> > On Mon, Sep 23, 2013 at 09:08:16AM -0400, Tejun Heo wrote:
> >> Hello,
> >>
> >> On Mon, Sep 23, 2013 at 04:55:20PM +0800, Li Zefan wrote:
> >>> The whole patchset has been acked and reviewed by Michal and Tejun.
> >>> Could you merge it into mm tree?
> >>
> >> Ah... I really hoped that this had been merged during -rc1 window.
> >> Andrew, would it be okay to carry this series through cgroup tree?  It
> >> doesn't really have much to do with mm proper and it's a PITA to have
> >> to keep updating css_id code from cgroup side when it's scheduled to
> >> go away.  If carried in -mm, it's likely to cause conflicts with
> >> ongoing cgroup changes too.
> 
> I would love to see this patchset go through cgroup tree. The changes to
> memcg is quite small,

It seems logical to put this in the cgroup tree as that's where most of
the impact occurs.

> and as -mm tree is based on -next it won't cause
> future conflicts.

That's no longer the case - I'm staging -mm patches ahead of linux-next
now.  Except in cases where that's impractical, such as the 3.12 memcg
changes which were pretty heavily impacted by cgroups tree changes.

> > 
> > Also, wasn't this already in -mm during the last devel cycle?  ISTR
> > conflicts with it in -mm with other cgroup core changes.  Is there any
> > specific reason why this wasn't merged during the merge windw?
> > 
> 
> No, it never went into -mm tree... I guess it's because Andrew was too
> busy and overlooked this patchset?

I'm not sure what happened to the August 7 patchset, actually.  I don't
often overlook stuff - I'll skip things if the timing is terrible or if
the review comments indicate that another version is coming.  But none
of that seems to be the case here.  hmm...
