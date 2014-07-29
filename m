Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaG2BK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 21:10:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbaG2BKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 21:10:25 -0400
Date: Mon, 28 Jul 2014 21:10:18 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH 2/3] mm/hugetlb: take refcount under page table lock in
 follow_huge_pmd()
Message-ID: <20140729011018.GA25865@nhori.redhat.com>
References: <1406570911-28133-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1406570911-28133-2-git-send-email-n-horiguchi@ah.jp.nec.com>
 <alpine.DEB.2.02.1407281602050.8998@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407281602050.8998@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 04:02:31PM -0700, David Rientjes wrote:
> On Mon, 28 Jul 2014, Naoya Horiguchi wrote:
> 
> > We have a race condition between move_pages() and freeing hugepages,
> > where move_pages() calls follow_page(FOLL_GET) for hugepages internally
> > and tries to get its refcount without preventing concurrent freeing.
> > This race crashes the kernel, so this patch fixes it by moving FOLL_GET
> > code for hugepages into follow_huge_pmd() with taking the page table lock.
> > 
> 
> What about CONFIG_ARCH_WANT_GENERAL_HUGETLB=n configs?

Ah yes, I need cover them.
So I'll add some wrapper to do this locking in common hugetlb code.

Thanks,
Naoya Horiguchi
