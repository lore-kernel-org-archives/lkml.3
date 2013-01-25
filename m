Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3AYXQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 18:16:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45466 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab3AYXQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 18:16:46 -0500
MIME-Version: 1.0
Message-ID: <33082dbe-496e-47a0-8394-11d59ac17f87@default>
Date: Fri, 25 Jan 2013 15:15:30 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Rik van Riel <riel@redhat.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCHv2 8/9] zswap: add to mm/
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1357590280-31535-9-git-send-email-sjenning@linux.vnet.ibm.com>
 <51030ADA.8030403@redhat.com>
In-Reply-To: <51030ADA.8030403@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rik van Riel [mailto:riel@redhat.com]
> Subject: Re: [PATCHv2 8/9] zswap: add to mm/
> 
> On 01/07/2013 03:24 PM, Seth Jennings wrote:
> > zswap is a thin compression backend for frontswap. It receives
> > pages from frontswap and attempts to store them in a compressed
> > memory pool, resulting in an effective partial memory reclaim and
> > dramatically reduced swap device I/O.
> >
> > Additional, in most cases, pages can be retrieved from this
> > compressed store much more quickly than reading from tradition
> > swap devices resulting in faster performance for many workloads.
> >
> > This patch adds the zswap driver to mm/
> >
> > Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> 
> I like the approach of flushing pages into actual disk based
> swap when compressed swap is full.  I would like it if that
> was advertised more prominently in the changelog :)
> 
> The code looks mostly good, complaints are at the nitpick level.
> 
> One worry is that the pool can grow to whatever maximum was
> decided, and there is no way to shrink it when memory is
> required for something else.
> 
> Would it be an idea to add a shrinker for the zcache pool,
> that can also shrink the zcache pool when required?
> 
> Of course, that does lead to the question of how to balance
> the pressure from that shrinker, with the new memory entering
> zcache from the swap side. I have no clear answers here, just
> something to think about...

Hey Rik --

A shrinker needs to be able to free up whole pages.
I think Seth is working on this with zsmalloc but
it's quite a bit harder when pursuing high density
and page crossing which are the benefits, but also
part of the curse, of zsmalloc.

I have some ideas on how to do pressure balancing
and plan to propose a topic for LSF/MM to discuss
various questions involving in-kernel compression,
with this sub-topic included.  Hopefully all the
developers contributing various in-kernel compression
solutions will be able to attend and participate
and we can start converging on upstreaming (and/or
promoting) some of them.

Dan
