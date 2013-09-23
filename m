Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3IWCHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 22:07:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27909 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab3IWCHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 22:07:01 -0400
Message-ID: <523FA230.3020902@oracle.com>
Date: Mon, 23 Sep 2013 10:06:40 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Weijie Yang <weijie.yang@samsung.com>, minchan@kernel.org,
        weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm/zswap: avoid unnecessary page scanning
References: <000701ceaac0$71c43590$554ca0b0$%yang@samsung.com> <20130909162909.GB4701@variantweb.net>
In-Reply-To: <20130909162909.GB4701@variantweb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/10/2013 12:29 AM, Seth Jennings wrote:
> On Fri, Sep 06, 2013 at 01:16:45PM +0800, Weijie Yang wrote:
>> add SetPageReclaim before __swap_writepage so that page can be moved to the
>> tail of the inactive list, which can avoid unnecessary page scanning as this
>> page was reclaimed by swap subsystem before.
>>
>> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> 
> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> 

Below is a reply from Mel in original thread "[PATCHv11 3/4] zswap: add
to mm/"
------------------
> +     /* start writeback */
> +     SetPageReclaim(page);
> +     __swap_writepage(page, &wbc, end_swap_bio_write);
> +     page_cache_release(page);
> +     zswap_written_back_pages++;
> +

SetPageReclaim? Why?. If the page is under writeback then why do you not
mark it as that? Do not free pages that are currently under writeback
obviously. It's likely that it was PageWriteback you wanted in zbud.c too.
--------------------

-- 
Regards,
-Bob
