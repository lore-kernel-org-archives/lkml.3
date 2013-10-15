Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789Ab3JOUnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:43:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933519Ab3JOUnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:43:18 -0400
Date: Tue, 15 Oct 2013 13:43:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Matt Mackall <mpm@selenic.com>,
        Cliff Wickman <cpw@sgi.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 0/11] update page table walker
Message-Id: <20131015134317.02d819f6905f790007ba1842@linux-foundation.org>
In-Reply-To: <1381772230-26878-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1381772230-26878-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Oct 2013 13:36:59 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Page table walker is widely used when you want to traverse page table
> tree and do some work for the entries (and pages pointed to by them.)
> This is a common operation, and keep the code clean and maintainable
> is important. Moreover this patchset introduces caller-specific walk
> control function which is helpful for us to newly introduce page table
> walker to some other users. Core change comes from patch 1, so please
> see it for how it's supposed to work.
> 
> This patchset changes core code in mm/pagewalk.c at first in patch 1 and 2,
> and then updates all of current users to make the code cleaner in patch
> 3-9. Patch 10 changes the interface of hugetlb_entry(), I put it here to
> keep bisectability of the whole patchset. Patch 11 applies page table walker
> to a new user queue_pages_range().

Unfortunately this is very incompatible with pending changes in
fs/proc/task_mmu.c.  Especially Kirill's "mm, thp: change
pmd_trans_huge_lock() to return taken lock".

Stephen will be away for a couple more weeks so I'll get an mmotm
released and hopefully Thierry and Mark will scoop it up(?). 
Alternatively, http://git.cmpxchg.org/?p=linux-mmots.git;a=summary is
up to date.

Please take a look, decide what you think we should do?
