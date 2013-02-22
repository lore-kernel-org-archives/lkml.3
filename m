Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab3BVR6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:58:16 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33872 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757702Ab3BVR6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:58:14 -0500
Message-ID: <5127B1AA.4080904@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2013 11:58:02 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv6 1/8] zsmalloc: add to mm/
References: <1361397888-14863-1-git-send-email-sjenning@linux.vnet.ibm.com> <1361397888-14863-2-git-send-email-sjenning@linux.vnet.ibm.com> <20130222094001.GB8077@lge.com>
In-Reply-To: <20130222094001.GB8077@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022217-9360-0000-0000-000010FD0C5C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 03:40 AM, Joonsoo Kim wrote:
> On Wed, Feb 20, 2013 at 04:04:41PM -0600, Seth Jennings wrote:
>> =========
>> DO NOT MERGE, FOR REVIEW ONLY
>> This patch introduces zsmalloc as new code, however, it already
>> exists in drivers/staging.  In order to build successfully, you
>> must select EITHER to driver/staging version OR this version.
>> Once zsmalloc is reviewed in this format (and hopefully accepted),
>> I will create a new patchset that properly promotes zsmalloc from
>> staging.
>> =========
>>
>> This patchset introduces a new slab-based memory allocator,
>> zsmalloc, for storing compressed pages.  It is designed for
>> low fragmentation and high allocation success rate on
>> large object, but <= PAGE_SIZE allocations.
>>
>> zsmalloc differs from the kernel slab allocator in two primary
>> ways to achieve these design goals.
>>
>> zsmalloc never requires high order page allocations to back
>> slabs, or "size classes" in zsmalloc terms. Instead it allows
>> multiple single-order pages to be stitched together into a
>> "zspage" which backs the slab.  This allows for higher allocation
>> success rate under memory pressure.
> 
> I have one more concern. It may be possibly stale question.
> I think that zsmalloc makes system memories more fragmented.
> Pages for zsmalloc can't be moved and may be spread at random location
> because it's order is just 0, so high order allocation success rate
> will be decreased. How do you think about it?

For now, this is true.  NUMA and migration awareness, IMO, are the
highest priorities for additional development on zsmalloc (after merging).

Thanks,
Seth

