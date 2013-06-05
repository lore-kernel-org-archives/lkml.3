Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab3FEHDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:03:36 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47653 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3FEHDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:03:24 -0400
X-AuditID: 9c93017d-b7c30ae0000063eb-ee-51aee2ba4eab
Date: Wed, 5 Jun 2013 16:03:22 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/10] zram: protect sysfs handler from invalid memory
 access
Message-ID: <20130605070322.GH8732@blaptop>
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
 <1370361968-8764-8-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370361968-8764-8-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 12:06:06AM +0800, Jiang Liu wrote:
> Use zram->init_lock to protect access to zram->meta, otherwise it
> may cause invalid memory access if zram->meta has been freed by
> zram_reset_device().
> 
> This issue may be triggered by:
> Thread 1:
> while true; do cat mem_used_total; done
> Thread 2:
> while true; do echo 8M > disksize; echo 1 > reset; done
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: stable@vger.kernel.org

Acked-by: Minchan Kim <minchan@kernel.org>


-- 
Kind regards,
Minchan Kim
