Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3FDNJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:09:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab3FDNJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:09:23 -0400
Message-ID: <51ADE6F1.90709@redhat.com>
Date: Tue, 04 Jun 2013 15:09:05 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/8] zram: simplify and optimize zram_to_dev()
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com> <1370274140-26420-2-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1370274140-26420-2-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please write a commit message, no matter how straightforward a patch may
seem to you.
Also the subject suffers from dyslexia: it's dev_to_zram, not zram_to_dev.

Thanks,
Jerome

On 06/03/2013 05:42 PM, Jiang Liu wrote:
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  drivers/staging/zram/zram_sysfs.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
> index e6a929d..8cb7822 100644
> --- a/drivers/staging/zram/zram_sysfs.c
> +++ b/drivers/staging/zram/zram_sysfs.c
> @@ -30,18 +30,9 @@ static u64 zram_stat64_read(struct zram *zram, u64 *v)
>  	return val;
>  }
>  
> -static struct zram *dev_to_zram(struct device *dev)
> +static inline struct zram *dev_to_zram(struct device *dev)
>  {
> -	int i;
> -	struct zram *zram = NULL;
> -
> -	for (i = 0; i < zram_get_num_devices(); i++) {
> -		zram = &zram_devices[i];
> -		if (disk_to_dev(zram->disk) == dev)
> -			break;
> -	}
> -
> -	return zram;
> +	return (struct zram *)dev_to_disk(dev)->private_data;
>  }
>  
>  static ssize_t disksize_show(struct device *dev,
> 

