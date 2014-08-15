Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaHOShN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:37:13 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:63264 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaHOShL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:37:11 -0400
Message-ID: <53EE534F.2040208@kernel.dk>
Date: Fri, 15 Aug 2014 12:37:03 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
CC: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-mq: fix WARNING "percpu_ref_kill() called more than
 once!"
References: <1408115792-3311-1-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1408115792-3311-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-15 09:16, Ming Lei wrote:
> Before doing queue release, the queue has been freezed already
> by blk_cleanup_queue(), so needn't to freeze queue for deleting
> tag set.
>
> This patch fixes the WARNING of "percpu_ref_kill() called more than once!"
> which is triggered during unloading block driver.

Thanks, you are right, we need not call it there. I'll apply this for 3.17.

-- 
Jens Axboe

