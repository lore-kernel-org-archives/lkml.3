Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab3FGJlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:41:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab3FGJlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:41:49 -0400
Message-ID: <51B1AACD.7070403@redhat.com>
Date: Fri, 07 Jun 2013 11:41:33 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 06/10] zram: protect sysfs handler from invalid memory
 access
References: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com> <1370534851-26056-7-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1370534851-26056-7-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 06:07 PM, Jiang Liu wrote:
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
> Acked-by: Minchan Kim <minchan@kernel.org>
> Cc: stable@vger.kernel.org

Acked-by: Jerome Marchand <jmarchan@redhat.com>

