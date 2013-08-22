Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab3HVGvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 02:51:52 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:61292 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab3HVGvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 02:51:51 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-f8-5215b504e8c6
Date: Thu, 22 Aug 2013 15:51:56 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v2 06/20] mm, hugetlb: return a reserved page to a
 reserved pool if failed
Message-ID: <20130822065156.GB13415@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1376040398-11212-7-git-send-email-iamjoonsoo.kim@lge.com>
 <87mwobgyii.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwobgyii.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 03:24:13PM +0530, Aneesh Kumar K.V wrote:
> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
> 
> > If we fail with a reserved page, just calling put_page() is not sufficient,
> > because put_page() invoke free_huge_page() at last step and it doesn't
> > know whether a page comes from a reserved pool or not. So it doesn't do
> > anything related to reserved count. This makes reserve count lower
> > than how we need, because reserve count already decrease in
> > dequeue_huge_page_vma(). This patch fix this situation.
> 
> You may want to document you are using PagePrivate for tracking
> reservation and why it is ok to that.

Okay! I will do it in next spin.

Thanks.
