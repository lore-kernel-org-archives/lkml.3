Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaGUIeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:34:24 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:53345 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaGUIeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:34:23 -0400
Message-ID: <53CCD08C.80702@kernel.dk>
Date: Mon, 21 Jul 2014 10:34:20 +0200
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: bitmap tag: fix potential unwakeable sleep in
 bt_get()
References: <1405930246-2051-1-git-send-email-agordeev@redhat.com> <53CCCC76.7060506@kernel.dk> <20140721083202.GA2107@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140721083202.GA2107@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-21 10:32, Alexander Gordeev wrote:
> On Mon, Jul 21, 2014 at 10:16:54AM +0200, Jens Axboe wrote:
>> What is this patch against?
>
> v3.16-rc5

My bad, was looking at the wrong sources. What is the race? If the clear 
and wakeup come in after the prepare_to_wait() but before the 
io_schedule(), the io_schedule() will be a no-op and it wont actually 
sleep. Your commit message doesn't mention any particular details.


-- 
Jens Axboe

