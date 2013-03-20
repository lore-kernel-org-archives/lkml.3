Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3CTVxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:53:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab3CTVxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:53:37 -0400
Date: Wed, 20 Mar 2013 17:53:19 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Message-ID: <1363816399-c6e7mofc-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <5148FB6C.4070202@gmail.com>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1361475708-25991-2-git-send-email-n-horiguchi@ah.jp.nec.com>
 <5148FB6C.4070202@gmail.com>
Subject: Re: [PATCH 1/9] migrate: add migrate_entry_wait_huge()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <5148FB6C.4070202@gmail.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 07:57:32AM +0800, Simon Jeons wrote:
> Hi Naoya,
> On 02/22/2013 03:41 AM, Naoya Horiguchi wrote:
> >When we have a page fault for the address which is backed by a hugepage
> >under migration, the kernel can't wait correctly until the migration
> >finishes. This is because pte_offset_map_lock() can't get a correct
> 
> It seems that current hugetlb_fault still wait hugetlb page under
> migration, how can it work without lock 2MB memory?

Hugetlb_fault() does call migration_entry_wait(), but returns immediately.
So page fault happens over and over again until the migration completes.
IOW, migration_entry_wait() is now broken for hugepage and doesn't work
as expected.

Thanks,
Naoya
