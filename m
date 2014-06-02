Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaFBPT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:19:58 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50056 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaFBPT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:19:57 -0400
Message-ID: <538C961B.6070605@kernel.dk>
Date: Mon, 02 Jun 2014 09:19:55 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] blk-mq: fix schedule from atomic context
References: <1401554617-10099-1-git-send-email-tom.leiming@gmail.com> <1401554617-10099-3-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1401554617-10099-3-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-31 10:43, Ming Lei wrote:
> blk_mq_put_ctx() has to be called before io_schedule() in
> bt_get().
>
> This patch fixes the problem by taking similar approach from
> percpu_ida allocation for the situation.

Thanks, I've applied these to for post-merge integration. I do think we 
can clean up further around 'data' for bt_get(), for instance, and 
possibly in other places too.

-- 
Jens Axboe

