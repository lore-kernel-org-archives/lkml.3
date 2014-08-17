Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaHQRr2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:47:28 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:54952 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaHQRr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:47:26 -0400
Message-ID: <53F0EAA2.3030702@kernel.dk>
Date: Sun, 17 Aug 2014 11:47:14 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: blk_mq_freeze_queue() should allow nesting
References: <1408115792-3311-1-git-send-email-ming.lei@canonical.com> <53EE534F.2040208@kernel.dk> <20140816120224.GB9305@htj.dyndns.org>
In-Reply-To: <20140816120224.GB9305@htj.dyndns.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-16 06:02, Tejun Heo wrote:
> While converting to percpu_ref for freezing, add703fda981 ("blk-mq:
> use percpu_ref for mq usage count") incorrectly made
> blk_mq_freeze_queue() misbehave when freezing is nested due to
> percpu_ref_kill() being invoked on an already killed ref.
>
> Fix it by making blk_mq_freeze_queue() kill and kick the queue only
> for the outermost freeze attempt.  All the nested ones can simply wait
> for the ref to reach zero.
>
> While at it, remove unnecessary @wake initialization from
> blk_mq_unfreeze_queue().
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Ming Lei <ming.lei@canonical.com>
> ---
> Hello, Ming, Jens.
>
> I think something like this is the correct solution.  Freezing should
> be nestable after all.  Ming, can you please verify whether this fixes
> the issue you're seeing?

I had completely missed that nesting no longer works, which it of course 
should. Mings patch is still fine, however, as we don't need the freeze 
at that point. But I'll apply yours as well so that nesting is restored, 
it might be important for other cases. And it's one of those things that 
we should not have to worry about.

-- 
Jens Axboe

