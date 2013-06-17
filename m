Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab3FQV4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:56:54 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:42089 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab3FQV4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:56:53 -0400
Message-ID: <51BF861F.6040802@gmail.com>
Date: Tue, 18 Jun 2013 05:56:47 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: Add unlikely for current_order test
References: <51BC4A83.50302@gmail.com> <alpine.DEB.2.02.1306161103020.22688@chino.kir.corp.google.com> <51BE6BFC.3030009@cn.fujitsu.com> <alpine.DEB.2.02.1306171431470.20631@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1306171431470.20631@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 05:37 AM, David Rientjes wrote:
> On Mon, 17 Jun 2013, Zhang Yanfei wrote:
> 
>>> I don't understand the justification at all, current_order being unlikely 
>>> greater than or equal to pageblock_order / 2 doesn't imply at all that 
>>> it's unlikely that current_order is greater than or equal to 
>>> pageblock_order.
>>>
>>
>> hmmm... I am confused. Since current_order is >= pageblock_order / 2 is unlikely,
>> why current_order is >= pageblock_order isn't unlikely. Or there are other
>> tips?
>>
>> Actually, I am also a little confused about why current_order should be
>> unlikely greater than or equal to pageblock_order / 2. When borrowing pages
>> with other migrate_type, we always search from MAX_ORDER-1, which is greater
>> or equal to pageblock_order.
>>
> 
> Look at what is being done in the function: current_order loops down from 
> MAX_ORDER-1 to the order passed.  It is not at all "unlikely" that 
> current_order is greater than pageblock_order, or pageblock_order / 2.
> 
> MAX_ORDER is typically 11 and pageblock_order is typically 9 on x86.  
> Integer division truncates, so pageblock_order / 2 is 4.  For the first 
> eight iterations, it's guaranteed that current_order >= pageblock_order / 
> 2 if it even gets that far!
> 
> So just remove the unlikely() entirely, it's completely bogus.

I see. Thanks!

I will send another patch.

-- 
Thanks.
Zhang Yanfei
