Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbaEPH5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 03:57:36 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57055 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbaEPH5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 03:57:34 -0400
Date: Fri, 16 May 2014 09:57:30 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jianyu Zhan <nasa4836@gmail.com>, iamjoonsoo.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com,
        aarcange@redhat.com, steve.capper@linaro.org, davidlohr@hp.com,
        kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, hugetlb: move the error handle logic out of normal
 code path
Message-ID: <20140516075730.GA22818@dhcp22.suse.cz>
References: <1400051459-20578-1-git-send-email-nasa4836@gmail.com>
 <20140515090142.GB3938@dhcp22.suse.cz>
 <20140515153620.344fe054b6b8d054a28fbf82@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515153620.344fe054b6b8d054a28fbf82@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-05-14 15:36:20, Andrew Morton wrote:
> On Thu, 15 May 2014 11:01:42 +0200 Michal Hocko <mhocko@suse.cz> wrote:
> 
> > On Wed 14-05-14 15:10:59, Jianyu Zhan wrote:
> > > alloc_huge_page() now mixes normal code path with error handle logic.
> > > This patches move out the error handle logic, to make normal code
> > > path more clean and redue code duplicate.
> > 
> > I don't know. Part of the function returns and cleans up on its own and
> > other part relies on clean up labels. This is not so much nicer than the
> > previous state.
> 
> That's actually a common pattern:
> 
> foo()
> {
> 	if (check which doesn't change any state)
> 		return -Efoo;
> 	if (another check which doesn't change any state)
> 		return -Ebar;
> 
> 	do_something_which_changes_state()
> 	
> 	if (another check)
> 		goto undo_that_state_chage;
> 	...
> 
> undo_that_state_change:
> 	...
> }

Right. I have misread the previous vma_needs_reservation and
hugepage_subpool_get_pages error path and already considered it as a
changing state one. Sorry about the confusion.
-- 
Michal Hocko
SUSE Labs
