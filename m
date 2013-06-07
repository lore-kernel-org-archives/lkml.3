Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab3FGH7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:59:03 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44919 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3FGH7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:59:01 -0400
X-AuditID: 9c93017d-b7c30ae0000063eb-e0-51b192c37638
Date: Fri, 7 Jun 2013 16:58:58 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Jiang Liu <jiang.liu@huawei.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 01/10] zram: avoid invalid memory access in zram_exit()
Message-ID: <20130607075858.GA22516@blaptop>
References: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com>
 <1370534851-26056-2-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370534851-26056-2-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jiang,

On Fri, Jun 07, 2013 at 12:07:22AM +0800, Jiang Liu wrote:
> Memory for zram->disk object may have already been freed after returning
> from destroy_device(zram), then it's unsafe for zram_reset_device(zram)
> to access zram->disk again.
> 
> We can't solve this bug by flipping the order of destroy_device(zram)
> and zram_reset_device(zram), that will cause deadlock issues to the
> zram sysfs handler.

Sorry for bothering you with description nitpick.

I agree your approach is so simple that I'd like to give Ack
but your description is not clear.

If you really want to say deadlock issue with flipping approach,
please add enough explain how the deadlock happens.(But not sure
it is worth that we should keep the problem of deadlock issue of
flipping approach in changelog)

Otherwise, it's enough with first paragraph because this bug is
very simple and plain. I prefer latter because I want that 
other developers don't waste their time to understand a deadlock issue
of flipping approach)

> 
> So fix it by holding an extra reference to zram->disk before calling
> destroy_device(zram).
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: stable@vger.kernel.org

Acked-by: Minchan Kim <minchan@kernel.org>

But please rewrite the description.

-- 
Kind regards,
Minchan Kim
