Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaAPAMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:12:33 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:55830 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaAPAMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:12:30 -0500
Date: Thu, 16 Jan 2014 02:11:41 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org, cl@linux-foundation.org
Subject: Re: [RFC][PATCH 1/9] mm: slab/slub: use page->list consistently
 instead of page->lru
Message-ID: <20140116001141.GA8456@node.dhcp.inet.fi>
References: <20140114180042.C1C33F78@viggo.jf.intel.com>
 <20140114180044.1E401C47@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114180044.1E401C47@viggo.jf.intel.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 10:00:44AM -0800, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> 'struct page' has two list_head fields: 'lru' and 'list'.
> Conveniently, they are unioned together.  This means that code
> can use them interchangably, which gets horribly confusing like
> with this nugget from slab.c:
> 
> >	list_del(&page->lru);
> >	if (page->active == cachep->num)
> >		list_add(&page->list, &n->slabs_full);
> 
> This patch makes the slab and slub code use page->lru
> universally instead of mixing ->list and ->lru.
> 
> So, the new rule is: page->lru is what the you use if you want to
> keep your page on a list.  Don't like the fact that it's not
> called ->list?  Too bad.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
