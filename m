Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab3LTXFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:05:46 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58218 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab3LTXFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:05:45 -0500
Message-ID: <52B4CD2B.3080100@ti.com>
Date: Fri, 20 Dec 2013 18:05:15 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] mm/ARM: fix ARMs __ffs() to conform to avoid warning
 with NO_BOOTMEM
References: <1386981486-3173-1-git-send-email-santosh.shilimkar@ti.com> <52B4C71D.9030904@ti.com> <20131220225541.GN4360@n2100.arm.linux.org.uk>
In-Reply-To: <20131220225541.GN4360@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 December 2013 05:55 PM, Russell King - ARM Linux wrote:
> On Fri, Dec 20, 2013 at 05:39:25PM -0500, Santosh Shilimkar wrote:
>> Russell,
>>
>> On Friday 13 December 2013 07:38 PM, Santosh Shilimkar wrote:
>>> Building ARM with NO_BOOTMEM generates below warning.
>>>
>>> mm/nobootmem.c: In function _____free_pages_memory___:
>>> mm/nobootmem.c:88:11: warning: comparison of distinct pointer types lacks a cast
>>>
>>> 	order = min(MAX_ORDER - 1UL, __ffs(start));
>>>
>>> ARM's __ffs() differs from other architectures in that it ends up being
>>> an int, whereas almost everyone else is unsigned long.
>>>
>>> So fix ARMs __ffs() to conform to other architectures. Suggested by
>>> Russell King <linux@arm.linux.org.uk>
>>>
>>> Some more details in below thread -
>>> 	https://lkml.org/lkml/2013/12/9/807
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Russell King <linux@arm.linux.org.uk>
>>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>> ---
>> Is this patch inline with what we discussed off-list ?
> 
> It is.
> 
>> If you ack it, it can go into the Andrews tree to kill that one last
>> warning with the memblock series. Thanks
> 
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
>
Great !!
 
Andrew,
Can you please pick the $subject patch as well in your
mm tree ? Thanks

regards,
Santosh
