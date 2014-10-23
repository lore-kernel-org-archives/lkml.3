Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbaJWOMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:12:10 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46601 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbaJWOMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:12:06 -0400
Message-ID: <54490CB6.80306@kernel.dk>
Date: Thu, 23 Oct 2014 08:12:06 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: wrong return value
References: <1414070409-4566-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1414070409-4566-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 07:20 AM, Sudip Mukherjee wrote:
> while compiling integer err was showing as a set but unused variable.
> elevator_init_fn can be either cfq_init_queue or deadline_init_queue
> or noop_init_queue.
> all three of these functions are returning -ENOMEM if they fail to
> allocate the queue. 
> so we should actually be returning the error code rather than
> returning 0 always.

That does look weird. You need an elevator_put() in the error case,
though, ala:

err = e->ops.elevator_init_fn(q, e);
if (err)
	elevator_put(e);

return err;


-- 
Jens Axboe

