Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaFJUrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:47:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbaFJUrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:47:06 -0400
Date: Tue, 10 Jun 2014 13:50:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 3.4 47/88] mm: add kmap_to_page()
Message-ID: <20140610205054.GA32325@kroah.com>
References: <20140610002424.500996570@linuxfoundation.org>
 <20140610002426.089246636@linuxfoundation.org>
 <alpine.LSU.2.11.1406091806230.8481@eggly.anvils>
 <5396BC25.7040500@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5396BC25.7040500@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 04:04:53PM +0800, Yijing Wang wrote:
> >> +struct page *kmap_to_page(void *vaddr)
> >> +{
> >> +	unsigned long addr = (unsigned long)vaddr;
> >> +
> >> +	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
> >> +		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
> >> +		return pte_page(pkmap_page_table[i]);
> >> +	}
> >> +
> >> +	return virt_to_page(addr);
> >> +}
> >> +
> >>  static void flush_all_zero_pkmaps(void)
> >>  {
> >>  	int i;
> > 
> > I think this needs the following on top:
> > 
> > commit 498c2280212327858e521e9d21345d4cc2637f54
> > Author: Will Deacon <will.deacon@arm.com>
> > Date:   Fri Nov 16 14:15:00 2012 -0800
> > 
> 
> Thanks Hugh. Hi Greg, please pick up this fix patch, Thanks a lot!

Now applied, thanks!

greg k-h
