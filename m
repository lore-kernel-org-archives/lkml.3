Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab3HZNBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:01:47 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:36007 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3HZNBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:01:46 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v2 03/20] mm, hugetlb: fix subpool accounting handling
In-Reply-To: <20130822074752.GH13415@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com> <1376040398-11212-4-git-send-email-iamjoonsoo.kim@lge.com> <87vc2zgzpn.fsf@linux.vnet.ibm.com> <20130822065038.GA13415@lge.com> <87y57u19ur.fsf@linux.vnet.ibm.com> <20130822074752.GH13415@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 26 Aug 2013 18:31:35 +0530
Message-ID: <871u5gehcg.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082612-2000-0000-0000-00000D7644C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> On Thu, Aug 22, 2013 at 12:38:12PM +0530, Aneesh Kumar K.V wrote:
>> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
>> 
>> > Hello, Aneesh.
>> >
>> > First of all, thank you for review!
>> >
>> > On Wed, Aug 21, 2013 at 02:58:20PM +0530, Aneesh Kumar K.V wrote:
>> >> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
>> >> 
>> >> > If we alloc hugepage with avoid_reserve, we don't dequeue reserved one.
>> >> > So, we should check subpool counter when avoid_reserve.
>> >> > This patch implement it.
>> >> 
>> >> Can you explain this better ? ie, if we don't have a reservation in the
>> >> area chg != 0. So why look at avoid_reserve. 
>> >
>> > We don't consider avoid_reserve when chg != 0.
>> > Look at following code.
>> >
>> > +       if (chg || avoid_reserve)
>> > +               if (hugepage_subpool_get_pages(spool, 1))
>> >
>> > It means that if chg != 0, we skip to check avoid_reserve.
>> 
>> when whould be avoid_reserve == 1 and chg == 0 ?
>
> In this case, we should do hugepage_subpool_get_pages(), since we don't
> get a reserved page due to avoid_reserve.

As per off-list discussion we had around this, please add additional
information in commit message explaining when we have
avoid_reserve == 1 and chg == 0

Something like the below copied from call site.

	 /* If the process that created a MAP_PRIVATE mapping is about to
	  * perform a COW due to a shared page count, attempt to satisfy
	  * the allocation without using the existing reserves
          */

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

-aneesh

