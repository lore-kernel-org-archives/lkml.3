Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbaJIVQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:16:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59789 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbaJIVQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:16:05 -0400
Message-ID: <1412889358.14046.113.camel@fourier>
Subject: Re: [PATCH 3.13 026/163] block: Fix dev_t minor allocation lifetime
From: Kamal Mostafa <kamal@canonical.com>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Keith Busch <keith.busch@intel.com>
Date: Thu, 09 Oct 2014 14:15:58 -0700
In-Reply-To: <5436F974.6000605@fb.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
	 <1412888588-26755-27-git-send-email-kamal@canonical.com>
	 <5436F974.6000605@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-09 at 15:09 -0600, Jens Axboe wrote:
> On 10/09/2014 03:00 PM, Kamal Mostafa wrote:
> > 3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.
> 
> You need this one as well, like I told Greg the other day:


Okay, this one is now queued for 3.13.11.9 also.  Thanks Jens!

 -Kamal


> commit 46f341ffcfb5d8530f7d1e60f3be06cce6661b62
> Author: Jens Axboe <axboe@fb.com>
> Date:   Tue Sep 16 13:38:51 2014 -0600
> 
>     genhd: fix leftover might_sleep() in blk_free_devt()
> 
>     Commit 2da78092 changed the locking from a mutex to a spinlock,
>     so we now longer sleep in this context. But there was a leftover
>     might_sleep() in there, which now triggers since we do the final
>     free from an RCU callback. Get rid of it.
> 
>     Reported-by: Pontus Fuchs <pontus.fuchs@gmail.com>
>     Signed-off-by: Jens Axboe <axboe@fb.com>
> 


