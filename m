Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab3GaElF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:41:05 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47599 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3GaElD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:41:03 -0400
X-AuditID: 9c930197-b7bfbae000000e88-09-51f8955de825
Date: Wed, 31 Jul 2013 13:41:01 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH 01/18] mm, hugetlb: protect reserved pages when
 softofflining requests the pages
Message-ID: <20130731044101.GE2548@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375075929-6119-2-git-send-email-iamjoonsoo.kim@lge.com>
 <CAJd=RBCUJg5GJEQ2_heCt8S9LZzedGLbvYvivFkmvfMChPqaCg@mail.gmail.com>
 <20130731022751.GA2548@lge.com>
 <CAJd=RBD=SNm9TG-kxKcd-BiMduOhLUubq=JpRwCy_MmiDtO9Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBD=SNm9TG-kxKcd-BiMduOhLUubq=JpRwCy_MmiDtO9Tw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 10:49:24AM +0800, Hillf Danton wrote:
> On Wed, Jul 31, 2013 at 10:27 AM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > On Mon, Jul 29, 2013 at 03:24:46PM +0800, Hillf Danton wrote:
> >> On Mon, Jul 29, 2013 at 1:31 PM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> >> > alloc_huge_page_node() use dequeue_huge_page_node() without
> >> > any validation check, so it can steal reserved page unconditionally.
> >>
> >> Well, why is it illegal to use reserved page here?
> >
> > If we use reserved page here, other processes which are promised to use
> > enough hugepages cannot get enough hugepages and can die. This is
> > unexpected result to them.
> >
> But, how do you determine that a huge page is requested by a process
> that is not allowed to use reserved pages?

Reserved page is just one for each address or file offset. If we need to
move this page, this means that it already use it's own reserved page, this
page is it. So we should not use other reserved page for moving this page.

Thanks.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
