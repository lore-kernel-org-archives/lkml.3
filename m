Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3KDWaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:30:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43068 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab3KDWaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:30:00 -0500
Message-ID: <52781FD7.9050507@kernel.dk>
Date: Mon, 04 Nov 2013 15:29:43 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Do not call sector_div() with a 64-bit divisor
References: <1383570006-4605-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1383570006-4605-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 06:00 AM, Geert Uytterhoeven wrote:
> do_div() (called by sector_div() if CONFIG_LBDAF=y) is meant for divisions
> of 64-bit number by 32-bit numbers.  Passing 64-bit divisor types caused
> issues in the past on 32-bit platforms, cfr. commit
> ea077b1b96e073eac5c3c5590529e964767fc5f7 ("m68k: Truncate base in
> do_div()").
> 
> As queue_limits.max_discard_sectors and .discard_granularity are unsigned
> int, max_discard_sectors and granularity should be unsigned int.
> As bdev_discard_alignment() returns int, alignment should be int.
> Now 2 calls to sector_div() can be replaced by 32-bit arithmetic:
>   - The 64-bit modulo operation can become a 32-bit modulo operation,
>   - The 64-bit division and multiplication can be replaced by a 32-bit
>     modulo operation and a subtraction.

Thanks Geert, applied.

-- 
Jens Axboe

