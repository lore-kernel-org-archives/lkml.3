Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab3IBQho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 12:37:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758666Ab3IBQhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 12:37:43 -0400
Date: Mon, 02 Sep 2013 12:37:10 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andi Kleen <andi@firstfloor.org>,
        Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org
Message-ID: <1378139830-2a95i7nl-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130902105327.AE4D4E0090@blue.fi.intel.com>
References: <1377883120-5280-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1377883120-5280-3-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130902105327.AE4D4E0090@blue.fi.intel.com>
Subject: Re: [PATCH 2/2] thp: support split page table lock
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130902105327.AE4D4E0090@blue.fi.intel.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill, thank you for the comment.

On Mon, Sep 02, 2013 at 01:53:27PM +0300, Kirill A. Shutemov wrote:
> Naoya Horiguchi wrote:
> > Thp related code also uses per process mm->page_table_lock now. So making
> > it fine-grained can provide better performance.
> > 
> > This patch makes thp support split page table lock which makes us use
> > page->ptl of the pages storing "pmd_trans_huge" pmds.
> 
> Hm. So, you use page->ptl only when you deal with thp pages, otherwise
> mm->page_table_lock, right?

Maybe it's not enough.
We use page->ptl for both of thp and normal depending on USE_SPLIT_PTLOCKS.
And regardless of USE_SPLIT_PTLOCKS, mm->page_table_lock is still used
by other contexts like memory initialization code or driver code for their
specific usage.

> It looks inconsistent to me. Does it mean we have to take both locks on
> split and collapse paths?

This patch includes the replacement with page->ptl for split/collapse path.

> I'm not sure if it's safe to take only
> page->ptl for alloc path. Probably not.

Right, it's not safe.

> Why not to use new locking for pmd everywhere?

So I already do this.

Thanks,
Naoya Horiguchi
