Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3GJJ4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:56:11 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61973 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab3GJJ4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:56:09 -0400
X-AuditID: 9c930197-b7bfbae000000e88-30-51dd2fb7f36a
Date: Wed, 10 Jul 2013 18:56:06 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>, Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Support multiple pages allocation
Message-ID: <20130710095606.GB5557@lge.com>
References: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20130703152824.GB30267@dhcp22.suse.cz>
 <51D44890.4080003@gmail.com>
 <51D44AE7.1090701@gmail.com>
 <20130704042450.GA7132@lge.com>
 <20130704100044.GB7833@dhcp22.suse.cz>
 <20130710003142.GA2152@lge.com>
 <51DCB6DB.3070209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51DCB6DB.3070209@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 09:20:27AM +0800, Zhang Yanfei wrote:
> 于 2013/7/10 8:31, Joonsoo Kim 写道:
> > On Thu, Jul 04, 2013 at 12:00:44PM +0200, Michal Hocko wrote:
> >> On Thu 04-07-13 13:24:50, Joonsoo Kim wrote:
> >>> On Thu, Jul 04, 2013 at 12:01:43AM +0800, Zhang Yanfei wrote:
> >>>> On 07/03/2013 11:51 PM, Zhang Yanfei wrote:
> >>>>> On 07/03/2013 11:28 PM, Michal Hocko wrote:
> >>>>>> On Wed 03-07-13 17:34:15, Joonsoo Kim wrote:
> >>>>>> [...]
> >>>>>>> For one page allocation at once, this patchset makes allocator slower than
> >>>>>>> before (-5%). 
> >>>>>>
> >>>>>> Slowing down the most used path is a no-go. Where does this slow down
> >>>>>> come from?
> >>>>>
> >>>>> I guess, it might be: for one page allocation at once, comparing to the original
> >>>>> code, this patch adds two parameters nr_pages and pages and will do extra checks
> >>>>> for the parameter nr_pages in the allocation path.
> >>>>>
> >>>>
> >>>> If so, adding a separate path for the multiple allocations seems better.
> >>>
> >>> Hello, all.
> >>>
> >>> I modify the code for optimizing one page allocation via likely macro.
> >>> I attach a new one at the end of this mail.
> >>>
> >>> In this case, performance degradation for one page allocation at once is -2.5%.
> >>> I guess, remained overhead comes from two added parameters.
> >>> Is it unreasonable cost to support this new feature?
> >>
> >> Which benchmark you are using for this testing?
> > 
> > I use my own module which do allocation repeatedly.
> > 
> >>
> >>> I think that readahead path is one of the most used path, so this penalty looks
> >>> endurable. And after supporting this feature, we can find more use cases.
> >>
> >> What about page faults? I would oppose that page faults are _much_ more
> >> frequent than read ahead so you really cannot slow them down.
> > 
> > You mean page faults for anon?
> > Yes. I also think that it is much more frequent than read ahead.
> > Before futher discussion, I will try to add a separate path
> > for the multiple allocations.
> 
> Some days ago, I was thinking that this multiple allocation behaviour
> may be useful for vmalloc allocations. So I think it is worth trying.

Yeh! I think so!

Thanks.

> 
> > 
> > Thanks.
> > 
> >>
> >> [...]
> >> -- 
> >> Michal Hocko
> >> SUSE Labs
> >>
> >> --
> >> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> >> the body to majordomo@kvack.org.  For more info on Linux MM,
> >> see: http://www.linux-mm.org/ .
> >> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> > 
> 
> 
> -- 
> Thanks.
> Zhang Yanfei
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
