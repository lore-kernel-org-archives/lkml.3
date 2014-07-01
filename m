Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbaGAUQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:16:03 -0400
Received: from mta-out1.inet.fi ([62.71.2.199]:55453 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278AbaGAUQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:16:01 -0400
Date: Tue, 1 Jul 2014 23:15:40 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH] rmap: fix pgoff calculation to handle hugepage correctly
Message-ID: <20140701201540.GA5953@node.dhcp.inet.fi>
References: <1404225982-22739-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20140701180739.GA4985@node.dhcp.inet.fi>
 <20140701185021.GA10356@nhori.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701185021.GA10356@nhori.bos.redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 02:50:21PM -0400, Naoya Horiguchi wrote:
> On Tue, Jul 01, 2014 at 09:07:39PM +0300, Kirill A. Shutemov wrote:
> > Why do we need this special case for hugetlb page ->index? Why not use
> > PAGE_SIZE units there too? Or I miss something?
> 
> hugetlb pages are never split, so we use larger page cache size for
> hugetlbfs file (to avoid large sparse page cache tree.)

For transparent huge page cache I would like to have native support in
page cache radix-tree: since huge pages are always naturally aligned we
can create a leaf node for it several (RADIX_TREE_MAP_SHIFT -
HPAGE_PMD_ORDER) levels up by tree, which would cover all indexes in the
range the huge page represents. This approach should fit hugetlb too. And
-1 special case for hugetlb.
But I'm not sure when I'll get time to play with this...

-- 
 Kirill A. Shutemov
