Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaCMV7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:59:46 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37775 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbaCMV7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:59:45 -0400
Message-ID: <53222A4E.70006@kernel.dk>
Date: Thu, 13 Mar 2014 15:59:42 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sam Bradshaw <sbradshaw@micron.com>
CC: linux-kernel@vger.kernel.org, Felipe Franciosi <felipe@paradoxo.org>,
        david.vrabel@citrix.com,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa)" 
	<asamymuthupa@micron.com>
Subject: Re: [PATCH] mtip32xx: mtip_async_complete() bug fixes
References: <53221E92.3030707@micron.com> <53221CF5.2080000@kernel.dk> <5322242A.6080901@micron.com>
In-Reply-To: <5322242A.6080901@micron.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 03:33 PM, Sam Bradshaw wrote:
> On 03/13/2014 02:02 PM, Jens Axboe wrote:
>> On 03/13/2014 03:09 PM, Sam Bradshaw wrote:
>>> This patch fixes 2 issues in the fast completion path:
>>> 1) Possible double completions / double dma_unmap_sg() calls due to lack
>>> of atomicity in the check and subsequent dereference of the upper layer
>>> callback function. Fixed with cmpxchg before unmap and callback.
>>> 2) Regression in unaligned IO constraining workaround for p420m devices.
>>> Fixed by checking if IO is unaligned and using proper semaphore if so.
>>
>> Sam, what is this patch against? It doesn't apply to -rc6 and it doesn't
>> apply to for-3.15/drivers (the latter would be preferred/required). It
>> also seems to have line break issues.
>>
>
> It's against for-3.15/drivers.  Sorry about the breaks; if I remove them
> does it apply cleanly?

Yep, this one is much better. Thanks!

-- 
Jens Axboe

