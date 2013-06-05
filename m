Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3FEGEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 02:04:48 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:60046 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab3FEGEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 02:04:44 -0400
X-AuditID: 9c93017e-b7bd9ae000006882-c3-51aed4fa7f89
Date: Wed, 5 Jun 2013 15:04:42 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/10] zram: avoid invalid memory access in zram_exit()
Message-ID: <20130605060442.GB8732@blaptop>
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
 <1370361968-8764-2-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370361968-8764-2-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 12:06:00AM +0800, Jiang Liu wrote:
> Memory for zram->disk object may have already been freed after returning
> from destroy_device(zram), then it's unsafe for zram_reset_device(zram)
> to access zram->disk again.
> 
> We can't solve this bug by flipping the order of destroy_device(zram)
> and zram_reset_device(zram), that will cause deadlock issues to the
> zram sysfs handler.

What kinds of deadlock happen?
Could you elaborate it more?

-- 
Kind regards,
Minchan Kim
