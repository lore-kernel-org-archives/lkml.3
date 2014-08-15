Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaHOSrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:47:41 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48773 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaHOSrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:47:39 -0400
Message-ID: <53EE55C9.7090908@kernel.dk>
Date: Fri, 15 Aug 2014 12:47:37 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sagi Grimberg <sagig@mellanox.com>, martin.petersen@oracle.com
CC: kmo@daterainc.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Fix BUG_ON when pi errors occur
References: <1407930571-26532-1-git-send-email-sagig@mellanox.com>
In-Reply-To: <1407930571-26532-1-git-send-email-sagig@mellanox.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 05:49 AM, Sagi Grimberg wrote:
> When getting a pi error we get to bio_integrity_end_io with
> bi_remaining already decremented to 0 where we will eventually
> need to call bio_endio with restored original bio completion handler.
> Calling bio_endio invokes a BUG_ON(). We should call bio_endio_nodec
> instead, like what is done in bio_integrity_verify_fn.

Applied, thanks.

-- 
Jens Axboe

