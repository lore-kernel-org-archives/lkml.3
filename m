Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3FGJ3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:29:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab3FGJ3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:29:37 -0400
Message-ID: <51B1A7F0.8010406@redhat.com>
Date: Fri, 07 Jun 2013 11:29:20 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 01/10] zram: avoid invalid memory access in zram_exit()
References: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com> <1370534851-26056-2-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1370534851-26056-2-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 06:07 PM, Jiang Liu wrote:
> Memory for zram->disk object may have already been freed after returning
> from destroy_device(zram), then it's unsafe for zram_reset_device(zram)
> to access zram->disk again.
> 
> We can't solve this bug by flipping the order of destroy_device(zram)
> and zram_reset_device(zram), that will cause deadlock issues to the
> zram sysfs handler.
> 
> So fix it by holding an extra reference to zram->disk before calling
> destroy_device(zram).
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: stable@vger.kernel.org

Acked-by: Jerome Marchand <jmarchan@redhat.com>


