Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161116Ab3DKR4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:56:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47974 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965048Ab3DKR4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:56:51 -0400
MIME-Version: 1.0
Message-ID: <e0a941db-b467-4b5f-b95d-a7c075a5a768@default>
Date: Thu, 11 Apr 2013 10:56:28 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan@kernel.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>, Bob Liu <bob.liu@oracle.com>,
        Shuah Khan <shuah@gonehiking.org>
Subject: RE: zsmalloc defrag (Was: [PATCH] mm: remove compressed copy from
 zram in-memory)
References: <1365400862-9041-1-git-send-email-minchan@kernel.org>
 <f3c8ef05-a880-47db-86dd-156038fc7d0f@default>
 <20130409012719.GB3467@blaptop> <20130409013606.GC3467@blaptop>
 <51647F94.6000907@linux.vnet.ibm.com> <20130410005801.GH6836@blaptop>
In-Reply-To: <20130410005801.GH6836@blaptop>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Minchan Kim [mailto:minchan@kernel.org]
> Subject: Re: zsmalloc defrag (Was: [PATCH] mm: remove compressed copy from zram in-memory)
> 
> Hi Seth,
> 
> On Tue, Apr 09, 2013 at 03:52:36PM -0500, Seth Jennings wrote:
> > On 04/08/2013 08:36 PM, Minchan Kim wrote:
> > > On Tue, Apr 09, 2013 at 10:27:19AM +0900, Minchan Kim wrote:
> > >> Hi Dan,
> > >>
> > >> On Mon, Apr 08, 2013 at 09:32:38AM -0700, Dan Magenheimer wrote:
> > >>>> From: Minchan Kim [mailto:minchan@kernel.org]
> > >>>> Sent: Monday, April 08, 2013 12:01 AM
> > >>>> Subject: [PATCH] mm: remove compressed copy from zram in-memory
> > >>>
> > >>> (patch removed)
> > >>>
> > >>>> Fragment ratio is almost same but memory consumption and compile time
> > >>>> is better. I am working to add defragment function of zsmalloc.
> > >>>
> > >>> Hi Minchan --
> > >>>
> > >>> I would be very interested in your design thoughts on
> > >>> how you plan to add defragmentation for zsmalloc.  In
> > >>
> > >> What I can say now about is only just a word "Compaction".
> > >> As you know, zsmalloc has a transparent handle so we can do whatever
> > >> under user. Of course, there is a tradeoff between performance
> > >> and memory efficiency. I'm biased to latter for embedded usecase.
> > >>
> > >> And I might post it because as you know well, zsmalloc
> > >
> > > Incomplete sentense,
> > >
> > > I might not post it until promoting zsmalloc because as you know well,
> > > zsmalloc/zram's all new stuffs are blocked into staging tree.
> > > Even if we could add it into staging, as you know well, staging is where
> > > every mm guys ignore so we end up needing another round to promote it. sigh.
> >
> > Yes. The lack of compaction/defragmentation support in zsmalloc has not
> > been raised as an obstacle to mainline acceptance so I think we should
> > wait to add new features to a yet-to-be accepted codebase.
> >
> > Also, I think this feature is more important to zram than it is to
> > zswap/zcache as they can do writeback to free zpages.  In other words,
> > the fragmentation is a transient issue for zswap/zcache since writeback
> > to the swap device is possible.
> 
> Other benefit derived from compaction work is that we can pick a zpage
> from zspage and move it into somewhere. It means core mm could control
> pages in zsmalloc freely.

I'm not sure I understand which is why I'd like to learn more about
your proposed design.  Are you suggesting that core mm would periodically
call zsmalloc-compaction and see what pages get freed?  I'm hoping
for more control than that.

More good discussion for next week!
Dan
