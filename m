Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaA0VEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 16:04:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbaA0VE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 16:04:29 -0500
Date: Mon, 27 Jan 2014 16:04:13 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, riel@redhat.com,
        mgorman@suse.de, mhocko@suse.cz, aneesh.kumar@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com,
        david@gibson.dropbear.id.au, js1304@gmail.com,
        liwanp@linux.vnet.ibm.com, dhillf@gmail.com, rientjes@google.com,
        aswin@hp.com, scott.norton@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1390856653-v1nkcg1e-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1390794746-16755-7-git-send-email-davidlohr@hp.com>
References: <1390794746-16755-1-git-send-email-davidlohr@hp.com>
 <1390794746-16755-7-git-send-email-davidlohr@hp.com>
Subject: Re: [PATCH 6/8] mm, hugetlb: remove vma_has_reserves
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1390794746-16755-7-git-send-email-davidlohr@hp.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 07:52:24PM -0800, Davidlohr Bueso wrote:
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> vma_has_reserves() can be substituted by using return value of
> vma_needs_reservation(). If chg returned by vma_needs_reservation()
> is 0, it means that vma has reserves. Otherwise, it means that vma don't
> have reserves and need a hugepage outside of reserve pool. This definition
> is perfectly same as vma_has_reserves(), so remove vma_has_reserves().

I'm concerned that this patch doesn't work when VM_NORESERVE is set.
vma_needs_reservation() doesn't check VM_NORESERVE and this patch changes
dequeue_huge_page_vma() not to check it. So no one seems to check it any more.
It would be nice if you add some comment about the justification in changelog.
Does the testcase attached in commit af0ed73e699b still pass with this patch?
(I'm not sure it's covered in libhugetlbfs test suite.)

Thanks,
Naoya Horiguchi
