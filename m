Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3LRK3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:29:38 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:59075 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3LRK3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:29:36 -0500
Message-ID: <52B1790A.5070105@bjorling.me>
Date: Wed, 18 Dec 2013 11:29:30 +0100
From: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, Huang Ying <ying.huang@intel.com>,
        Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: changes caused by 0d11e6ac("blk-mq: fix use-after-free of request")
References: <20131218085007.GP31783@yliu-dev.sh.intel.com>
In-Reply-To: <20131218085007.GP31783@yliu-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 09:50 AM, Yuanhan Liu wrote:
> Hi,
>
> FYI, we noticed some changes caused by 0d11e6ac("blk-mq: fix use-after-free of request"):
>

The blk-mq accounting was faulty up to that commit. We should compare 
the blk-mq with the previous block layer.

Could you try to revert the following patches:

f02b9ac virtio-blk: virtqueue_kick() must be ordered with other...
1cf7e9c virtio_blk: blk-mq support

and compare the two runs (upto 0d11e6ac applied, and the same, with the 
two patches reverted)

Thanks

<snip>
