Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900Ab3BMQBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:01:49 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:34053 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759412Ab3BMQBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:01:48 -0500
Message-ID: <511BB8A7.9040305@linux.vnet.ibm.com>
Date: Wed, 13 Feb 2013 10:00:39 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv4 2/7] zsmalloc: promote to lib/
References: <1359495627-30285-1-git-send-email-sjenning@linux.vnet.ibm.com> <1359495627-30285-3-git-send-email-sjenning@linux.vnet.ibm.com> <20130129145134.813672cf.akpm@linux-foundation.org>
In-Reply-To: <20130129145134.813672cf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021316-3620-0000-0000-000001363350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 04:51 PM, Andrew Morton wrote:
> On Tue, 29 Jan 2013 15:40:22 -0600
> Seth Jennings <sjenning@linux.vnet.ibm.com> wrote:
> 
>> This patch promotes the slab-based zsmalloc memory allocator
>> from the staging tree to lib/
> 
> Hate to rain on the parade, but...  we haven't reviewed zsmalloc
> yet.  At least, I haven't, and I haven't seen others do so.
> 
> So how's about we forget that zsmalloc was previously in staging and
> send the zsmalloc code out for review?  With a very good changelog
> explaining why it exists, what problems it solves, etc.
> 
> 
> I peeked.
> 
> Don't answer any of the below questions - they are examples of
> concepts which should be accessible to readers of the
> hopefully-forthcoming very-good-changelog.

I know you just said "don't answer", but I wanted to say why certain
points aren't included in the new patchset I'm about to post later today.

> 
> - kmap_atomic() returns a void* - there's no need to cast its return value.

In places where we do pointer arithmetic, we do the cast to avoid
incrementing a void *, which is acceptable for gcc, but not everyone.

> 
> - Remove private MAX(), use the (much better implemented) max().

We can't use max() or max_t() because ZS_SIZE_CLASSES, which uses
ZS_MIN_ALLOC_SIZE, is used to define and array size in struct zs_pool.
So the expression must be able to be fully evaluated by the precompiler.

> 
> - It says "This was one of the major issues with its predecessor
>   (xvmalloc)", but drivers/staging/ramster/xvmalloc.c is still in the tree.

Yes, this was a little mess.  I think you'll find that isn't the case
anymore.  Dan has removed those files from zcache/ramster.

> 
> - USE_PGTABLE_MAPPING should be done via Kconfig.

Minchan did this work and will be included in the next version of the
patchset.

I've added more documentation/comments in the new patchset.  Hopefully,
it will help with understanding the more complicated parts of the code.

Thanks,
Seth

