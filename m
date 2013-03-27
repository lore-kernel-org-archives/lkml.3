Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab3C0Ta2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:30:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab3C0T3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:29:51 -0400
Date: Wed, 27 Mar 2013 15:28:54 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org
Message-ID: <1364412534-t9czjtag-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <87620e9xow.fsf@linux.vnet.ibm.com>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1363983835-20184-10-git-send-email-n-horiguchi@ah.jp.nec.com>
 <87620e9xow.fsf@linux.vnet.ibm.com>
Subject: Re: [PATCH 09/10] memory-hotplug: enable memory hotplug to handle
 hugepage
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <87620e9xow.fsf@linux.vnet.ibm.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 05:31:51PM +0530, Aneesh Kumar K.V wrote:
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:
> 
> > +/* Returns true for head pages of in-use hugepages, otherwise returns false. */
> > +bool is_hugepage_movable(struct page *hpage)
> > +{
> > +	struct page *page;
> > +	struct hstate *h;
> > +	bool ret = false;
> > +
> > +	VM_BUG_ON(!PageHuge(hpage));
> > +	/*
> > +	 * This function can be called for a tail page because memory hotplug
> > +	 * scans movability of pages by pfn range of a memory block.
> > +	 * Larger hugepages (1GB for x86_64) are larger than memory block, so
> > +	 * the scan can start at the tail page of larger hugepages.
> > +	 * 1GB hugepage is not movable now, so we return with false for now.
> > +	 */
> > +	if (PageTail(hpage))
> > +		return false;
> > +	h = page_hstate(hpage);
> > +	spin_lock(&hugetlb_lock);
> > +	list_for_each_entry(page, &h->hugepage_activelist, lru)
> > +		if (page == hpage) {
> > +			ret = true;
> > +			break;
> > +		}
> > +	spin_unlock(&hugetlb_lock);
> > +	return ret;
> > +}
> > +
> 
> May be is_hugepage_active() ?

Yes, it would be nice.

Thanks,
Naoya
