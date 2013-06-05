Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab3FEMCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:02:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab3FEMC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:02:29 -0400
Message-ID: <51AF28C4.3040405@redhat.com>
Date: Wed, 05 Jun 2013 14:02:12 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/10] zram: use atomic64_xxx() to replace zram_stat64_xxx()
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com> <1370361968-8764-10-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1370361968-8764-10-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 06:06 PM, Jiang Liu wrote:
> Use atomic64_xxx() to replace open-coded zram_stat64_xxx().
> Some architectures have native support of atomic64 operations,
> so we can get rid of the spin_lock() in zram_stat64_xxx().
> On the other hand, for platforms use generic version of atomic64
> implement, it may cause an extra save/restore of the interrupt
> flag.  So it's a tradeoff.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>

Before optimizing stats, I'd like to make sure that they're correct.
What makes 64 bits fields so different that they need atomicity while
32 bits wouldn't? Actually all of them save compr_size only increase,
which would make a race less critical than for 32 bits fields that all
can go up and down (if a decrement overwrites a increment, the counter
can wrap around zero).

Jerome

