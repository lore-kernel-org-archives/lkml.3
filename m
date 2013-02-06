Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab3BFBfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:35:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65265 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab3BFBfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:35:52 -0500
X-IronPort-AV: E=Sophos;i="4.84,612,1355068800"; 
   d="scan'208";a="6693392"
Message-ID: <5111B318.9020204@cn.fujitsu.com>
Date: Wed, 06 Feb 2013 09:34:16 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Linux MM <linux-mm@kvack.org>, mgorman@suse.de, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mm: rename confusing function names
References: <51113CE3.5090000@gmail.com> <20130205192640.GC6481@cmpxchg.org> <20130205141332.04fcceac.akpm@linux-foundation.org> <5111AC7D.9070505@cn.fujitsu.com> <20130205172057.3be4dbd4.akpm@linux-foundation.org>
In-Reply-To: <20130205172057.3be4dbd4.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 09:34:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 09:34:32
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月06日 09:20, Andrew Morton 写道:
> On Wed, 06 Feb 2013 09:06:05 +0800
> Zhang Yanfei <zhangyanfei@cn.fujitsu.com> wrote:
> 
>> So could I rename the functions to the names like
>> nr_available_buffer_high_pages
>> And accurately document them with code comments just as you suggested.
> 
> gee.  "available" implies "available for you to allocate".  It has the
> same problem as "free".
> 
> And "buffer" shouldn't be there - that's a reflection of the fact
> that buffer_head payloads are not allocated from highmem.  An archaic
> irrelevant thing.
> 
> Seriously, first let's write down the descriptions of what these
> functions *do*.  Then choose nice names which abbreviate that.
> 

OK, I will try to do this.

> 
> 
> hm,
> 
> static unsigned int nr_free_zone_pages(int offset)
> {
> 	...
> 	unsigned int sum = 0;
> 	...
> 	return sum;
> }
> 
> How long will it be until these things start exploding from
> sums-of-zones which exceed 16TB?  
> 

You mean overflow? Hmm.. it might happens. Change the sum to
unsigned long is ok?

Thanks
Zhang Yanfei

