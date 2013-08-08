Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953Ab3HHH0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 03:26:41 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54515 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933730Ab3HHH0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 03:26:38 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-f5-5203482c2ecc
Message-id: <1375946794.25843.1.camel@AMDC1943>
Subject: Re: [RFC PATCH 3/4] mm: add zbud flag to page flags
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Thu, 08 Aug 2013 09:26:34 +0200
In-reply-to: <52012B35.90801@intel.com>
References: <1375771361-8388-1-git-send-email-k.kozlowski@samsung.com>
 <1375771361-8388-4-git-send-email-k.kozlowski@samsung.com>
 <52012B35.90801@intel.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xq7o6HsxBBu928lrMWb+GzWLjjPWs
	Fp9ePmC0ONv0ht3i8q45bBb31vxntVh75C67xeR3zxgtDu1bxe7A6bF4z0smj02fJrF7nJjx
	m8XjwaHNLB59W1Yxemw+Xe3xeZNcAHsUl01Kak5mWWqRvl0CV0bLC96CbraKk20r2BoYH7N0
	MXJySAiYSMx9sJQNwhaTuHBvPZDNxSEksJRR4vPsnVDOZ0aJcxveMIJU8QroS0y+cp69i5GD
	Q1jARuLReT6QMJuAscTm5UvABokIqEucWrmcHcRmFjjEJLHyJhdIOYuAqsS+54UgYU6gkoMd
	p9ghxi9glPi/5SojRL26xKR5i5ghDlKS2N3eCTVHXmLzmrfMECcISvyYfI9lAqPALCQts5CU
	zUJStoCReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSCR82cG4+JjVIUYBDkYlHt6OAKYg
	IdbEsuLK3EOMEhzMSiK8F4uBQrwpiZVVqUX58UWlOanFhxiZODilGhjd13EWuQso/PXvTu9f
	efF6wqUD23SymLa8+5pzamXpfobs4LyNlqq1fBcv9a+6K/LWOMggdV755+xtc3a3LHZj3nbw
	/bSVK17PWRja5r/tV9bG3d7vvkSd9X0+d2LIB4dpN7fMMN0ruVRSTVZtn1mT7aFEybMzesWc
	j3fI/YzuvzidTXXyn0x5JZbijERDLeai4kQAc3X+KmICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On wto, 2013-08-06 at 09:58 -0700, Dave Hansen wrote:
> On 08/05/2013 11:42 PM, Krzysztof Kozlowski wrote:
> > +#ifdef CONFIG_ZBUD
> > +	/* Allocated by zbud. Flag is necessary to find zbud pages to unuse
> > +	 * during migration/compaction.
> > +	 */
> > +	PG_zbud,
> > +#endif
> 
> Do you _really_ need an absolutely new, unshared page flag?
> The zbud code doesn't really look like it uses any of the space in
> 'struct page'.
> 
> I think you could pretty easily alias PG_zbud=PG_slab, then use the
> page->{private,slab_cache} (or some other unused field) in 'struct page'
> to store a cookie to differentiate slab and zbud pages.

How about using page->_mapcount with negative value (-129)? Just like
PageBuddy()?


Best regards,
Krzysztof

