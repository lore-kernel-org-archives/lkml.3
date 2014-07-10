Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaGJJ4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:56:03 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52309 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaGJJ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:56:01 -0400
Message-ID: <53BE632E.5040408@kernel.dk>
Date: Thu, 10 Jul 2014 11:55:58 +0200
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [PATCH] drbd: fix regression 'out of mem, failed to invoke fence-peer
 helper'
References: <1404933512-5166-1-git-send-email-philipp.reisner@linbit.com> <1404933512-5166-2-git-send-email-philipp.reisner@linbit.com> <53BE57CA.9020807@kernel.dk> <2397073.C8BSPuutsL@fat-tyre>
In-Reply-To: <2397073.C8BSPuutsL@fat-tyre>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-10 11:53, Philipp Reisner wrote:
> Am Donnerstag, 10. Juli 2014, 11:07:22 schrieb Jens Axboe:
>> On 2014-07-09 21:18, Philipp Reisner wrote:
>>> From: Lars Ellenberg <lars.ellenberg@linbit.com>
>>>
>>> Since linux kernel 3.13, kthread_run() internally uses
>>> wait_for_completion_killable().  We sometimes may use kthread_run()
>>> while we still have a signal pending, which we used to kick our threads
>>> out of potentially blocking network functions, causing kthread_run() to
>>> mistake that as a new fatal signal and fail.
>>>
>>> Fix: flush_signals() before kthread_run().
>>
>> Applied - should this have been marked stable, if it affects 3..13+ kernels?
>
> Yes, you are right. It should go to the stable kernels since 3.13 as
> well.

Alright, we'll have to notify Greg/stable when it goes in.

> What is the correct way for me to mark it as stable when sending a patch?

You just add a:

Cc: stable@kernel.org

where the signed-off-by is. If you know the versions it should be 
applied to, you can add that information as well. For this case, you 
would have done:

Cc: stable@kernel.org # v3.13+

to get it into 3.13 stable and later.

-- 
Jens Axboe

