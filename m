Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab3ETPmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:42:38 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50303 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab3ETPmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:42:36 -0400
Date: Mon, 20 May 2013 10:42:25 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv11 2/4] zbud: add to mm/
Message-ID: <20130520154225.GA25536@cerebellum>
References: <1368448803-2089-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1368448803-2089-3-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130517154837.GN11497@suse.de>
 <20130519205219.GA3252@cerebellum>
 <20130520135439.GR11497@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130520135439.GR11497@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052015-5806-0000-0000-00002139C946
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 02:54:39PM +0100, Mel Gorman wrote:
> On Sun, May 19, 2013 at 03:52:19PM -0500, Seth Jennings wrote:
> > My first guess is that the external fragmentation situation you are referring to
> > is a workload in which all pages compress to greater than half a page.  If so,
> > then it doesn't matter what NCHUCNKS_ORDER is, there won't be any pages the
> > compress enough to fit in the < PAGE_SIZE/2 free space that remains in the
> > unbuddied zbud pages.
> > 
> 
> There are numerous aspects to this, too many to write them all down.
> Modelling the external fragmentation one and how it affects swap IO
> would be a complete pain in the ass so lets consider the following
> example instead as it's a bit clearer.
> 
> Three processes. Process A compresses by 75%, Process B compresses to 15%,
> Process C pages compress to 15%. They are all adding to zswap in lockstep.
> Lets say that zswap can hold 100 physical pages.
> 
> NCHUNKS == 2
> 	All Process A pages get rejected.

Ah, I think this is our disconnect.  Process A pages will not be rejected.
They will be stored in a zbud page, and that zbud page will be added
to the 0th unbuddied list.  This list maintains a list of zbud pages
that will never be buddied because there are no free chunks.

In other words, changing NCHUNKS has no effect on the acceptable size
of allocations.

Seth

