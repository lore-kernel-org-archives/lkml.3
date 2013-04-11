Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965185Ab3DKRyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:54:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44743 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934868Ab3DKRyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:54:08 -0400
MIME-Version: 1.0
Message-ID: <3b7f1680-0cf7-46f0-b468-04068a1256d8@default>
Date: Thu, 11 Apr 2013 10:53:10 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>, Bob Liu <bob.liu@oracle.com>,
        Shuah Khan <shuah@gonehiking.org>
Subject: RE: zsmalloc defrag (Was: [PATCH] mm: remove compressed copy from
 zram in-memory)
References: <1365400862-9041-1-git-send-email-minchan@kernel.org>
 <f3c8ef05-a880-47db-86dd-156038fc7d0f@default>
 <20130409012719.GB3467@blaptop> <20130409013606.GC3467@blaptop>
 <3cc0fdea-7064-4b95-bbee-30c6448f0487@default>
 <20130410005449.GG6836@blaptop>
In-Reply-To: <20130410005449.GG6836@blaptop>
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
> On Tue, Apr 09, 2013 at 01:37:47PM -0700, Dan Magenheimer wrote:
> > > From: Minchan Kim [mailto:minchan@kernel.org]
> > > Subject: Re: zsmalloc defrag (Was: [PATCH] mm: remove compressed copy from zram in-memory)
> > >
> > > On Tue, Apr 09, 2013 at 10:27:19AM +0900, Minchan Kim wrote:
> > > > Hi Dan,
> > > >
> > > > On Mon, Apr 08, 2013 at 09:32:38AM -0700, Dan Magenheimer wrote:
> > > > > > From: Minchan Kim [mailto:minchan@kernel.org]
> > > > > > Sent: Monday, April 08, 2013 12:01 AM
> > > > > > Subject: [PATCH] mm: remove compressed copy from zram in-memory
> > > > >
> > > > > (patch removed)
> > > > >
> > > > > > Fragment ratio is almost same but memory consumption and compile time
> > > > > > is better. I am working to add defragment function of zsmalloc.
> > > > >
> > > > > Hi Minchan --
> > > > >
> > > > > I would be very interested in your design thoughts on
> > > > > how you plan to add defragmentation for zsmalloc.  In
> > > >
> > > > What I can say now about is only just a word "Compaction".
> > > > As you know, zsmalloc has a transparent handle so we can do whatever
> > > > under user. Of course, there is a tradeoff between performance
> > > > and memory efficiency. I'm biased to latter for embedded usecase.
> > > >
> > > > And I might post it because as you know well, zsmalloc
> > >
> > > Incomplete sentense,
> > >
> > > I might not post it until promoting zsmalloc because as you know well,
> > > zsmalloc/zram's all new stuffs are blocked into staging tree.
> > > Even if we could add it into staging, as you know well, staging is where
> > > every mm guys ignore so we end up needing another round to promote it. sigh.
> > >
> > > I hope it gets better after LSF/MM.
> >
> > If zsmalloc is moving in the direction of supporting only zram,
> > why should it be promoted into mm, or even lib?  Why not promote
> > zram into drivers and put zsmalloc.c in the same directory?
> 
> I don't want to make zsmalloc zram specific and will do best effort
> to generalize it to all z* familiy.

I'm glad to hear that.  You may not know/remember that the split between
"old zcache" and "new zcache" (and the fork to zswap) was started
because some people refused to accept changes to zsmalloc to
support a broader set of requirements.

> If it is hard to reach out
> agreement, yes, forking could be a easy solution like other embedded
> product company but I don't want it.

I don't want it either, so I think it is wise for us all to understand
each others' objectives to see if we can avoid a fork.  Or if the
objectives are too different, then we have data to explain to other kernel
developers why a fork is necessary.

Thanks!
Dan
