Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab3A1Rlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:41:37 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33344 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab3A1Rle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:41:34 -0500
Message-ID: <5106B83E.2030804@linux.vnet.ibm.com>
Date: Mon, 28 Jan 2013 11:41:18 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv2 6/9] zsmalloc: promote to lib/
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com> <1357590280-31535-7-git-send-email-sjenning@linux.vnet.ibm.com> <20130128040116.GF3321@blaptop> <20130128043257.GH3321@blaptop>
In-Reply-To: <20130128043257.GH3321@blaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012817-7182-0000-0000-000004C16B97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2013 10:32 PM, Minchan Kim wrote:
> On Mon, Jan 28, 2013 at 01:01:16PM +0900, Minchan Kim wrote:
>> On Mon, Jan 07, 2013 at 02:24:37PM -0600, Seth Jennings wrote:
>>> This patch promotes the slab-based zsmalloc memory allocator
>>> from the staging tree to lib/
>>>
>>> zswap depends on this allocator for storing compressed RAM pages
>>> in an efficient way under system wide memory pressure where
>>> high-order (greater than 0) page allocation are very likely to
>>> fail.
>>>
>>> For more information on zsmalloc and its internals, read the
>>> documentation at the top of the zsmalloc.c file.
>>>
>>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
>>
>> Seth, zsmalloc has a bug[1], I sent a patch totay. If it want't known,
>> it mighte be no problem to promote but it's known bug so let's fix it
>> before promoting.
>>
>> Another question. Why do you promote zsmalloc in this patchset?
>> It might make you hard to merge even zswap into staging.
> 
> When I look at [8/9], I realized you are trying to merge this patch
> into mm/, NOT staging. I don't know history why zsmalloc/zram/zscache was
> in staging at the beginning but personally, I don't ojbect zswap into /mm
> directly because I got realized staging is very deep hole to get out,
> expecially related to mm stuff. ;-)

Correct.

As I understand the purpose of the staging tree, it is meant for
drivers whose code doesn't adhere to the kernel coding
standards/guidelines and might have questionable stability.  The point
is to have a TODO, get the code to conform to the kernel standards,
fix known instabilities, then promote into the appropriate place in
the driver tree.

However, with the work on memory compression, it's really become a
prototyping area, which I don't think Greg likes all that much.

Seth

