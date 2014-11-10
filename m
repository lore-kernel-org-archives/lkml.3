Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaKJWnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:43:52 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48473 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaKJWnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:43:51 -0500
Message-ID: <54613FA4.8040802@kernel.dk>
Date: Mon, 10 Nov 2014 15:43:48 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tony Battersby <tonyb@cybernetics.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Fix more error handling in SCSI_IOCTL_SEND_COMMAND
References: <54613EC2.8010304@cybernetics.com>
In-Reply-To: <54613EC2.8010304@cybernetics.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-10 15:40, Tony Battersby wrote:
> Fix an error path in SCSI_IOCTL_SEND_COMMAND that calls
> blk_put_request(rq) on an invalid IS_ERR(rq) pointer.
>
> Fixes: a492f075450f ("block,scsi: fixup blk_get_request dead queue scenarios")
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>

Thanks, good catch. Might be an idea to have blk_put_request() do 
warn-and-return check on error pointers being passed in, just in case.

-- 
Jens Axboe

