Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaCMVCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:02:50 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:56633 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaCMVCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:02:49 -0400
Message-ID: <53221CF5.2080000@kernel.dk>
Date: Thu, 13 Mar 2014 15:02:45 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sam Bradshaw <sbradshaw@micron.com>
CC: linux-kernel@vger.kernel.org, Felipe Franciosi <felipe@paradoxo.org>,
        david.vrabel@citrix.com,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa)" 
	<asamymuthupa@micron.com>
Subject: Re: [PATCH] mtip32xx: mtip_async_complete() bug fixes
References: <53221E92.3030707@micron.com>
In-Reply-To: <53221E92.3030707@micron.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 03:09 PM, Sam Bradshaw wrote:
> This patch fixes 2 issues in the fast completion path:
> 1) Possible double completions / double dma_unmap_sg() calls due to lack
> of atomicity in the check and subsequent dereference of the upper layer
> callback function.  Fixed with cmpxchg before unmap and callback.
> 2) Regression in unaligned IO constraining workaround for p420m devices.
>   Fixed by checking if IO is unaligned and using proper semaphore if so.

Sam, what is this patch against? It doesn't apply to -rc6 and it doesn't 
apply to for-3.15/drivers (the latter would be preferred/required). It 
also seems to have line break issues.

-- 
Jens Axboe

