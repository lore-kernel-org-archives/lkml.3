Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaDGULa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:11:30 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:55662 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553AbaDGUL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:11:29 -0400
Date: Mon, 7 Apr 2014 23:11:06 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Mel Gorman <mgorman@suse.de>,
        Dave Jones <davej@redhat.com>, linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mm: BUG in do_huge_pmd_wp_page
Message-ID: <20140407201106.GA21633@node.dhcp.inet.fi>
References: <51559150.3040407@oracle.com>
 <515D882E.6040001@oracle.com>
 <533F09F0.1050206@oracle.com>
 <20140407144835.GA17774@node.dhcp.inet.fi>
 <5342FF3E.6030306@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5342FF3E.6030306@oracle.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 03:40:46PM -0400, Sasha Levin wrote:
> It also breaks fairly quickly under testing because:
> 
> On 04/07/2014 10:48 AM, Kirill A. Shutemov wrote:
> > +	if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
> > +		spin_lock(ptl);
> 
> ^ We go into atomic
> 
> > +		if (unlikely(!pmd_same(*pmd, orig_pmd)))
> > +			goto out_race;
> > +	}
> > +
> >  	if (!page)
> >  		clear_huge_page(new_page, haddr, HPAGE_PMD_NR);
> >  	else
> >  		copy_user_huge_page(new_page, page, haddr, vma, HPAGE_PMD_NR);
> 
> copy_user_huge_page() doesn't like running in atomic state,
> and asserts might_sleep().

Okay, I'll try something else.

-- 
 Kirill A. Shutemov
