Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042Ab3BUWW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:22:57 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45040 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab3BUWWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:22:55 -0500
Message-ID: <51269DF1.9050107@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2013 16:21:37 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>
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
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv6 1/8] zsmalloc: add to mm/
References: <1361397888-14863-1-git-send-email-sjenning@linux.vnet.ibm.com> <1361397888-14863-2-git-send-email-sjenning@linux.vnet.ibm.com> <20130221203650.GB3778@negative>
In-Reply-To: <20130221203650.GB3778@negative>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022122-7282-0000-0000-0000147451FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 02:36 PM, Cody P Schafer wrote:
> On Wed, Feb 20, 2013 at 04:04:41PM -0600, Seth Jennings wrote:
>> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
>> +#define MAX(a, b) ((a) >= (b) ? (a) : (b))
>> +/* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
>> +#define ZS_MIN_ALLOC_SIZE \
>> +	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
> 
> Could you use the max(a,b) defined in include/linux/kernel.h?
> 

Andrew Morton made the same point.  We can't use max() or max_t()
because the value of ZS_MIN_ALLOC_SIZE is used to derive the value of
ZS_SIZE_CLASSES which is used to size an array in struct zs_pool.

So the expression must be completely evaluated to a number by the
precompiler.

Thanks,
Seth

