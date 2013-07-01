Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab3GAPOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:14:31 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:52474 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3GAPOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:14:30 -0400
Message-ID: <51D19CD1.3030900@gmail.com>
Date: Mon, 01 Jul 2013 17:14:25 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: Fix Marvell Orion and mv_xor after MEMSET removal
References: <1372690589-2218-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130701150407.GB19937@titan.lakedaemon.net>
In-Reply-To: <20130701150407.GB19937@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/13 17:04, Jason Cooper wrote:
> On Mon, Jul 01, 2013 at 04:56:29PM +0200, Sebastian Hesselbarth wrote:
>> Commit 834cbfe966bece50afded79da8e975d255bf0772
>>   ("drivers/dma: remove unused support for MEMSET operations")
>> removes MEMSET from dmaengine but does not completely removes it from
>> Marvell Orion (arch/arm/plat-orion) and XOR (drivers/dma/mv_xor).
>> This also fixes some compiler warnings about now obsolete functions by
>> removing those.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Cc: Jason Cooper <jason@lakedaemon.net>
>> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   arch/arm/plat-orion/common.c |    6 ------
>>   drivers/dma/mv_xor.c         |   25 +------------------------
>>   2 files changed, 1 insertions(+), 30 deletions(-)
>
> Please take a look at the email from lkml I just forwarded to you.  I
> believe this solves your problem, but I don't have time to look closely
> atm.

Jason,

I have seen the forwarded patch before. I don't know what version this
is based on. Some of the modifications are in next-20130701, some are
not. I have stripped the Marvell modifications from the patch you
forwarded and fixed all remaining issues.

Also, I will sent a follow-up patch to remove memset references from
Marvell SoC dts/dtsi and the binding documentation soon.

I guess, Bartolomiej should pick them up and resend his patch set, or
leave Marvell alone and you pick them up.

Sebastian

