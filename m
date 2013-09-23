Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3IWGIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 02:08:02 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:42689 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab3IWGIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 02:08:00 -0400
MIME-Version: 1.0
In-Reply-To: <523FA230.3020902@oracle.com>
References: <000701ceaac0$71c43590$554ca0b0$%yang@samsung.com>
	<20130909162909.GB4701@variantweb.net>
	<523FA230.3020902@oracle.com>
Date: Mon, 23 Sep 2013 14:07:59 +0800
Message-ID: <CAL1ERfM7Xzbi5UNqwNnMtg=aeeTABL8ad9h7XL4VVSR_iVRxTA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] mm/zswap: avoid unnecessary page scanning
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Bob Liu <bob.liu@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Weijie Yang <weijie.yang@samsung.com>, minchan@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 10:06 AM, Bob Liu <bob.liu@oracle.com> wrote:
>
> On 09/10/2013 12:29 AM, Seth Jennings wrote:
>> On Fri, Sep 06, 2013 at 01:16:45PM +0800, Weijie Yang wrote:
>>> add SetPageReclaim before __swap_writepage so that page can be moved to the
>>> tail of the inactive list, which can avoid unnecessary page scanning as this
>>> page was reclaimed by swap subsystem before.
>>>
>>> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
>>
>> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
>>
>
> Below is a reply from Mel in original thread "[PATCHv11 3/4] zswap: add
> to mm/"
> ------------------
>> +     /* start writeback */
>> +     SetPageReclaim(page);
>> +     __swap_writepage(page, &wbc, end_swap_bio_write);
>> +     page_cache_release(page);
>> +     zswap_written_back_pages++;
>> +
>
> SetPageReclaim? Why?. If the page is under writeback then why do you not
> mark it as that? Do not free pages that are currently under writeback
> obviously. It's likely that it was PageWriteback you wanted in zbud.c too.
> --------------------

Thanks for reminding this.

The purpose of using this flag in PATCHv11 and this patch is different.

In PATCHv11, it was repurposed to protect zbud page against free,
and now it is replaced with zhdr->under_reclaim.

In this patch, this flag is for its original purpose(to be reclaimed asap)

> --
> Regards,
> -Bob
