Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab3EPRTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:19:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab3EPRTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:19:11 -0400
Message-ID: <51951478.5010608@redhat.com>
Date: Thu, 16 May 2013 13:16:40 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv11 3/4] zswap: add to mm/
References: <1368448803-2089-1-git-send-email-sjenning@linux.vnet.ibm.com> <1368448803-2089-4-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1368448803-2089-4-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 08:40 AM, Seth Jennings wrote:
> zswap is a thin compression backend for frontswap. It receives pages from
> frontswap and attempts to store them in a compressed memory pool, resulting in
> an effective partial memory reclaim and dramatically reduced swap device I/O.
>
> Additionally, in most cases, pages can be retrieved from this compressed store
> much more quickly than reading from tradition swap devices resulting in faster
> performance for many workloads.
>
> It also has support for evicting swap pages that are currently compressed in
> zswap to the swap device on an LRU(ish) basis. This functionality is very
> important and make zswap a true cache in that, once the cache is full or can't
> grow due to memory pressure, the oldest pages can be moved out of zswap to the
> swap device so newer pages can be compressed and stored in zswap.
>
> This patch adds the zswap driver to mm/
>
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Acked-by: Rik van Riel <riel@redhat.com>

As an aside, I agree with Dan that CONFIG_EXPERIMENTAL might be
appropriate here, or at least some kind of warning in the documentation
stating that this is fairly new code that still needs to be shaken
out in the real world.

-- 
All rights reversed
