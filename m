Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbaHYOEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:04:55 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:52231 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbaHYOEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:04:52 -0400
Message-ID: <53FB4283.4020704@cybernetics.com>
Date: Mon, 25 Aug 2014 10:04:51 -0400
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: dgilbert@interlog.com, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][SCSI] scsi-mq: fix requests that use a separate CDB buffer
References: <53F79FC3.6040907@cybernetics.com> <53F8E6EC.5060702@interlog.com>
In-Reply-To: <53F8E6EC.5060702@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2014 03:09 PM, Douglas Gilbert wrote:
>> For inclusion in 3.17 only.
> May want to check if blk-mq work in lk 3.16 and earlier
> breaks the bsg driver's capability to send SCSI cdbs
> that are longer than 16 bytes.
>
>

I think 3.16 and earlier are OK.  The problem was caused by
scsi_mq_prep_fn(), which is new in 3.17.

Thanks for testing.

Tony
