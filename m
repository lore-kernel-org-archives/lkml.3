Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaKCIXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:23:20 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaKCIXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:23:18 -0500
Message-ID: <54573B72.1060600@nod.at>
Date: Mon, 03 Nov 2014 09:23:14 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: axboe@fb.com, dedekind1@gmail.com, ezequiel.garcia@free-electrons.com,
        dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: Block: Add blk-mq support
References: <1414933255-3795-1-git-send-email-richard@nod.at> <20141103081821.GA5261@infradead.org>
In-Reply-To: <20141103081821.GA5261@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.11.2014 um 09:18 schrieb Christoph Hellwig:
> On Sun, Nov 02, 2014 at 02:00:55PM +0100, Richard Weinberger wrote:
>> +#define UBIBLOCK_SG_COUNT 64
> 
> 
> Can you document why you choose this number? The default nr_request
> for the old code would be 128.

Is 64 a problem? Beside of the fact that I forgot to set blk_queue_max_segments().
I used this number because 128 seemed a bit high and my goal was to
keep the memory footprint small.
This is also why I've set tag_set.queue_depth to 64.

> Also I'll send a patch ASAP that allows drivers to ensure their
> ->queue_rq is always called from a driver-specific workqueue, which
> should simplify the bui block driver a lot.

Sounds great!

Thanks,
//richard
