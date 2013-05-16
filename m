Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab3EPPbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:31:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab3EPPbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:31:13 -0400
Message-ID: <5194FB9A.6000300@redhat.com>
Date: Thu, 16 May 2013 11:30:34 -0400
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
Subject: Re: [PATCHv11 2/4] zbud: add to mm/
References: <1368448803-2089-1-git-send-email-sjenning@linux.vnet.ibm.com> <1368448803-2089-3-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1368448803-2089-3-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 08:40 AM, Seth Jennings wrote:
> zbud is an special purpose allocator for storing compressed pages. It is
> designed to store up to two compressed pages per physical page.  While this
> design limits storage density, it has simple and deterministic reclaim
> properties that make it preferable to a higher density approach when reclaim
> will be used.
>
> zbud works by storing compressed pages, or "zpages", together in pairs in a
> single memory page called a "zbud page".  The first buddy is "left
> justifed" at the beginning of the zbud page, and the last buddy is "right
> justified" at the end of the zbud page.  The benefit is that if either
> buddy is freed, the freed buddy space, coalesced with whatever slack space
> that existed between the buddies, results in the largest possible free region
> within the zbud page.
>
> zbud also provides an attractive lower bound on density. The ratio of zpages
> to zbud pages can not be less than 1.  This ensures that zbud can never "do
> harm" by using more pages to store zpages than the uncompressed zpages would
> have used on their own.
>
> This patch adds zbud to mm/ for later use by zswap.
>
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
