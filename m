Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3FYOyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:54:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:65272 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab3FYOyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:54:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,937,1363158000"; 
   d="scan'208";a="355502163"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <519BFBA9.7040007@sr71.net>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1368321816-17719-28-git-send-email-kirill.shutemov@linux.intel.com>
 <519BFBA9.7040007@sr71.net>
Subject: Re: [PATCHv4 27/39] x86-64, mm: proper alignment mappings with
 hugepages
Content-Transfer-Encoding: 7bit
Message-Id: <20130625145655.68DCBE0090@blue.fi.intel.com>
Date: Tue, 25 Jun 2013 17:56:55 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On 05/11/2013 06:23 PM, Kirill A. Shutemov wrote:
> > +static inline unsigned long mapping_align_mask(struct address_space *mapping)
> > +{
> > +	if (mapping_can_have_hugepages(mapping))
> > +		return PAGE_MASK & ~HPAGE_MASK;
> > +	return get_align_mask();
> > +}
> 
> get_align_mask() appears to be a bit more complicated to me than just a
> plain old mask.  Are you sure you don't need to pick up any of its
> behavior for the mapping_can_have_hugepages() case?

get_align_mask() never returns more strict mask then we do in
mapping_can_have_hugepages() case.

I can modify it this way:

        unsigned long mask = get_align_mask();

        if (mapping_can_have_hugepages(mapping))
                mask &= PAGE_MASK & ~HPAGE_MASK;
        return mask;

But it looks more confusing for me. What do you think?

-- 
 Kirill A. Shutemov
