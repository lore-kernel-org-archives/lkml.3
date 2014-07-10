Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaGJJHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:07:33 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:33833 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaGJJH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:07:26 -0400
Message-ID: <53BE57CA.9020807@kernel.dk>
Date: Thu, 10 Jul 2014 11:07:22 +0200
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org
CC: drbd-dev@lists.linbit.com
Subject: Re: [PATCH] drbd: fix regression 'out of mem, failed to invoke fence-peer
 helper'
References: <1404933512-5166-1-git-send-email-philipp.reisner@linbit.com> <1404933512-5166-2-git-send-email-philipp.reisner@linbit.com>
In-Reply-To: <1404933512-5166-2-git-send-email-philipp.reisner@linbit.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-09 21:18, Philipp Reisner wrote:
> From: Lars Ellenberg <lars.ellenberg@linbit.com>
>
> Since linux kernel 3.13, kthread_run() internally uses
> wait_for_completion_killable().  We sometimes may use kthread_run()
> while we still have a signal pending, which we used to kick our threads
> out of potentially blocking network functions, causing kthread_run() to
> mistake that as a new fatal signal and fail.
>
> Fix: flush_signals() before kthread_run().

Applied - should this have been marked stable, if it affects 3..13+ kernels?

-- 
Jens Axboe

