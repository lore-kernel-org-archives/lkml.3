Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab3HNXkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:40:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab3HNXky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:40:54 -0400
Date: Wed, 14 Aug 2013 16:40:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v5 0/9] extend hugepage migration
Message-Id: <20130814164052.2ccdd5bdf7ab56deeba88e68@linux-foundation.org>
In-Reply-To: <1376025702-14818-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1376025702-14818-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Aug 2013 01:21:33 -0400 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Here is the 5th version of hugepage migration patchset.
> Changes in this version are as follows:
>  - removed putback_active_hugepages() as a cleanup (1/9)
>  - added code to check movability of a given hugepage (8/9)
>  - set GFP MOVABLE flag depending on the movability of hugepage (9/9).
> 
> I feel that 8/9 and 9/9 contain some new things, so need reviews on them.
> 
> TODOs: (likely to be done after this work)
>  - split page table lock for pmd/pud based hugepage (maybe applicable to thp)
>  - improve alloc_migrate_target (especially in node choice)
>  - using page walker in check_range

This is a pretty large and complex patchset.  I skimmed the patches
(and have one trivial comment) then queued them up for a bit of
testing.  I've asked Mel if he can find time to review the changes
(please).

btw, it would be helpful if this [patch 0/n] had a decent overview of
the patch series - what are the objectives, how were they achieved,
what value they have to our users, testing results, etc.

mm-prepare-to-remove-proc-sys-vm-hugepages_treat_as_movable.patch had a
conflict with
http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
which I resolved in the obvious manner.  Please check that from a
runtime perspective.


