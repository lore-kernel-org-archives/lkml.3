Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaA2TY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 14:24:29 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:12372 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaA2TY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 14:24:27 -0500
Message-ID: <1391023456.18140.8.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 6/8] mm, hugetlb: remove vma_has_reserves
From: Davidlohr Bueso <davidlohr@hp.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, riel@redhat.com,
        mgorman@suse.de, mhocko@suse.cz, aneesh.kumar@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com,
        david@gibson.dropbear.id.au, js1304@gmail.com,
        liwanp@linux.vnet.ibm.com, dhillf@gmail.com, rientjes@google.com,
        aswin@hp.com, scott.norton@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 11:24:16 -0800
In-Reply-To: <1390856653-v1nkcg1e-mutt-n-horiguchi@ah.jp.nec.com>
References: <1390794746-16755-1-git-send-email-davidlohr@hp.com>
	 <1390794746-16755-7-git-send-email-davidlohr@hp.com>
	 <1390856653-v1nkcg1e-mutt-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-27 at 16:04 -0500, Naoya Horiguchi wrote:
> On Sun, Jan 26, 2014 at 07:52:24PM -0800, Davidlohr Bueso wrote:
> > From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > 
> > vma_has_reserves() can be substituted by using return value of
> > vma_needs_reservation(). If chg returned by vma_needs_reservation()
> > is 0, it means that vma has reserves. Otherwise, it means that vma don't
> > have reserves and need a hugepage outside of reserve pool. This definition
> > is perfectly same as vma_has_reserves(), so remove vma_has_reserves().
> 
> I'm concerned that this patch doesn't work when VM_NORESERVE is set.
> vma_needs_reservation() doesn't check VM_NORESERVE and this patch changes
> dequeue_huge_page_vma() not to check it. So no one seems to check it any more.

Good catch. I agree, this is new behavior and quite frankly not worth
changing just for a cleanup - the code is subtle enough as it is. I'm
dropping this patch and #7 which depends on this one, if Joonsoo wants
to later pursue this, he can.

Thanks,
Davidlohr

