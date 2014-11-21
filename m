Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbaKUMCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:02:22 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:60024 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbaKUMCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:02:21 -0500
Date: Fri, 21 Nov 2014 14:01:45 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Christoph Lameter <cl@linux.com>, Dave Hansen <dave.hansen@intel.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Steve Capper <steve.capper@linaro.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/19] mm: store mapcount for compound page separate
Message-ID: <20141121120145.GB16647@node.dhcp.inet.fi>
References: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1415198994-15252-7-git-send-email-kirill.shutemov@linux.intel.com>
 <546C761D.6050407@redhat.com>
 <20141119130050.GA29884@node.dhcp.inet.fi>
 <alpine.DEB.2.11.1411201405140.14867@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411201405140.14867@gentwo.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 02:06:53PM -0600, Christoph Lameter wrote:
> On Wed, 19 Nov 2014, Kirill A. Shutemov wrote:
> 
> > I don't think we want to bloat struct page description: nobody outside of
> > helpers should use it direcly. And it's exactly what we did to store
> > compound page destructor and compound page order.
> 
> This is more like a description what overloading is occurring. Either
> add the new way of using it there including a comment explainng things or
> please do not overload the field.

I can do this although I don't see much value. At least we need to be
consistent and do the same for compound destructor and compound order.

Dave, you tried to sort mess around struct page recently. Any opinion?

BTW, how far we should go there? Should things like
PAGE_BUDDY_MAPCOUNT_VALUE and PAGE_BALLOON_MAPCOUNT_VALUE be described in
struct page definition too?

-- 
 Kirill A. Shutemov
